/* DocumentEnd.vala
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
	internal class DocumentEnd : Event
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
