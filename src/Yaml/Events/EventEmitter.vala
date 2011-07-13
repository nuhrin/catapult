using YAML;

namespace Catapult.Yaml.Events
{
	public class EventEmitter
	{
		Emitter emitter;
		unowned StringBuilder sb;

		public EventEmitter(FileStream output)
		{
			emitter = Emitter();
			emitter.set_output_file(output);
		}
		public EventEmitter.to_string_builder(StringBuilder sb)
		{
			this.sb = sb;
			emitter = Emitter();
			emitter.set_output(emit_to_string_builder_handler);
		}
		~EventEmitter()
		{
			emitter.flush();
			sb = null;
		}

		public void emit(Event event) throws YamlError
		{
			RawEvent raw_event = event.create_raw_event();
			if (!emitter.emit(ref raw_event))
			{
				throw new YamlError.EMIT("EventEmitter error: %s", emitter.problem);
			}
			RawEvent.clean(ref raw_event);
		}

		public void flush() throws YamlError
		{
			if (!emitter.flush())
			{
				throw new YamlError.EMIT("EventEmitter error: %s", emitter.problem);
			}
		}

		public void set_encoding(EncodingType encoding)
		{
			emitter.set_encoding((YAML.EncodingType)encoding);
		}
		public void set_canonical(bool canonical)
		{
			emitter.set_canonical(canonical);
		}
		public void set_indent(int indent)
		{
			emitter.set_indent(indent);
		}
		public void set_width(int width)
		{
			emitter.set_width(width);
		}
		public void set_unicode(bool unicode)
		{
			emitter.set_unicode(unicode);
		}
		public void set_break(BreakType @break)
		{
			emitter.set_break((YAML.BreakType)@break);
		}

		private int emit_to_string_builder_handler(uchar *buffer, size_t length) {
			sb.append_len((string)buffer, (ssize_t)length);
			return 1;
		}
	}
}
