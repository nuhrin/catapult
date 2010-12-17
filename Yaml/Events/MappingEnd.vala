using YAML;

namespace YamlDB.Yaml.Events
{
	public class MappingEnd : Event
	{
		public MappingEnd()
		{
			base(EventType.MAPPING_END_EVENT);
		}
		internal MappingEnd.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.MAPPING_END_EVENT)
		{
			base.from_raw(event);
		}
		internal override int NestingIncrease { get { return -1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.mapping_end_initialize(ref event);
			return event;
		}
	}
}
