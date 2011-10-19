using YAML;

namespace Catapult.Yaml.Events
{
	public class StreamEnd : Event
	{
		public StreamEnd()
		{
			base(EventType.STREAM_END);
		}

		internal StreamEnd.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.STREAM_END_EVENT)
		{
			base.from_raw(event);
		}
		internal override int nesting_increase { get { return -1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.stream_end_initialize(ref event);
			return event;
		}
	}
}
