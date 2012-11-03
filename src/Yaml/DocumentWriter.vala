/* DocumentWriter.vala
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

namespace Catapult.Yaml
{
	public class DocumentWriter
	{
		EventEmitter emitter;
		EncodingType encoding;
		bool has_stream_context = false;

		public DocumentWriter(FileStream output, EncodingType encoding = EncodingType.ANY_ENCODING)
		{
			emitter = new EventEmitter(output);
			this.encoding = encoding;
		}
		public DocumentWriter.to_string_builder(StringBuilder sb, EncodingType encoding = EncodingType.ANY_ENCODING)
		{
			emitter = new EventEmitter.to_string_builder(sb);
			this.encoding = encoding;
		}
		~DocumentWriter()
		{
			if (has_stream_context == true)
				emitter.emit(new StreamEnd());
		}

		public void write_document(Document document) throws YamlError
		{
			ensure_stream_start();
			emitter.emit(document.get_start_event());
			write_node(document.root);
			emitter.emit(document.get_end_event());
		}

		public void flush() throws YamlError
		{
			emitter.flush();
		}

		void ensure_stream_start() throws YamlError
		{
			if (has_stream_context == false) {
				emitter.emit(new StreamStart(encoding));
				has_stream_context = true;
			}
		}

		void write_node(Node node) throws YamlError
		{
			switch(node.node_type) {
				case NodeType.SCALAR:
					emitter.emit(node.get_event());
					break;
				case NodeType.MAPPING:
					write_mapping_node(node as MappingNode);
					break;
				case NodeType.SEQUENCE:
					write_sequence_node(node as SequenceNode);
					break;
				default:
					//throw new YamlError.PARSE("Expected scalar, mapping, or sequence, got NodeType.NONE");
					break;
			}
		}
		void write_mapping_node(MappingNode node) throws YamlError
		{
			emitter.emit(node.get_event());
			foreach(var key in node.keys()) {
				write_node(key);
				write_node(node[key]);
			}
			emitter.emit(new MappingEnd());
		}
		void write_sequence_node(SequenceNode node) throws YamlError
		{
			emitter.emit(node.get_event());
			foreach(var item in node.items())
				write_node(item);
			emitter.emit(new SequenceEnd());
		}
	}
}
