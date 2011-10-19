using YAML;

namespace Catapult.Yaml.Events
{
	public abstract class Event : Object
	{
		public Event(EventType event_type)
		{
			this.event_type = event_type;
		}
		internal Event.from_raw(RawEvent event)
		{
			start = new Mark.from_raw(event.start_mark);
			end = new Mark.from_raw(event.end_mark);
			event_type = (EventType)event.type;
		}
		public Mark start { get; private set; }
		public Mark end { get; private set; }

		public EventType event_type { get; private set; }
		internal abstract int nesting_increase { get; }

		internal abstract RawEvent create_raw_event();

		public virtual string to_string() { return "[%s]".printf(this.get_type().name().replace("CatapultYamlEvents", "")); }
	}
	public class EmptyEvent : Event
	{
		public EmptyEvent()
		{
			base(EventType.NO_EVENT);
		}
		internal override int nesting_increase { get { return 0; } }
		internal override RawEvent create_raw_event()
		{
			RawEvent event = RawEvent();
			event.type = (YAML.EventType)event_type;
			return event;
		}
	}
}
