namespace YamlDB.Yaml.Events
{
	public enum BreakType {
		ANY_BREAK,
		CR_BREAK,
		LN_BREAK,
		CRLN_BREAK
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

		STREAM_START_EVENT,
		STREAM_END_EVENT,

		DOCUMENT_START_EVENT,
		DOCUMENT_END_EVENT,

		ALIAS_EVENT,
		SCALAR_EVENT,

		SEQUENCE_START_EVENT,
		SEQUENCE_END_EVENT,

		MAPPING_START_EVENT,
		MAPPING_END_EVENT
	}

	public enum MappingStyle {
		ANY_MAPPING_STYLE,
		BLOCK_MAPPING_STYLE,
		FLOW_MAPPING_STYLE
	}

	public enum NodeType {
		NO_NODE,
		SCALAR_NODE,
		SEQUENCE_NODE,
		MAPPING_NODE
	}

	public enum ScalarStyle {
		ANY_SCALAR_STYLE,
		PLAIN_SCALAR_STYLE,
		SINGLE_QUOTED_SCALAR_STYLE,
		DOUBLE_QUOTED_SCALAR_STYLE,
		LITERAL_SCALAR_STYLE,
		FOLDED_SCALAR_STYLE
	}

	public enum SequenceStyle{
		ANY_SEQUENCE_STYLE ,
		BLOCK_SEQUENCE_STYLE,
		FLOW_SEQUENCE_STYLE
	}
}
