using YAML;

namespace Catapult.Yaml.Events
{
	public class MappingStart : NodeEvent
	{
		public MappingStart(string? anchor = null, string? tag = null,
							bool implicit = true,
							MappingStyle style = MappingStyle.ANY)
		{
			base(anchor, tag, EventType.MAPPING_START);
			is_implicit = implicit;
			this.style = style;
		}
		public bool is_implicit { get; private set; }
		public override bool is_canonical { get { return !is_implicit; } }
		public MappingStyle style { get; private set; }

		internal MappingStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.MAPPING_START_EVENT)
		{
			base.from_raw(event.mapping_start_anchor, event.mapping_start_tag, event);
			is_implicit = (event.mapping_start_implicit != 0);
			style = (MappingStyle)event.mapping_start_style;
		}
		internal override int nesting_increase { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.mapping_start_initialize(ref event, (uchar*)anchor, (uchar*)tag, is_implicit, (YAML.MappingStyle)style);
			return event;
		}
	}
}
