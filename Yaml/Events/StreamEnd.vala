using YAML;

namespace YamlDB.Yaml.Events
{
	public class StreamEnd : Event
	{
		public StreamEnd()
		{
			base(EventType.STREAM_END_EVENT);
		}
		
		internal StreamEnd.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.STREAM_END_EVENT)
		{
			base.from_raw(event);
		}
		internal override int NestingIncrease { get { return -1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.stream_end_initialize(ref event);
			return event;
		}
	}
}
