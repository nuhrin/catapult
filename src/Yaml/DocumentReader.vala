/* DocumentReader.vala
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
 
using Gee;
using YAML;

namespace Catapult.Yaml
{
	public class DocumentReader
	{
		Parser parser;
		RawEvent raw_event;
		bool has_document_context = false;

		public DocumentReader(FileStream input) {
			parser = Parser();
			parser.set_input_file(input);
		}
		public DocumentReader.from_string(string yaml) {
			parser = Parser();
			parser.set_input_string(yaml, yaml.length);
		}

		public Gee.List<Document> read_all_documents() throws YamlError
		{
			var list = new ArrayList<Document>();
			ensure_stream_start();
			while(raw_event.type != YAML.EventType.STREAM_END_EVENT) {
				var document = read_document();
				list.add(document);
			}
			return list;
		}

		public Document read_document() throws YamlError
		{
			ensure_document_start();
			bool isImplicit = (raw_event.document_start_implicit != 0);
			move_next();
			Node root = read_node();
			Document document = new Document(root, isImplicit);
			move_next(); // document end
			return document;
		}
		Node read_node() throws YamlError
		{
			Node node = null;
			switch(raw_event.type) {
				case YAML.EventType.SCALAR_EVENT:
					node = new ScalarNode.from_raw(raw_event);
					break;
				case YAML.EventType.MAPPING_START_EVENT:
					node = read_mapping_node();
					break;
				case YAML.EventType.SEQUENCE_START_EVENT:
					node = read_sequence_node();
					break;
				default:
					throw new YamlError.PARSE("Expected scalar, mapping start, or sequence start");
			}
			move_next();
			return node;
		}
		MappingNode read_mapping_node() throws YamlError
		{
			var mapping = new MappingNode.from_raw(raw_event);
			move_next();
			while (raw_event.type != YAML.EventType.MAPPING_END_EVENT) {
				var key = read_node();
				var val = read_node();
				mapping[key] = val;
			}
			return mapping;
		}
		SequenceNode read_sequence_node() throws YamlError
		{
			var sequence = new SequenceNode.from_raw(raw_event);
			move_next();
			while (raw_event.type != YAML.EventType.SEQUENCE_END_EVENT) {
				var node = read_node();
				sequence.add(node);
			}
			return sequence;
		}

		void ensure_stream_start() throws YamlError
		{
			if (!parser.stream_start_produced) {
				move_next();
				assert(raw_event.type == YAML.EventType.STREAM_START_EVENT);
			}
		}
		void ensure_document_start() throws YamlError
		{
			ensure_stream_start();
			if (!has_document_context) {
				move_next();
				assert(raw_event.type == YAML.EventType.DOCUMENT_START_EVENT);
			}
		}
		bool move_next() throws YamlError
		{
			if (parser.stream_end_produced)
				return false;
			if (!parser.parse(out raw_event))
			{
				throw new YamlError.PARSE("EventParser error: %s at %u(%s)\nError Context: '%s'",
					parser.problem, parser.problem_offset, parser.problem_mark.to_string(), parser.context);
			}
			if (!has_document_context) {
			 	if (raw_event.type == YAML.EventType.DOCUMENT_START_EVENT)
					has_document_context = true;
			} else {
				if (raw_event.type == YAML.EventType.DOCUMENT_END_EVENT)
					has_document_context = false;
			}
			return true;
		}
	}
}
