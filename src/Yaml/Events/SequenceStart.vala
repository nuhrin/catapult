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
			is_implicit = implicit;
			this.style = style;
		}
		public bool is_implicit { get; private set; }
		public override bool is_canonical { get { return !is_implicit; } }
		public SequenceStyle style { get; private set; }

		internal SequenceStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SEQUENCE_START_EVENT)
		{
			base.from_raw(event.sequence_start_anchor, event.sequence_start_tag, event);
			is_implicit = (event.sequence_start_implicit != 0);
			style = (SequenceStyle)event.sequence_start_style;
		}
		internal override int nesting_increase { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.sequence_start_initialize(ref event, (uchar*)anchor, (uchar*)tag, is_implicit, (YAML.SequenceStyle)style);
			return event;
		}
	}
}
