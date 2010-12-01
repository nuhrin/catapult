using YAML;

namespace YamlDB.Yaml.Events
{
	public class EventReader
	{
		Parser parser;
		RawEvent raw_event;
		Event current_event = new EmptyEvent();

		public EventReader(FileStream input)
		{
			parser = Parser();
			parser.set_input_file(input);
		}

		public EventReader.from_string(string yaml)
		{
			parser = Parser();
			parser.set_input_string(yaml, yaml.size());
		}

		public Event Current { get { return current_event; } }
				
		public bool move_next() throws YamlException
		{
			if (parser.stream_end_produced)
				return false;
			if (!parser.parse(out raw_event)) 
			{
				throw new YamlException.PARSE("EventParser error: %s at %u(%s)\nError Context: '%s'",
					parser.problem, parser.problem_offset, parser.problem_mark.to_string(), parser.context);
			}
			current_event = get_parsing_event(raw_event);
			return true;
		}

		public T get<T>() throws YamlException
		{
			ensure_stream_start();
			if (!(typeof(T).is_a(current_event.get_type())))
			{
				throw new YamlException.EVENT_TYPE("Expected '%s' got '%s' (%s)\nContext: '%s'",
					typeof(T).name(), current_event.get_type().name(), 
					parser.context_mark.to_string(), parser.context);
			}
			T event = (T)current_event;
			move_next();
			return event;
		}

		public void skip() throws YamlException
		{
			ensure_stream_start();
			int depth = 0;

			do
			{
				depth = depth + current_event.NestingIncrease;
				move_next();
			}
			while(depth > 0);
		}

		void ensure_stream_start() throws YamlException
		{
			if (!parser.stream_start_produced)
			{
				move_next();
				assert(raw_event.type == EventType.STREAM_START_EVENT);
			}
		}

		Event get_parsing_event(RawEvent event)
		{
			switch(event.type) 
			{
				case EventType.STREAM_START_EVENT:
					return new StreamStart.from_raw(event);
				case EventType.STREAM_END_EVENT:
					return new StreamEnd.from_raw(event);
				case EventType.DOCUMENT_START_EVENT:
					return new DocumentStart.from_raw(event);
				case EventType.DOCUMENT_END_EVENT:
					return new DocumentEnd.from_raw(event);
				case EventType.ALIAS_EVENT:
					return new AnchorAlias.from_raw(event);
				case EventType.SCALAR_EVENT:
					return new Scalar.from_raw(event);
				case EventType.SEQUENCE_START_EVENT:
					return new SequenceStart.from_raw(event);
				case EventType.SEQUENCE_END_EVENT:
					return new SequenceEnd.from_raw(event);
				case EventType.MAPPING_START_EVENT:
					return new MappingStart.from_raw(event);
				case EventType.MAPPING_END_EVENT:
					return new MappingEnd.from_raw(event);
				case EventType.NO_EVENT:
					return new EmptyEvent();
				default:
					assert_not_reached();
			}
		}
		
		
		
	}
}
