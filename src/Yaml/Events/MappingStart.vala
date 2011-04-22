using YAML;

namespace YamlDB.Yaml.Events
{
	public class MappingStart : NodeEvent
	{
		public MappingStart(string? anchor = null, string? tag = null,
							bool implicit = true,
							MappingStyle style = MappingStyle.ANY)
		{
			base(anchor, tag, EventType.MAPPING_START);
			IsImplicit = implicit;
			Style = style;
		}
		public bool IsImplicit { get; private set; }
		public override bool IsCanonical { get { return !IsImplicit; } }
		public MappingStyle Style { get; private set; }

		internal MappingStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.MAPPING_START_EVENT)
		{
			base.from_raw(event.data.mapping_start.anchor, event.data.mapping_start.tag, event);
			IsImplicit = (event.data.mapping_start.implicit != 0);
			Style = (MappingStyle)event.data.mapping_start.style;
		}
		internal override int NestingIncrease { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.mapping_start_initialize(ref event, (uchar*)Anchor, (uchar*)Tag, IsImplicit, (YAML.MappingStyle)Style);
			return event;
		}
	}
}
