/* SequenceStart.vala
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
	internal class SequenceStart : NodeEvent
	{
		public SequenceStart(string? anchor=null, string? tag=null,
							bool implicit = true,
							SequenceStyle style = SequenceStyle.ANY)
		{
			base(anchor, tag, EventType.SEQUENCE_START);
			is_implicit = implicit;
			this.style = style;
		}
		public bool is_implicit { get; private set; }
		public override bool is_canonical { get { return !is_implicit; } }
		public SequenceStyle style { get; private set; }

		internal SequenceStart.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SEQUENCE_START_EVENT)
		{
			base.from_raw(event.sequence_start_anchor, event.sequence_start_tag, event);
			is_implicit = (event.sequence_start_implicit != 0);
			style = (SequenceStyle)event.sequence_start_style;
		}
		internal override int nesting_increase { get { return 1; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.sequence_start_initialize(ref event, (uchar*)anchor, (uchar*)tag, is_implicit, (YAML.SequenceStyle)style);
			return event;
		}
	}
}
