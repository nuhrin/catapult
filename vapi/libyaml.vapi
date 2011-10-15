/* ************
 *
 * Copyright (C) 2009  Denis Tereshkin
 * Copyright (C) 2009  Dmitriy Kuteynikov
 * Copyright (C) 2009  Yu Feng
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to
 *
 * the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Denis Tereshkin
 * 	Dmitriy Kuteynikov <kuteynikov@gmail.com>
 * 	Yu Feng <rainwoodman@gmail.com>
 ***/

[CCode (cprefix="YAML", cheader_filename="yaml.h", lower_case_cprefix="yaml_")]
namespace YAML {

	internal const string DEFAULT_SCALAR_TAG;
	internal const string DEFAULT_SEQUENCE_TAG;
	internal const string DEFAULT_MAPPING_TAG;
	internal const string NULL_TAG;
	internal const string BOOL_TAG;
	internal const string STR_TAG;
	internal const string INT_TAG;
	internal const string FLOAT_TAG;
	internal const string TIMESTAMP_TAG;
	internal const string SEQ_TAG;
	internal const string MAP_TAG;

	[CCode (cprefix="YAML_", cname="yaml_node_type_t", has_type_id=false)]
	internal enum NodeType {
		NO_NODE,
		SCALAR_NODE,
		SEQUENCE_NODE,
		MAPPING_NODE
	}
	[CCode (cprefix="YAML_", cname="yaml_scalar_style_t", has_type_id=false)]
	internal enum ScalarStyle {
		ANY_SCALAR_STYLE,
		PLAIN_SCALAR_STYLE,
		SINGLE_QUOTED_SCALAR_STYLE,
		DOUBLE_QUOTED_SCALAR_STYLE,
		LITERAL_SCALAR_STYLE,
		FOLDED_SCALAR_STYLE
	}

	[CCode (cprefix="YAML_", cname="yaml_sequence_style_t", has_type_id=false)]
	/**
	 * Sequence styles
	 * */
	internal enum SequenceStyle{
		ANY_SEQUENCE_STYLE ,
		BLOCK_SEQUENCE_STYLE,
		FLOW_SEQUENCE_STYLE
	}
	/**
	 * Mapping styles.
	 * */
	[CCode (cprefix="YAML_", cname="yaml_mapping_style_t", has_type_id=false)]
	internal enum MappingStyle {
		ANY_MAPPING_STYLE,
		BLOCK_MAPPING_STYLE,
		FLOW_MAPPING_STYLE
	}

	/**
	 * The version directive data.
	 * */
	[CCode (cname="yaml_version_directive_t", has_type_id = false)]
	internal struct VersionDirective {
		public int major;
		public int minor;
	}

	/**
	 * The tag directive data.
	 * */
	[CCode (cname = "yaml_tag_directive_t", has_type_id = false)]
	internal struct TagDirective {
		public string handle;
		public string prefix;
	}
	/** Line break types. */

	[CCode (cprefix="YAML_", cname="yaml_break_t", has_type_id=false)]
	internal enum BreakType {
		ANY_BREAK,
		CR_BREAK,
		LN_BREAK,
		CRLN_BREAK
	}

	[CCode (cname="yaml_mark_t", has_type_id = false)]
	/**
	 * The pointer position.
	 * */
	internal struct Mark {
		public size_t index;
		public size_t line;
		public size_t column;
		public string to_string() {
			return "index:%u line:%u column:%u".printf(
				(uint)index, (uint)line, (uint)column);
		}
	}

	[CCode (cname = "yaml_event_type_t", cprefix="YAML_", has_type_id = false)]
	internal enum EventType {
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

	[CCode(cname="struct { yaml_encoding_t encoding; }", has_type_id=false)]
	internal struct EventStreamStart {
		public EncodingType encoding;
	}

	[CCode(cname="struct { yaml_tag_directive_t *start; yaml_tag_directive_t *end; }", has_type_id=false)]
	internal struct DocumentTagDirectives {
		YAML.TagDirective *start;
		YAML.TagDirective *end;
	}
	[CCode(cname="struct { yaml_version_directive_t *version_directive; struct { yaml_tag_directive_t *start; yaml_tag_directive_t *end; } tag_directives; int implicit; }", has_type_id=false)]
	internal struct EventDocumentStart {
		public YAML.VersionDirective *version_directive;
		public YAML.DocumentTagDirectives tag_directives;
		public int implicit;
	}

	[CCode(has_type_id=false)]
	internal struct EventDocumentEnd {
		[CCode(cname="event.data.document_end.implicit")]
		public int implicit;
	}

	[CCode(has_type_id=false)]
	internal struct EventAlias {
		[CCode(cname="event.data.alias.anchor")]
		public string anchor;
	}

	[CCode(has_type_id=false)]
	internal struct EventScalar {
		/* The anchor. */
		[CCode(cname="event.data.scalar.anchor")]
		public string anchor;
		/* The tag. */
		[CCode(cname="event.data.scalar.tag")]
		public string tag;
		/* The scalar value. */
		[CCode(cname="event.data.scalar.value")]
		public string value;
		/* The length of the scalar value. */
		[CCode(cname="event.data.scalar.length")]
		public size_t length;
		/* Is the tag optional for the plain style? */
		[CCode(cname="event.data.scalar.plain_implicit")]
		public int plain_implicit;
		/* Is the tag optional for any non-plain style? */
		[CCode(cname="event.data.scalar.quoted_implicit")]
		public int quoted_implicit;
		[CCode(cname="event.data.scalar.style")]
		public ScalarStyle style;
	}

	[CCode(has_type_id=false)]
	internal struct EventSequenceStart {
		[CCode(cname="event.data.sequence_start.anchor")]
		public string anchor;
		[CCode(cname="event.data.sequence_start.tag")]
		public string tag;
		[CCode(cname="event.data.sequence_start.implicit")]
		public int implicit;
		[CCode(cname="event.data.sequence_start.style")]
		public YAML.SequenceStyle style;
	}

	[CCode(has_type_id=false)]
	internal struct EventMappingStart {
		[CCode(cname="event.data.mapping_start.anchor")]
		public string anchor;
		[CCode(cname="event.data.mapping_start.tag")]
		public string tag;
		[CCode(cname="data.mapping_start.implicit")]
		public int implicit;
		[CCode(cname="data.mapping_start.style")]
		public YAML.MappingStyle style;
	}

	[CCode (has_type_id=false)]
	internal struct EventData {
		[CCode(cname="event.data.stream_start")]
		public YAML.EventStreamStart stream_start;
		[CCode(cname="event.data.document_start")]
		public YAML.EventDocumentStart document_start;
		[CCode(cname="event.data.document_end")]
		public YAML.EventDocumentEnd document_end;
		[CCode(cname="event.data.alias")]
		public YAML.EventAlias alias;
		[CCode(cname="event.data.scalar")]
		public YAML.EventScalar scalar;
		[CCode(cname="event.data.sequence_start")]
		public YAML.EventSequenceStart sequence_start;
		[CCode(cname="event.data.mapping_start")]
		public YAML.EventMappingStart mapping_start;
	}

	[CCode (has_type_id = false, cname="yaml_event_t", lower_case_cprefix="yaml_event_", destroy_function="yaml_event_delete")]
	internal struct RawEvent {
		[CCode (cname="yaml_stream_start_event_initialize")]
		public static int stream_start_initialize(ref YAML.RawEvent event, YAML.EncodingType encoding);

		[CCode (cname="yaml_stream_end_event_initialize")]
		public static int stream_end_initialize(ref YAML.RawEvent event);

		[CCode (cname="yaml_document_start_event_initialize")]
		public static int document_start_initialize(ref YAML.RawEvent event, void* version_directive = null,
		                            void* tag_directive_start = null, void* tag_directive_end = null,
		                            bool implicit = true);

		[CCode (cname="yaml_document_end_event_initialize")]
		public static int document_end_initialize(ref YAML.RawEvent event, bool implicit = true);

		[CCode (cname="yaml_alias_event_initialize")]
		public static int alias_initialize(ref YAML.RawEvent event, uchar *anchor);

		[CCode (cname="yaml_scalar_event_initialize")]
		public static int scalar_initialize(ref YAML.RawEvent event, uchar *anchor, uchar *tag, uchar *value, int length,
		                   bool plain_implicit = true, bool quoted_implicity = true,
		                   YAML.ScalarStyle style = YAML.ScalarStyle.ANY_SCALAR_STYLE );

		[CCode (cname="yaml_sequence_start_event_initialize")]
		public static int sequence_start_initialize(ref YAML.RawEvent event, uchar *anchor = null, uchar *tag = null, bool implicit = true, YAML.SequenceStyle style = YAML.SequenceStyle.ANY_SEQUENCE_STYLE);
		[CCode (cname="yaml_sequence_end_event_initialize")]
		public static int sequence_end_initialize(ref YAML.RawEvent event);

		[CCode (cname="yaml_mapping_start_event_initialize")]
		public static int mapping_start_initialize(ref YAML.RawEvent event, uchar *anchor = null, uchar *tag = null, bool implicit = true, YAML.MappingStyle style = YAML.MappingStyle.ANY_MAPPING_STYLE);
		[CCode (cname="yaml_mapping_end_event_initialize")]
		public static int mapping_end_initialize(ref YAML.RawEvent event);

		public static void clean(ref YAML.RawEvent event) {
			event.type = YAML.EventType.NO_EVENT;
		}

		public EventType type;
		[CCode(cname="data.stream_start.encoding")]
		public EncodingType stream_start_encoding;
		[CCode(cname="data.document_start.version_directive")]
		public YAML.VersionDirective *document_start_version_directive;
		[CCode(cname="data.document_start.tag_directives.start")]
		public YAML.TagDirective *document_start_tag_directives_start;
		[CCode(cname="data.document_start.tag_directives.end")]
		public YAML.TagDirective *document_start_tag_directives_end;
		[CCode(cname="data.document_start.implicit")]
		public int document_start_implicit;
		[CCode(cname="data.document_end.implicit")]
		public int document_end_implicit;
		[CCode(cname="data.alias.anchor")]
		public string alias_anchor;
		[CCode(cname="data.scalar.anchor")]
		public string scalar_anchor;
		[CCode(cname="data.scalar.tag")]
		public string scalar_tag;
		[CCode(cname="data.scalar.value")]
		public string scalar_value;
		[CCode(cname="data.scalar.length")]
		public size_t scalar_length;
		[CCode(cname="data.scalar.plain_implicit")]
		public int scalar_plain_implicit;
		[CCode(cname="data.scalar.quoted_implicit")]
		public int scalar_quoted_implicit;
		[CCode(cname="data.scalar.style")]
		public ScalarStyle scalar_style;
		[CCode(cname="data.sequence_start.anchor")]
		public string sequence_start_anchor;
		[CCode(cname="data.sequence_start.tag")]
		public string sequence_start_tag;
		[CCode(cname="data.sequence_start.implicit")]
		public int sequence_start_implicit;
		[CCode(cname="data.sequence_start.style")]
		public SequenceStyle sequence_start_style;
		[CCode(cname="data.mapping_start.anchor")]
		public string mapping_start_anchor;
		[CCode(cname="data.mapping_start.tag")]
		public string mapping_start_tag;
		[CCode(cname="data.mapping_start.implicit")]
		public int mapping_start_implicit;
		[CCode(cname="data.mapping_start.style")]
		public MappingStyle mapping_start_style;

		public Mark start_mark;
		public Mark end_mark;

	}

	/**
	 * The stream encoding.
	 * */
	[CCode (cname = "yaml_encoding_t", cprefix="YAML_", has_type_id = false)]
	internal enum EncodingType {
		/* Let the parser choose the encoding. */
		ANY_ENCODING,
		/* The default UTF-8 encoding. */
		UTF8_ENCODING,
		/* The UTF-16-LE encoding with BOM. */
		UTF16LE_ENCODING,
		/* The UTF-16-BE encoding with BOM. */
		UTF16BE_ENCODING
	}

	/** Many bad things could happen with the parser and emitter. */
	[CCode (cname="yaml_error_type_t", prefix="YAML_", has_type_id=false)]
	internal enum ErrorType {
		NO_ERROR,

		/* Cannot allocate or reallocate a block of memory. */
		MEMORY_ERROR,

		/* Cannot read or decode the input stream. */
		READER_ERROR,
		/* Cannot scan the input stream. */
		SCANNER_ERROR,
		/* Cannot parse the input stream. */
		PARSER_ERROR,
		/* Cannot compose a YAML document. */
		COMPOSER_ERROR,

		/* Cannot write to the output stream. */
		WRITER_ERROR,
		/* Cannot emit a YAML stream. */
		EMITTER_ERROR
	}

	[CCode (has_type_id = false,
			cname="yaml_parser_t",
			lower_case_cprefix="yaml_parser_",
			destroy_function="yaml_parser_delete")]
	internal struct Parser {
		public YAML.ErrorType error;
		public string problem;
		public size_t problem_offset;
		public int problem_value;
		public YAML.Mark problem_mark;
		public string context;
		public YAML.Mark context_mark;

		public bool stream_start_produced;
		public bool stream_end_produced;
		[CCode (cname="yaml_parser_initialize")]
		public Parser();

		/*
		 * Set the input to a string.
		 *
		 * libyaml doesn't take an ownership reference of the string.
		 * Make sure you keep the string alive during the lifetime of
		 * the parser!
		 *
		 * size is in bytes, not in characters. Use string.size() to obtain
		 * the size.
		 * */
		public void set_input_string(string input, size_t size);
		/*
		 * Set the input to a file stream.
		 *
		 * libyaml doesn't take an ownership reference of the stream.
		 * Make sure you keep the stream alive during the lifetime of
		 * the parser!
		 * */
		public void set_input_file(GLib.FileStream file);
		public void set_encoding(YAML.EncodingType encoding);
		public bool parse(out YAML.RawEvent event);
	}

	[CCode (instance_pos = 0, cname="yaml_write_handler_t")]
	internal delegate int WriteHandler(uchar *buffer, size_t length);

	[CCode (has_type_id = false,
			cname="yaml_emitter_t",
			lower_case_cprefix="yaml_emitter_",
			destroy_function="yaml_emitter_delete")]
	internal struct Emitter {
		public YAML.ErrorType error;
		public string problem;

		[CCode (cname="yaml_emitter_initialize")]
		public Emitter();
		/*
		 * Set the output to a string.
		 *
		 * libyaml doesn't take an ownership reference of the string.
		 * Make sure you keep the string alive during the lifetime of
		 * the emitter!
		 *
		 * size is in bytes, not in characters. Use string.size() to obtain
		 * the size.
		 * */
		public void set_output_string(char[] input, out size_t written);
		/*
		 * Set the output to a file stream.
		 *
		 * libyaml doesn't take an ownership reference of the stream.
		 * Make sure you keep the stream alive during the lifetime of
		 * the emitter!
		 * */
		public void set_output_file(GLib.FileStream file);

		public void set_output(YAML.WriteHandler handler);

		public void set_encoding(YAML.EncodingType encoding);
		public void set_canonical(bool canonical);
		public void set_indent(int indent);
		public void set_width(int width);
		public void set_unicode(bool unicode);
		public void set_break(YAML.BreakType break);
		public bool emit(ref YAML.RawEvent event);
		public bool flush();
	}

}
