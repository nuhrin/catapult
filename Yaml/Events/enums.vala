namespace YamlDB.Yaml.Events
{
	public enum BreakType {
		ANY,
		CR,
		LN,
		CRLN
	}

	public enum EncodingType {
		/* Let the parser choose the encoding. */
		ANY_ENCODING,
		/* The default UTF-8 encoding. */
		UTF8_ENCODING,
		/* The UTF-16-LE encoding with BOM. */
		UTF16LE_ENCODING,
		/* The UTF-16-BE encoding with BOM. */
		UTF16BE_ENCODING
	}
	public enum EventType {
		NO_EVENT,

		STREAM_START,
		STREAM_END,

		DOCUMENT_START,
		DOCUMENT_END,

		ALIAS,
		SCALAR,

		SEQUENCE_START,
		SEQUENCE_END,

		MAPPING_START,
		MAPPING_END
	}

	public enum MappingStyle {
		ANY,
		BLOCK,
		FLOW
	}

	public enum NodeType {
		NONE,
		SCALAR,
		SEQUENCE,
		MAPPING
	}

	public enum ScalarStyle {
		ANY,
		PLAIN,
		SINGLE_QUOTED,
		DOUBLE_QUOTED,
		LITERAL,
		FOLDED
	}

	public enum SequenceStyle{
		ANY,
		BLOCK,
		FLOW
	}
}
