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
			Value = value;
			IsPlainImplicit = plain_implicit;
			IsQuotedImplicit = quoted_implicit;
			Style = style;
		}
		public string Value { get; private set; }
		public bool IsPlainImplicit { get; private set; }
		public bool IsQuotedImplicit { get; private set; }
		public ScalarStyle Style { get; private set; }
		public override bool IsCanonical { get { return !IsPlainImplicit && !IsQuotedImplicit; } }

		public override string to_string()
		{
			return "[Scalar, Value: %s]".printf(Value);
		}

		internal Scalar.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SCALAR_EVENT)
		{
			base.from_raw(event.scalar_anchor, event.scalar_tag, event);
			IsPlainImplicit = (event.scalar_plain_implicit != 0);
			IsQuotedImplicit = (event.scalar_quoted_implicit != 0);
			Value = event.scalar_value;
			Style = (ScalarStyle)event.scalar_style;
		}
		internal override int NestingIncrease { get { return 0; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.scalar_initialize(ref event, (uchar*)Anchor, (uchar*)Tag, (uchar*)Value, (int)Value.length,
									   IsPlainImplicit, IsQuotedImplicit, (YAML.ScalarStyle)Style);
			return event;
		}
	}
}

