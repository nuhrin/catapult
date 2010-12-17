using YAML;

namespace YamlDB.Yaml.Events
{
	public class DocumentEnd : Event
	{
		public DocumentEnd(bool implicit)
		{
			base(EventType.DOCUMENT_END_EVENT);
			IsImplicit = implicit;
		}
		public bool IsImplicit { get; private set; }

		internal DocumentEnd.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.DOCUMENT_END_EVENT)
		{
			base.from_raw(event);
			IsImplicit = (event.data.document_end.implicit != 0);
		}
		internal override int NestingIncrease { get { return -1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.document_end_initialize(ref event, IsImplicit);
			return event;
		}
	}
}
