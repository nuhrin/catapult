using YAML;

namespace Catapult.Yaml.Events
{
	public class Scalar : NodeEvent
	{
		public Scalar(string? anchor, string? tag, string value,
		              bool plain_implicit = true, bool quoted_implicit = false,
		              ScalarStyle style = ScalarStyle.ANY)
		{
			base(anchor, tag, EventType.SCALAR);
			this.value = value;
			is_plain_implicit = plain_implicit;
			is_quoted_implicit = quoted_implicit;
			this.style = style;
		}
		public string value { get; private set; }
		public bool is_plain_implicit { get; private set; }
		public bool is_quoted_implicit { get; private set; }
		public ScalarStyle style { get; private set; }
		public override bool is_canonical { get { return !is_plain_implicit && !is_quoted_implicit; } }

		public override string to_string()
		{
			return "[Scalar, value: %s]".printf(value);
		}

		internal Scalar.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SCALAR_EVENT)
		{
			base.from_raw(event.scalar_anchor, event.scalar_tag, event);
			is_plain_implicit = (event.scalar_plain_implicit != 0);
			is_quoted_implicit = (event.scalar_quoted_implicit != 0);
			value = event.scalar_value;
			style = (ScalarStyle)event.scalar_style;
		}
		internal override int nesting_increase { get { return 0; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.scalar_initialize(ref event, (uchar*)anchor, (uchar*)tag, (uchar*)value, (int)value.length,
									   is_plain_implicit, is_quoted_implicit, (YAML.ScalarStyle)style);
			return event;
		}
	}
}

