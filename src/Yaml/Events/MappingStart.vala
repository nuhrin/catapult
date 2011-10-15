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
			IsImplicit = implicit;
			Style = style;
		}
		public bool IsImplicit { get; private set; }
		public override bool IsCanonical { get { return !IsImplicit; } }
		public MappingStyle Style { get; private set; }

		internal MappingStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.MAPPING_START_EVENT)
		{
			base.from_raw(event.mapping_start_anchor, event.mapping_start_tag, event);
			IsImplicit = (event.mapping_start_implicit != 0);
			Style = (MappingStyle)event.mapping_start_style;
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
