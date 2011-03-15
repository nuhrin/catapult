using Gee;
using YamlDB.Helpers;

namespace YamlDB.Yaml
{
	public class NodeBuilder
	{
		public Node build<T>(T value)
		{
			Value val = ValueHelper.extract_value<T>(value);
			return build_value(val);
		}

		public Node build_value(Value value)
		{
			return BuildValue(value);
		}

		public Node build_yaml_object(IYamlObject yaml_object)
		{
			return yaml_object.i_build_yaml_node(this);
		}
		public MappingNode build_object_mapping(Object obj)
		{
			return BuildObjectMapping(obj);
		}
		public void populate_object_mapping(MappingNode node, Object obj)
		{
			PopulateObjectMapping(node, obj);
		}
		public bool add_object_mapping(MappingNode node, Object obj, ParamSpec property) {
			return AddObjectPropertyMapping(node, obj, property);
		}
		public void add_mapping(MappingNode node, Value key, Value value) {
			var keyNode = BuildValueSupportingEntityReference(key);
			var valueNode = BuildValueSupportingEntityReference(value);
			node.Mappings[keyNode] = valueNode;
		}
		public void add_sequence_value(SequenceNode node, Value value) {
			var valueNode = BuildValueSupportingEntityReference(value);
			node.Items.add(valueNode);
		}


		Node BuildValue(Value value) {
			if (value.holds(typeof(Object)))
				return BuildObject(value.get_object());

			Type type = value.type();
			if (type.is_flags()) {
				var sequenceNode = new SequenceNode();
				var klass = (FlagsClass)type.class_ref();
				foreach(unowned FlagsValue val in klass.values)
					sequenceNode.Items.add(new ScalarNode(null, Constants.Tag.STR, val.value_name));
				return sequenceNode;
			}
			string anchor = null; // TODO: support anchors during build?
			string tag = Constants.Tag.STR;
			string str_value = null;
			if (type.is_enum())
				str_value = ((EnumClass)type.class_ref()).get_value(value.get_enum()).value_name;
			else if (type == typeof(string))
				str_value = value.get_string();
			else if (type == typeof(char))
				str_value = value.get_char().to_string();
			else if (type == typeof(uchar))
				str_value = value.get_uchar().to_string();
			else if (type == typeof(bool)) {
				str_value = value.get_boolean().to_string();
				tag = Constants.Tag.BOOL;
			}
			else if (type == typeof(int)) {
				str_value = value.get_int().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(uint)) {
				str_value = value.get_uint().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(long)) {
				str_value = value.get_long().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(ulong)) {
				str_value = value.get_ulong().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(int64)) {
				str_value = value.get_int64().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(uint64)) {
				str_value = value.get_uint64().to_string();
				tag = Constants.Tag.INT;
			}
			else if (type == typeof(float)) {
				str_value = value.get_float().to_string();
				tag = Constants.Tag.FLOAT;
			}
			else if (type == typeof(double)) {
				str_value = value.get_double().to_string();
				tag = Constants.Tag.FLOAT;
			}
			else if (type == typeof(Type))
				str_value = value.get_gtype().name().dup();

			else if (type.is_a(Type.BOXED)) {
				debug("Got BOXED type: "+type.name());
				if (type.is_a(typeof(DateTime))) {
					DateTime? dt = (DateTime?)value.get_boxed();
					var local = dt.to_local();
					TimeVal tv;
					if (local.to_timeval(out tv)) {
						str_value = tv.to_iso8601();
						tag = Constants.Tag.TIMESTAMP;
					}
				} else {
					debug("Unsupported BOXED type: %s", type.name());
					assert_not_reached();
				}
			}
			else if (type.is_classed())
				debug("Is Classed: %s", type.name());
			else {
				debug("Unsupported type: %s", type.name());
				assert_not_reached();
			}

			if (str_value != null)
				return new ScalarNode(anchor, tag, str_value);

			return BuildNull();
		}

		Node BuildObject(Object obj)
		{
			// if IYamlObject, emit that
			var yamlObj = obj as IYamlObject;
			if (yamlObj != null)
				return build_yaml_object(yamlObj);

			Type type = obj.get_type();

			// if mapping, build that
			if (type.is_a(typeof(Map))) {
				Map map = obj as Map;
				Type key_type = IndirectGenericsHelper.Gee.Map.key_type(map);
				Type value_type = IndirectGenericsHelper.Gee.Map.value_type(map);
				var indirectMap = IndirectGenericsHelper.Gee.Map.indirect(key_type, value_type);
				var keys = indirectMap.get_keys(map);

				var mappingNode = new MappingNode();
				foreach(var key in keys)
				{
					var val = indirectMap.get(map, key);
					var keyNode = BuildValueSupportingEntityReference(key);
					var valueNode = BuildValueSupportingEntityReference(val);
					mappingNode.Mappings[keyNode] = valueNode;
				}
				return mappingNode;
			}

			// if sequence, build that
			if (type.is_a(typeof(Collection))) {
				Collection collection = obj as Collection;
				Type element_type = IndirectGenericsHelper.Gee.Collection.element_type(collection);
				var values = IndirectGenericsHelper.Gee.Collection.indirect(element_type).get_values(collection);

				var sequenceNode = new SequenceNode();
				foreach(var value in values) {
					var node = BuildValueSupportingEntityReference(value);
					sequenceNode.Items.add(node);
				}
				return sequenceNode;
			}

			// build object mapping
			return BuildObjectMapping(obj);
		}

		Node BuildNull()
		{
			return new ScalarNode(null, Constants.Tag.NULL, "", false, false, ScalarStyle.PLAIN);
		}

		MappingNode BuildObjectMapping(Object obj)
		{
			var mappingNode = new MappingNode();
			PopulateObjectMapping(mappingNode, obj);
	    	return mappingNode;
		}
		void PopulateObjectMapping(MappingNode node, Object obj)
		{
			unowned ObjectClass klass = obj.get_class();
	    	var properties = klass.list_properties();
	    	foreach(var prop in properties)
				AddObjectPropertyMapping(node, obj, prop);
		}
		bool AddObjectPropertyMapping(MappingNode node, Object obj, ParamSpec property)
		{
			if ((property.flags & ParamFlags.READWRITE) == ParamFlags.READWRITE) {
				var keyNode = BuildValue(property.name);
				Value existing_prop_value = Value(property.value_type);
				obj.get_property(property.name, ref existing_prop_value);
				var valueNode = BuildValueSupportingEntityReference(existing_prop_value);
				node.Mappings[keyNode] = valueNode;
				return true;
			}
			return false;
		}

		Node BuildValueSupportingEntityReference(Value value)
		{
			Type type = value.type();
			if (type.is_a(typeof(Entity)))
			{
				var entity = (Entity)value.get_object();
				string id = entity.ID;
				if (id == null)
					id = entity.i_generate_id();
				return BuildValue(id);
			}
			return BuildValue(value);
		}
	}
}