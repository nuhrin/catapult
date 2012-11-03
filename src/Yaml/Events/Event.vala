/* Event.vala
 * 
 * Copyright (C) 2012 nuhrin
 * 
 * This file is part of catapult.
 * 
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */
 
using YAML;

namespace Catapult.Yaml
{
	internal abstract class Event : Object
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

//~ 		public virtual string to_string() { return "[%s]".printf(this.get_type().name().replace("CatapultYamlEvents", "")); }
	}
	internal class EmptyEvent : Event
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
