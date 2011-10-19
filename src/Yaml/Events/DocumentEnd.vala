using YAML;

namespace Catapult.Yaml.Events
{
	public class DocumentEnd : Event
	{
		public DocumentEnd(bool implicit)
		{
			base(EventType.DOCUMENT_END);
			is_implicit = implicit;
		}
		public bool is_implicit { get; private set; }

		internal DocumentEnd.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.DOCUMENT_END_EVENT)
		{
			base.from_raw(event);
			is_implicit = (event.document_end_implicit != 0);
		}
		internal override int nesting_increase { get { return -1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.document_end_initialize(ref event, is_implicit);
			return event;
		}
	}
}
