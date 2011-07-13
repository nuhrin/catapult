using YAML;

namespace Catapult.Yaml.Events
{
	public class StreamStart : Event
	{
		public StreamStart(EncodingType encoding = EncodingType.ANY_ENCODING)
		{
			base(EventType.STREAM_START);
			this.encoding = encoding;
		}
		private EncodingType encoding = EncodingType.ANY_ENCODING;

		internal StreamStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.STREAM_START_EVENT)
		{
			base.from_raw(event);
		}
		internal override int NestingIncrease { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.stream_start_initialize(ref event, (YAML.EncodingType)encoding);
			return event;
		}
	}
}
