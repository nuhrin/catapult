using Gee;
using YamlDB.Yaml.Events;

namespace YamlDB.Yaml
{
	public class DocumentReader
	{
		EventReader reader;

		public DocumentReader(FileStream input)
		{
			reader = new EventReader(input);
		}
		public DocumentReader.from_string(string yaml)
		{
			reader = new EventReader.from_string(yaml);
		}
		internal DocumentReader.from_event_reader(EventReader reader) {
			this.reader = reader;
		}

		public Gee.List<Document> read_all_documents() throws YamlError
		{
			var list = new ArrayList<Document>();
			while(reader.Current.Type != EventType.STREAM_END) {
				var document = read_document();
				list.add(document);
			}
			return list;
		}

		public Document read_document() throws YamlError
		{
			reader.ensure_document_start();
			var start = reader.get<DocumentStart>();
			Node root = read_node();
			Document document = new Document.from_event(root, start);
			reader.get<DocumentEnd>();
			return document;
		}
		Node read_node() throws YamlError
		{
			switch(reader.Current.Type) {
				case EventType.SCALAR:
					var scalar = reader.get<Scalar>();
					return new ScalarNode.from_event(scalar);
				case EventType.MAPPING_START:
					return read_mapping_node();
				case EventType.SEQUENCE_START:
					return read_sequence_node();
				default:
					throw new YamlError.PARSE("Expected scalar, mapping start, or sequence start, got %s", reader.Current.to_string());
			}
		}
		MappingNode read_mapping_node() throws YamlError
		{
			var start = reader.get<MappingStart>();
			var mapping = new MappingNode.from_event(start);
			while (reader.Current.Type != EventType.MAPPING_END) {
				var key = read_node();
				var val = read_node();
				mapping.Mappings[key] = val;
			}
			reader.get<MappingEnd>();
			return mapping;
		}
		SequenceNode read_sequence_node() throws YamlError
		{
			var start = reader.get<SequenceStart>();
			var sequence = new SequenceNode.from_event(start);
			while (reader.Current.Type != EventType.SEQUENCE_END) {
				var node = read_node();
				sequence.Items.add(node);
			}
			reader.get<SequenceEnd>();
			return sequence;
		}
	}
}