/* EventReader.vala
 * 
 * Copyright (C) 2012 nuhrin
 * 
 * This file is part of catapult.
 * 
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */
 
using YAML;

namespace Catapult.Yaml.Events
{
	public class EventReader
	{
		Parser parser;
		RawEvent raw_event;
		Event current_event = new EmptyEvent();
		bool has_document_context = false;

		public EventReader(FileStream input)
		{
			parser = Parser();
			parser.set_input_file(input);
		}

		public EventReader.from_string(string yaml)
		{
			parser = Parser();
			parser.set_input_string(yaml, yaml.length);
		}

		public Event Current { get { return current_event; } }

		public bool move_next() throws YamlError
		{
			if (parser.stream_end_produced)
				return false;
			if (!parser.parse(out raw_event))
			{
				throw new YamlError.PARSE("EventParser error: %s at %u(%s)\nError Context: '%s'",
					parser.problem, parser.problem_offset, parser.problem_mark.to_string(), parser.context);
			}
			current_event = get_parsing_event(raw_event);
			if (!has_document_context) {
			 	if (raw_event.type == YAML.EventType.DOCUMENT_START_EVENT)
					has_document_context = true;
			} else {
				if (raw_event.type == YAML.EventType.DOCUMENT_END_EVENT)
					has_document_context = false;
			}
			return true;
		}

		public T get<T>() throws YamlError
		{
			ensure_stream_start();
			if (!(typeof(T).is_a(current_event.get_type())))
			{
				throw new YamlError.EVENT_TYPE("Expected '%s' got '%s' (%s)\nContext: '%s'",
					typeof(T).name(), current_event.get_type().name(),
					parser.context_mark.to_string(), parser.context);
			}
			T event = (T)current_event;
			move_next();
			return event;
		}

		public void skip() throws YamlError
		{
			ensure_stream_start();
			int depth = 0;

			do
			{
				depth = depth + current_event.nesting_increase;
				move_next();
			}
			while(depth > 0);
		}

		public void ensure_stream_start() throws YamlError
		{
			if (!parser.stream_start_produced) {
				move_next();
				assert(raw_event.type == YAML.EventType.STREAM_START_EVENT);
			}
		}
		public void ensure_document_start() throws YamlError
		{
			ensure_stream_start();
			if (!has_document_context) {
				move_next();
				assert(raw_event.type == YAML.EventType.DOCUMENT_START_EVENT);
			}
		}
		public void ensure_document_context() throws YamlError
		{
			ensure_document_start();
			if (raw_event.type == YAML.EventType.DOCUMENT_START_EVENT)
				move_next();
		}

		Event get_parsing_event(RawEvent event)
		{
			switch((EventType)event.type)
			{
				case EventType.STREAM_START:
					return new StreamStart.from_raw(event);
				case EventType.STREAM_END:
					return new StreamEnd.from_raw(event);
				case EventType.DOCUMENT_START:
					return new DocumentStart.from_raw(event);
				case EventType.DOCUMENT_END:
					return new DocumentEnd.from_raw(event);
				case EventType.ALIAS:
					return new AnchorAlias.from_raw(event);
				case EventType.SCALAR:
					return new Scalar.from_raw(event);
				case EventType.SEQUENCE_START:
					return new SequenceStart.from_raw(event);
				case EventType.SEQUENCE_END:
					return new SequenceEnd.from_raw(event);
				case EventType.MAPPING_START:
					return new MappingStart.from_raw(event);
				case EventType.MAPPING_END:
					return new MappingEnd.from_raw(event);
				case EventType.NO_EVENT:
					return new EmptyEvent();
				default:
					assert_not_reached();
			}
		}



	}
}
