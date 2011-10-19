using YAML;

namespace Catapult.Yaml.Events
{
	public class SequenceEnd : Event
	{
		public SequenceEnd()
		{
			base(EventType.SEQUENCE_END);
		}

		internal SequenceEnd.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SEQUENCE_END_EVENT)
		{
			base.from_raw(event);
		}
		internal override int nesting_increase { get { return -1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.sequence_end_initialize(ref event);
			return event;
		}
	}
}
