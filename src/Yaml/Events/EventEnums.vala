namespace Catapult.Yaml.Events
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

}
