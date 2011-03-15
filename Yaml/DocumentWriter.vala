using Gee;
using YamlDB.Yaml.Events;

namespace YamlDB.Yaml
{
	public class DocumentWriter
	{
		EventEmitter emitter;
		EncodingType encoding;
		bool has_stream_context = false;

		public DocumentWriter(FileStream output, EncodingType encoding = YamlDB.Yaml.Events.EncodingType.ANY_ENCODING)
		{
			emitter = new EventEmitter(output);
			this.encoding = encoding;
		}
		public DocumentWriter.to_string_builder(StringBuilder sb, EncodingType encoding = YamlDB.Yaml.Events.EncodingType.ANY_ENCODING)
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
			write_node(document.Root);
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
			switch(node.Type) {
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
			foreach(var key in node.Mappings.sorted_keys()) {
				write_node(key);
				write_node(node.Mappings[key]);
			}
			emitter.emit(new MappingEnd());
		}
		void write_sequence_node(SequenceNode node) throws YamlError
		{
			emitter.emit(node.get_event());
			foreach(var item in node.Items)
				write_node(item);
			emitter.emit(new SequenceEnd());
		}
	}
}