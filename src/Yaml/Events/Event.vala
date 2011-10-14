using YAML;

namespace Catapult.Yaml.Events
{
	public abstract class Event : Object
	{
		public Event(EventType type)
		{
			Type = type;
		}
		internal Event.from_raw(RawEvent event)
		{
			Start = new Mark.from_raw(event.start_mark);
			End = new Mark.from_raw(event.end_mark);
			Type = (EventType)event.type;
		}
		public Mark Start { get; private set; }
		public Mark End { get; private set; }

		public EventType Type { get; private set; }
		internal abstract int NestingIncrease { get; }

		internal abstract RawEvent create_raw_event();

		public virtual string to_string() { return "[%s]".printf(this.get_type().name().replace("CatapultYamlEvents", "")); }
	}
	public class EmptyEvent : Event
	{
		public EmptyEvent()
		{
			base(EventType.NO_EVENT);
		}
		internal override int NestingIncrease { get { return 0; } }
		internal override RawEvent create_raw_event()
		{
			RawEvent event = RawEvent();
			event.type = (YAML.EventType)Type;
			return event;
		}
	}
}
