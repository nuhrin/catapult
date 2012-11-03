/* NodeEvent.vala
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

namespace Catapult.Yaml
{
	internal abstract class NodeEvent : Event
	{
		protected NodeEvent(string? anchor, string? tag, EventType type)
		{
			base(type);
			if (RegexHelper.non_alpha_numeric_characters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);

			this.anchor = anchor;
			this.tag = tag;
		}
		internal NodeEvent.from_raw(string? anchor, string? tag, RawEvent event)
		{
			base.from_raw(event);
			this.anchor = anchor;
			this.tag = tag;
		}
		public string? anchor { get; private set; }
		public string? tag { get; private set; }

		public abstract bool is_canonical { get; }
	}
}
