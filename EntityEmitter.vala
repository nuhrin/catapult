using Gee;
using YamlDB.Helpers;
using YamlDB.Yaml;
using YamlDB.Yaml.Events;

namespace YamlDB
{
	public class EntityEmitter
	{
		public EntityEmitter(FileStream output, EncodingType encoding = YamlDB.Yaml.Events.EncodingType.ANY_ENCODING)
		{
			emitter = new EventEmitter(output);
			this.encoding = encoding;
		}
		public EntityEmitter.to_string_builder(StringBuilder sb, EncodingType encoding = YamlDB.Yaml.Events.EncodingType.ANY_ENCODING)
		{
			emitter = new EventEmitter.to_string_builder(sb);
			this.encoding = encoding;
		}
		~EntityEmitter()
		{
			if (has_document_context == true)
				end_document();
			if (has_stream_context == true)
				emitter.emit(new StreamEnd());
		}
		public EventEmitter emitter { get; private set; }
		bool has_document_context = false;
		bool has_stream_context = false;
		EncodingType encoding;

		public void start_document(bool implicit = true) throws YamlException
		{
			if (has_stream_context == false) {
				emitter.emit(new StreamStart(encoding));
				has_stream_context = true;
			}
			if (has_document_context == true)
				end_document();
			emitter.emit(new DocumentStart(null, null, implicit));
			has_document_context = true;
		}
		public void end_document(bool implicit = true) throws YamlException
		{
			if (has_document_context == false)
				return;
			emitter.emit(new DocumentEnd(implicit));
			has_document_context = false;
		}
		public void start_mapping(string? tag=null, bool isImplicit=true, MappingStyle style=YamlDB.Yaml.Events.MappingStyle.ANY, string? anchor=null) throws YamlException
		{
			ensure_document_context();
			emitter.emit(new MappingStart(anchor, tag, isImplicit, style));
		}
		public void end_mapping() throws YamlException
		{
			ensure_document_context();
			emitter.emit(new MappingEnd());
		}
		public void start_sequence(string? tag=null, bool isImplicit=true, SequenceStyle style=YamlDB.Yaml.Events.SequenceStyle.ANY, string? anchor=null) throws YamlException
		{
			ensure_document_context();
			emitter.emit(new SequenceStart(anchor, tag, isImplicit, style));
		}
		public void end_sequence() throws YamlException
		{
			ensure_document_context();
			emitter.emit(new SequenceEnd());
		}

		public void emit<T>(T value) throws YamlException
		{
			Value val = ValueHelper.extract_value<T>(value);
			emit_value(val);
		}
		public void emit_value(Value value) throws YamlException
		{
			ensure_document_context();
			EmitValue(value);
		}
		public void emit_object(Object obj) throws YamlException
		{
			ensure_document_context();
			EmitObject(obj);
		}
		public void emit_properties(Object obj) throws YamlException
		{
			ensure_document_context();
			EmitObjectProperties(obj);
		}
		public void emit_property(Object obj, string property_name) throws YamlException
		{
			ensure_document_context();
			EmitObjectProperty(obj, property_name);
		}
		public void flush()
		{
			emitter.flush();
		}

		void ensure_document_context() throws YamlException
		{
			if (has_document_context == false)
				start_document();
		}

		void EmitNull() throws YamlException
		{
			emitter.emit(new Scalar(null, Constants.Tag.NULL, "", false, false, ScalarStyle.PLAIN));
		}

		void EmitValue(Value value) throws YamlException
		{
			Type type = value.type();
			if (type.is_object())
			{
				EmitObject(value.get_object());
				return;
			}
			if (type.is_flags()) {
//				throw new YamlException.INTERNAL("emitting flags value not currently supported, due to bugs in FlagsClass api (can't get at FlagsValue instances).");
				emitter.emit(new SequenceStart());
				var klass = (FlagsClass)type.class_ref();
				foreach(unowned FlagsValue val in klass.values)
					emitter.emit(new Scalar(null, Constants.Tag.STR, val.value_name));
				emitter.emit(new SequenceEnd());
				return;
			}
			string anchor = null; // TODO: support anchors during emit?
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
				}
			}
			else if (type.is_classed())
				debug("Is Classed: "+type.name());
			else
				assert_not_reached();

			if (str_value != null)
				emitter.emit(new Scalar(anchor, tag, str_value));
			else
				EmitNull();
		}

		void EmitObject(Object obj) throws YamlException
		{
			// if YamlObject, emit that
			if (obj is YamlObject)
			{
				(obj as YamlObject).i_emit_yaml(this);
				return;
			}
			Type type = obj.get_type();

			// if mapping, emit that
			if (type.is_a(typeof(Map))) {
				Map map = obj as Map;
				Type key_type = IndirectGenericsHelper.Gee.Map.key_type(map);
				Type value_type = IndirectGenericsHelper.Gee.Map.value_type(map);
				var indirectMap = IndirectGenericsHelper.Gee.Map.indirect(key_type, value_type);
				var keys = indirectMap.get_keys(map);

				start_mapping();
				foreach(var key in keys)
				{
					var val = indirectMap.get(map, key);
					EmitValueSupportingEntityReference(key);
					EmitValueSupportingEntityReference(val);
				}
				end_mapping();
				return;
			}

			// if sequence, emit that
			if (type.is_a(typeof(Collection))) {
				Collection collection = obj as Collection;
				Type element_type = IndirectGenericsHelper.Gee.Collection.element_type(collection);
				var values = IndirectGenericsHelper.Gee.Collection.indirect(element_type).get_values(collection);
				start_sequence();
				foreach(var value in values)
					EmitValueSupportingEntityReference(value);
				end_sequence();
				return;
			}

			// emit properties
			start_mapping();
			EmitObjectProperties(obj);
			end_mapping();
		}

		void EmitObjectProperties(Object obj) throws YamlException
		{
			unowned ObjectClass klass = obj.get_class();
	    	var properties = klass.list_properties();
	    	foreach(var prop in properties)
	    	{
		    	if ((prop.flags & ParamFlags.READWRITE) == ParamFlags.READWRITE)
		    	{
			    	string name = prop.get_name();
					EmitValue(name);
					Value prop_value = Value(prop.value_type);
					obj.get_property(name, ref prop_value);
					EmitValueSupportingEntityReference(prop_value);
	    		}
	    	}
		}
		void EmitObjectProperty(Object obj, string name) throws YamlException
		{
			var prop = obj.get_class().find_property(name);
			if (prop != null && (prop.flags & ParamFlags.READWRITE) == ParamFlags.READWRITE) {
				EmitValue(name);
				Value prop_value = Value(prop.value_type);
				obj.get_property(name, ref prop_value);
				EmitValueSupportingEntityReference(prop_value);
			}
		}

		void EmitValueSupportingEntityReference(Value value) throws YamlException
		{
			Type type = value.type();
			if (type.is_a(typeof(Entity.Entity)))
			{
				var entity = (Entity.Entity)value.get_object();
				string id = entity.ID;
				if (id == null)
					id = entity.i_generate_id();
				EmitValue(id);
				return;
			}
			EmitValue(value);
		}
	}
}
