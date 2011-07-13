using Gee;
using Catapult.Helpers;

namespace Catapult.Yaml
{
	public class NodeParser
	{
		DataInterface data_interface;
		public NodeParser(DataInterface data_interface) {
			this.data_interface = data_interface;
		}

		public T parse<T>(Node node, T default_value)
		{
			Value? inval = null;
			if (default_value != null)
				inval = ValueHelper.populate_value<T>(default_value);
			Value v = ParseValue(node, typeof(T), inval);
			return ValueHelper.extract_value<T>(v);
		}

		public Value parse_value(Node node, Value? default_value=null) {
			return (default_value == null)
				? ParseValue(node)
				: ParseValue(node, null, default_value);
		}
		public Value parse_value_of_type(Node node, Type type, Value? default_value=null) { return ParseValue(node, type, default_value); }

		public void populate_object(MappingNode node, Object obj) {
			PopulateObjectProperties(node, obj);
		}
		public bool populate_object_property(MappingNode node, ScalarNode keyNode, Object obj) {
			ParamSpec property = ((ObjectClass)obj.get_type().class_peek()).find_property(keyNode.Value);
			return PopulateObjectProperty(node, keyNode, obj, property);
		}


		Value ParseValue(Node node, Type? type=null, Value? default_value=null) {
			Type? intype = type;
			Object invalObj = null;
			if (default_value != null)
			{
				if (default_value.holds(typeof(Object)))
					invalObj = default_value.get_object();
				intype = (invalObj != null) ? invalObj.get_type() : default_value.type();
			}
			if (intype != null && intype.is_a(typeof(IYamlObject))) {
				IYamlObject yamlObj = (invalObj == null)
					? Object.new(intype) as IYamlObject
					: (IYamlObject)invalObj;
				yamlObj.i_apply_yaml_node(node, this);
				Value val = Value(intype);
				val.set_object(yamlObj);
				return val;
			}

			switch(node.Type)
			{
				case NodeType.SCALAR:
					return ParseScalar(node as ScalarNode, intype, default_value);
				case NodeType.MAPPING:
					return ParseMapping(node as MappingNode, intype, default_value);
				case NodeType.SEQUENCE:
					return ParseSequence(node as SequenceNode, intype, default_value);
				default:
					break;
			}
			return default_value;
		}

		Value ParseScalar(ScalarNode scalar, Type? type=null, Value? default_value=null)
		{
			Type t;
			if (type == null) {
				Type? tag_type = get_tag_type(scalar.Tag);
				t = (tag_type == null) ? typeof(string) : tag_type;
			} else {
				t = type;
			}

			Value v = Value(t);
			if (scalar.Tag == YAML.NULL_TAG)
				return v;
			if (t.is_flags()) {
				unowned GLibPatch.FlagsValue? flags_value = ((GLibPatch.FlagsClass)t.class_ref()).get_value_by_nick(scalar.Value);
				if (flags_value != null)
					v.set_flags(flags_value.value);
			}
			else if (t.is_enum()) {
				var enum_value = ((EnumClass)type.class_ref()).get_value_by_nick(scalar.Value);
				if (enum_value != null)
					v.set_enum(enum_value.value);
			}
			else if (t == typeof(string))
				v.set_string(scalar.Value);
			else if (t == typeof(int))
				v.set_int(int.parse(scalar.Value));
			else if (t == typeof(bool))
				v.set_boolean(bool.parse(scalar.Value));
			else if (t == typeof(double))
				v.set_double(double.parse(scalar.Value));
			else if (t == typeof(Date))
			{
				Date d = Date();
				d.set_parse(scalar.Value);
				if (d.valid() == false) {
					debug("Could not parse GDate from '%s'", scalar.Value);
					d = Date();
					d.set_time_t(0);
				}
				v = d;
			}
			else
				return default_value;

			return v;
		}

		Value ParseMapping(MappingNode mapping, Type? type=null, Value? default_value=null)
		{
			Type t;
			if (default_value != null) {
				t = default_value.type();
			} else if (type != null) {
				t = type;
			} else {
				Type? tag_type = get_tag_type(mapping.Tag);
				t = (tag_type == null) ? typeof(HashMap) : tag_type;
			}

			Value v = Value(t);

			if (t.is_a(typeof(Map))) {
				Map map = (default_value != null) ? (Map)default_value.get_object() : null;
				Type key_type;
				Type value_type;
				if (map == null) {
					debug("No instance of generic type %s given. Element type cannot be determined without an instance.", t.name());
					assert_not_reached();
				}
				key_type = IndirectGenericsHelper.Gee.Map.key_type(map);
				value_type = IndirectGenericsHelper.Gee.Map.value_type(map);
				var indirect_map = IndirectGenericsHelper.Gee.Map.indirect(key_type, value_type);
				foreach(var keyNode in mapping.Mappings.keys) {
					var valueNode = mapping.Mappings[keyNode];
					Value key = ParseValueSupportingEntityReference(keyNode, key_type);
					Value value = ParseValueSupportingEntityReference(valueNode, value_type);
					indirect_map.set(map, key, value);
				}
				v.set_object(map);
			} else if (t.is_object()) {
				Object obj = (default_value == null)
					? Object.new(t)
					: default_value.get_object();
				PopulateObjectProperties(mapping, obj);
				v.set_object(obj);
			} else {
				debug("Unsupported mapping type: %s", t.name());
				assert_not_reached();
			}

			return v;
		}
		void PopulateObjectProperties(MappingNode mapping, Object obj)
		{
			Type type = obj.get_type();
			foreach(var keyNode in mapping.Mappings.scalar_keys()) {
				ParamSpec property = ((ObjectClass)type.class_peek()).find_property(keyNode.Value);
				PopulateObjectProperty(mapping, keyNode, obj, property);
			}
		}
		bool PopulateObjectProperty(MappingNode mapping, ScalarNode keyNode, Object obj, ParamSpec? property) {
			if (property == null) {
				debug("Parse error: property '%s' not found on type %s", keyNode.Value, obj.get_type().name());
				return false;
			}
			if ((property.flags & ParamFlags.READWRITE) == ParamFlags.READWRITE) {
				Value existing_prop_value = Value(property.value_type);
				obj.get_property(property.name, ref existing_prop_value);
				Value new_prop_value = ParseValueSupportingEntityReference(mapping.Mappings[keyNode], property.value_type, existing_prop_value);
				obj.set_property(property.name, new_prop_value);
				return true;
			}
			return false;
		}
		Value ParseSequence(SequenceNode sequence, Type? type=null, Value? default_value=null)
		{
			Type t;
			if (default_value != null) {
				t = default_value.type();
			} else if (type != null) {
				t = type;
			} else {
				Type? tag_type = get_tag_type(sequence.Tag);
				t = (tag_type == null) ? typeof(ArrayList) : tag_type;
			}

			Value v = Value(t);

			if (t.is_a(typeof(Collection))) {
				Collection collection = (default_value != null) ? (Collection)default_value.get_object() : null;
				Type element_type;
				if (collection == null) {
					debug("No instance of generic type %s given. Element type cannot be determined without an instance.", t.name());
					assert_not_reached();
				}
				element_type = IndirectGenericsHelper.Gee.Collection.element_type(collection);
				var indirect_collection = IndirectGenericsHelper.Gee.Collection.indirect(element_type);
				foreach(var item in sequence.Items) {
					Value element = ParseValueSupportingEntityReference(item, element_type);
					indirect_collection.add(collection, element);
				}
				v.set_object(collection);
			} else if (t.is_flags()) {
				var flags_class = ((GLibPatch.FlagsClass)t.class_ref());
				uint? flags = null;
				foreach(var scalar in sequence.Items.scalars()) {
					unowned GLibPatch.FlagsValue? flags_value = flags_class.get_value_by_nick(scalar.Value);
					if (flags_value != null)
						flags = (flags == null) ? flags_value.value : ((uint)flags) | flags_value.value;
				}
				if (flags != null)
					v.set_flags(flags);
			} else {
				debug("Unsupported sequence type: %s", t.name());
				assert_not_reached();
			}

			return v;
		}

		Value ParseValueSupportingEntityReference(Node node, Type? type=null, Value? default_value=null)
		{
			if (type != null && type.is_a(typeof(Entity)))
			{
				var scalar = node as ScalarNode;
				if (scalar != null) {
					try {
						var entity = (Entity)data_interface.load_internal(scalar.Value, null, type);
						return entity;
					} catch(Error e) {
						debug("Error loading %s entity id %s: %s", type.name(), scalar.Value, e.message);
					}
				}
			}
			return ParseValue(node, type, default_value);
		}

		public static Type? get_tag_type(string tag)
		{
			if (tagTypeMappings.has_key(tag) == true)
				return tagTypeMappings[tag];
			if (predefinedTypes.has_key(tag) == true)
				return predefinedTypes[tag];

			return null;
		}

		public static void SetTypeTag(Type type, string tag)
		{
			tagTypeMappings[tag] = type;
		}

		static HashMap<string, Type> tagTypeMappings;
		static HashMap<string, Type> predefinedTypes;
		static construct {
			tagTypeMappings = new HashMap<string, Type>();

			predefinedTypes = new HashMap<string, Type>();
			predefinedTypes.set(YAML.MAP_TAG, typeof(HashMap));
			predefinedTypes.set(YAML.SEQ_TAG, typeof(ArrayList));
			predefinedTypes.set(YAML.BOOL_TAG, typeof(bool));
			predefinedTypes.set(YAML.FLOAT_TAG, typeof(double));
			predefinedTypes.set(YAML.INT_TAG, typeof(int));
			predefinedTypes.set(YAML.STR_TAG, typeof(string));
		}

	}
}
