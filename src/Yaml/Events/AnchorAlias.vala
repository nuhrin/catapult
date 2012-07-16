/* AnchorAlias.vala
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
using Catapult.Helpers;

namespace Catapult.Yaml.Events
{
	public class AnchorAlias : Event
	{
		public AnchorAlias(string anchor)
		{
			base(EventType.ALIAS);
			this.anchor = anchor;
		}
		public string anchor { get; private set; }

		internal AnchorAlias.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.ALIAS_EVENT)
		{
			base.from_raw(event);
			anchor = event.alias_anchor;
			if (RegexHelper.non_alpha_numeric_characters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);
		}
		internal override int nesting_increase { get { return 0; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.alias_initialize(ref event, anchor);
			return event;
		}
	}
}
