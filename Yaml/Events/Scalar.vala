using YAML;

namespace YamlDB.Yaml.Events
{
	public class Scalar : NodeEvent
	{
		public Scalar(string? anchor, string? tag, string value,
		              bool plain_implicit = true, bool quoted_implicit = true,
		              ScalarStyle style = ScalarStyle.ANY_SCALAR_STYLE)
		{
			base(anchor, tag, EventType.SCALAR_EVENT);
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
			return "[%s, Value: %s]".printf(this.get_type().name(), Value); 
		}

		internal Scalar.from_raw(RawEvent event)
			requires(event.type == EventType.SCALAR_EVENT)
		{
			base.from_raw(event.data.scalar.anchor, event.data.scalar.tag, event);
			IsPlainImplicit = (event.data.scalar.plain_implicit != 0);
			IsQuotedImplicit = (event.data.scalar.quoted_implicit != 0);
			Value = event.data.scalar.value;
			Style = event.data.scalar.style;
		}
		internal override int NestingIncrease { get { return 0; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.scalar_initialize(ref event, (uchar*)Anchor, (uchar*)Tag, (uchar*)Value, (int)Value.length,
									   IsPlainImplicit, IsQuotedImplicit, Style);
			return event;
		}
	}
}

