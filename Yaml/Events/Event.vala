using YAML;

namespace YamlDB.Yaml.Events
{
	public abstract class Event : Object
	{
		public Event(EventType type)
		{
			Type = type;
		}
		internal Event.from_raw(RawEvent event)
		{
			Start = event.start_mark;
			End = event.end_mark;
			Type = event.type;
		}
		public Mark Start { get; private set; }
		public Mark End { get; private set; }
		
		public EventType Type { get; private set; }
		internal abstract int NestingIncrease { get; }

		internal abstract RawEvent create_raw_event();

		public virtual string to_string() { return "[%s]".printf(this.get_type().name().replace("YamlDBEvents", "")); }
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
			event.type = Type;
			return event;
		}
	}
}
