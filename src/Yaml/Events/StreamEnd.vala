/* StreamEnd.vala
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
	internal class StreamEnd : Event
	{
		public StreamEnd()
		{
			base(EventType.STREAM_END);
		}

		internal StreamEnd.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.STREAM_END_EVENT)
		{
			base.from_raw(event);
		}
		internal override int nesting_increase { get { return -1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.stream_end_initialize(ref event);
			return event;
		}
	}
}
