using YAML;

namespace Catapult.Yaml.Events
{
	public class SequenceStart : NodeEvent
	{
		public SequenceStart(string? anchor=null, string? tag=null,
							bool implicit = true,
							SequenceStyle style = SequenceStyle.ANY)
		{
			base(anchor, tag, EventType.SEQUENCE_START);
			IsImplicit = implicit;
			Style = style;
		}
		public bool IsImplicit { get; private set; }
		public override bool IsCanonical { get { return !IsImplicit; } }
		public SequenceStyle Style { get; private set; }

		internal SequenceStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SEQUENCE_START_EVENT)
		{
			base.from_raw(event.sequence_start_anchor, event.sequence_start_tag, event);
			IsImplicit = (event.sequence_start_implicit != 0);
			Style = (SequenceStyle)event.sequence_start_style;
		}
		internal override int NestingIncrease { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.sequence_start_initialize(ref event, (uchar*)Anchor, (uchar*)Tag, IsImplicit, (YAML.SequenceStyle)Style);
			return event;
		}
	}
}
