using Gee;
using Catapult.Helpers;

namespace Catapult.Yaml
{
	public class NodeBuilder
	{
		public Node build<T>(T value) {
			Value val = ValueHelper.populate_value<T>(value);
			return build_value(val);
		}

		public Node build_value(Value value) {
			return BuildValueAssert(value);
		}

		public Node build_yaml_object(IYamlObject yaml_object) {
			return yaml_object.i_build_yaml_node(this);
		}
		public MappingNode build_object_mapping(Object obj) {
			return BuildObjectMapping(obj);
		}
		public void populate_object_mapping(MappingNode node, Object obj) {
			PopulateObjectMapping(node, obj);
		}
		public bool add_object_mapping(MappingNode node, Object obj, ParamSpec property) {
			return AddObjectPropertyMapping(node, obj, property);
		}
		public void populate_mapping<K,V>(MappingNode node, Map<K,V> map) {
			foreach(var entry in map.entries)
				add_mapping<K,V>(node, entry.key, entry.value);
		}
		public void add_mapping<K,V>(MappingNode node, K key, V value) {
			Value keyValue = ValueHelper.populate_value<K>(key);
			Value valueValue = ValueHelper.populate_value<V>(value);
			add_mapping_values(node, keyValue, valueValue);
		}
		public void add_mapping_values(MappingNode node, Value key, Value value) {
			try {
				var keyNode = BuildValueSupportingEntityReference(key);
				var valueNode = BuildValueSupportingEntityReference(value);
				node[keyNode] = valueNode;
			} catch (Error e) {
				debug(e.message);
				assert_not_reached();
			}
		}
		public void add_sequence_value(SequenceNode node, Value value) {
			var valueNode = BuildValueAssertSupportingEntityReference(value);
			node.add(valueNode);
		}

		Node BuildValue(Value value) throws RuntimeError
		{
			if (value.holds(typeof(Object)))
				return BuildObject(value.get_object());

			Type type = value.type();
//~ 			if (type == typeof(void *)) {
//~ 				debug("before peek...");
//~ 				var pointer = value.peek_pointer();
//~ 				debug("pointer: %d", (int)pointer);
//~ 				if (pointer == null) {
//~ 					debug("null pointer...");
//~ 					return BuildNull();
//~ 				}
//~ 				type = Type.from_instance(pointer);
//~ 				debug("after from_instance:");
//~ 				debug("pointer to %s...", type.name());
//~ 				if (Value.type_compatible(type, typeof(Object)))
//~ 					return BuildObject((Object)value.get_pointer());
//~ 			}
			if (type.is_flags()) {
				uint flags = value.get_flags();
				GLibPatch.FlagsClass klass = (GLibPatch.FlagsClass)type.class_ref();
				var sequenceNode = new SequenceNode();
				foreach(var val in klass.values) {
					if ((flags & val.value) == val.value)
						sequenceNode.add(new ScalarNode(null, Constants.Tag.STR, val.value_nick));
				}
				if (sequenceNode.item_count() == 1)
					return sequenceNode.items().first();
				return sequenceNode;
			}
			string anchor = null; // TODO: support anchors during build?
			string tag = Constants.Tag.STR;
			string str_value = null;
			if (type.is_enum())
				str_value = ((EnumClass)type.class_ref()).get_value(value.get_enum()).value_nick;
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
				if (type == typeof(Date)) {
					Date? dt = (Date?)value.get_boxed();
					var buffer = new char[64];
					dt.strftime(buffer, "%x");
					str_value = (string)buffer;
					tag = Constants.Tag.TIMESTAMP;
				} else {
					throw new RuntimeError.ARGUMENT("Unsupported BOXED type: " + type.name());
					//assert_not_reached();
				}
			}
			else if (type.is_classed())
				debug("Is Classed: %s", type.name());
			else {
				throw new RuntimeError.ARGUMENT("Unsupported type: " + type.name());
				//assert_not_reached();
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
					var keyNode = BuildValueAssertSupportingEntityReference(key);
					var valueNode = BuildValueAssertSupportingEntityReference(val);
					mappingNode[keyNode] = valueNode;
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
					var node = BuildValueAssertSupportingEntityReference(value);
					sequenceNode.add(node);
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
				var keyNode = BuildValueAssert(property.name);
				Value existing_prop_value = Value(property.value_type);
				obj.get_property(property.name, ref existing_prop_value);
				Node valueNode = null;
				valueNode = BuildValueAssertSupportingEntityReference(existing_prop_value, obj);
				node[keyNode] = valueNode;
				return true;
			}
			return false;
		}

		Node BuildValueSupportingEntityReference(Value value) throws RuntimeError
		{
			Type type = value.type();
			if (type.is_a(typeof(Entity)))
			{
				var entity = (Entity)value.get_object();
				string id = entity.id;
				if (id == null)
					id = entity.i_generate_id();
				return BuildValue(id);
			}
			return BuildValue(value);
		}
		Node BuildValueAssert(Value value) {
			try {
				return BuildValue(value);
			} catch (Error e) {
				debug(e.message);
				assert_not_reached();
			}
		}
		Node BuildValueAssertSupportingEntityReference(Value value, Object? obj=null) {
			try {
				return BuildValueSupportingEntityReference(value);
			} catch (Error e) {
				if (obj != null) {
					var yobj = obj as IYamlObject;
					if (yobj != null) {
						var node = yobj.i_build_unhandled_value_node(this, value);
						if (node != null)
							return node;
					}
				}
				debug(e.message);
				assert_not_reached();
			}
		}
	}
}
