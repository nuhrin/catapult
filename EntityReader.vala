using Gee;
using YamlDB.Helpers;
using YamlDB.Yaml.Events;

namespace YamlDB
{
	public class EntityReader
	{
		public EventReader reader { get; private set; }
		public DataInterface data_interface { get; set; }

		public EntityReader(FileStream input, DataInterface data_interface)
		{
			reader = new EventReader(input);
			this.data_interface = data_interface;
		}
		public EntityReader.from_string(string yaml, DataInterface data_interface)
		{
			reader = new EventReader.from_string(yaml);
			this.data_interface = data_interface;
		}

		public T read_value<T>(T example=null) throws YamlError
		{
			Value? inval = null;
			if (example != null)
				inval = ValueHelper.populate_value<T>(example);
			Value v = ReadValue(typeof(T), inval);
			return ValueHelper.extract_value<T>(v);
		}

		public void populate_object(Object obj) throws YamlError
		{
			ReadValue(null, obj);
		}
		public void populate_object_properties(Object obj) throws YamlError
		{
			reader.ensure_document_context();
			PopulateObjectProperties(obj);
		}

		Value ReadValue(Type? type=null, Value? inval=null) throws YamlError
		{
			reader.ensure_stream_start();
			Type? intype = type;
			Object invalObj = null;
			if (inval != null)
			{
				if (inval.holds(typeof(Object)))
					invalObj = inval.get_object();
				intype = (invalObj != null) ? invalObj.get_type() : inval.type();
			}
			if (intype != null && intype.is_a(typeof(YamlObject))) {
				YamlObject obj;
				if (invalObj == null)
					obj = Object.new(intype) as YamlObject;
				else
					obj = (YamlObject)invalObj;
				obj.i_populate_entity_data(obj.i_read_yaml(this));
				Value val = Value(intype);
				val.set_object(obj);
				return val;
			}

			reader.ensure_document_context();
			NodeEvent node_event = reader.Current as NodeEvent;
			if (node_event != null)
			{
				switch(reader.Current.Type)
				{
					case EventType.SCALAR:
						return ReadScalar(intype);
					case EventType.MAPPING_START:
						return ReadMapping(intype, inval);
					case EventType.SEQUENCE_START:
						return ReadSequence(intype, inval);
					default:
						break;
				}
			}
			throw new YamlError.PARSE("Expected scalar, mapping, or sequence, got %s", reader.Current.to_string());
		}
		Value ReadScalar(Type? type=null) throws YamlError
		{
			reader.ensure_document_context();
			Scalar scalar = reader.get<Scalar>();

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
			if (t == typeof(string))
				v.set_string(scalar.Value);
			else if (t == typeof(int))
				v.set_int(int.parse(scalar.Value));
			else if (t == typeof(bool))
				v.set_boolean(bool.parse(scalar.Value));
			else if (t == typeof(double))
				v.set_double(double.parse(scalar.Value));
			else if (t == typeof(DateTime))
			{
				var tv = TimeVal();
				tv.from_iso8601(scalar.Value);
				v = new DateTime.from_timeval_local(tv);
			}

			else
				throw new YamlError.PARSE("Unsupported attempt to parse Type '%s' from a Yaml Scalar.", t.name());

			return v;
		}
		Value ReadMapping(Type? type=null, Value? inval=null) throws YamlError
		{
			reader.ensure_document_context();
			MappingStart mapping = reader.get<MappingStart>();

			Type t;
			if (inval != null) {
				t = inval.type();
			} else if (type != null) {
				t = type;
			} else {
				Type? tag_type = get_tag_type(mapping.Tag);
				t = (tag_type == null) ? typeof(HashMap) : tag_type;
			}

			Value v = Value(t);

			if (t.is_a(typeof(Map))) {
				Map map = (inval != null) ? (Map)inval.get_object() : null;
				Type key_type;
				Type value_type;
				if (map == null) {
					debug("No instance of generic type %s given. Element type cannot be determined without an instance.", t.name());
					assert_not_reached();
				}
				key_type = IndirectGenericsHelper.Gee.Map.key_type(map);
				value_type = IndirectGenericsHelper.Gee.Map.value_type(map);
				var indirect_map = IndirectGenericsHelper.Gee.Map.indirect(key_type, value_type);
				while(reader.Current.Type != EventType.MAPPING_END) {
					Value key = ReadValueSupportingEntityReference(key_type);
					Value value = ReadValueSupportingEntityReference(value_type);
					indirect_map.set(map, key, value);
				}
				v.set_object(map);
			} else if (t.is_object()) {
				Object obj;
				if (inval == null)
					obj = Object.new(t);
				else
					obj = ValueHelper.extract_value<Object>(inval);
				PopulateObjectProperties(obj);
				v.set_object(obj);
			} else {
				debug("Unsupported mapping type: %s", t.name());
				assert_not_reached();
			}

			reader.get<MappingEnd>();

			return v;
		}
		void PopulateObjectProperties(Object obj) throws YamlError
		{
			Type type = obj.get_type();
			reader.get<MappingStart>();
			while(reader.Current.Type != EventType.MAPPING_END) {
				string propertyName = reader.get<Scalar>().Value;
				ParamSpec pspec = ((ObjectClass)type.class_peek()).find_property(propertyName);
				if (pspec == null) {
					throw new YamlError.PARSE("Entity parse error: property '%s' not found on type '%s'",
						propertyName, type.name());
				}

				// TODO: some sort of property flag/include/exclude logic here
				Value existing_prop_value = Value(pspec.value_type);
				obj.get_property(propertyName, ref existing_prop_value);
				Value new_prop_value = ReadValueSupportingEntityReference(pspec.value_type, existing_prop_value);
				obj.set_property(propertyName, new_prop_value);
				// TODO: actually implement the property setter correctly
			}
		}
		Value? ReadSequence(Type? type=null, Value? inval=null) throws YamlError
		{
			reader.ensure_document_context();
			SequenceStart sequence = reader.get<SequenceStart>();

			Type t;
			if (inval != null) {
				t = inval.type();
			} else if (type != null) {
				t = type;
			} else {
				Type? tag_type = get_tag_type(sequence.Tag);
				t = (tag_type == null) ? typeof(ArrayList) : tag_type;
			}

			Value v = Value(t);

			if (t.is_a(typeof(Collection))) {
				Collection collection = (inval != null) ? (Collection)inval.get_object() : null;
				Type element_type;
				if (collection == null) {
					debug("No instance of generic type %s given. Element type cannot be determined without an instance.", t.name());
					assert_not_reached();
				}
				element_type = IndirectGenericsHelper.Gee.Collection.element_type(collection);
				var indirect_collection = IndirectGenericsHelper.Gee.Collection.indirect(element_type);
				while(reader.Current.Type != EventType.SEQUENCE_END) {
					Value element = ReadValueSupportingEntityReference(element_type);
					indirect_collection.add(collection, element);
				}
				v.set_object(collection);
			} else {
				debug("Unsupported sequence type: %s", t.name());
				assert_not_reached();
			}

			reader.get<SequenceEnd>();

			return v;
		}

		Value ReadValueSupportingEntityReference(Type? type=null, Value? inval=null) throws YamlError
		{
			if (type != null && type.is_a(typeof(Entity.Entity)))
			{
				string entityId = reader.get<Scalar>().Value;
				return data_interface.load_internal(entityId, null, type);
			}
			return ReadValue(type, inval);
		}


		Type? get_tag_type(string tag)
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
			predefinedTypes.set(YAML.TIMESTAMP_TAG, typeof(DateTime));
		}

	}
}