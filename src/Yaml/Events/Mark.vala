/* Mark.vala
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
	internal class Mark
	{
		public Mark(size_t index = 0, size_t line = 0, size_t column = 0)
		{
			this.index = index;
			this.line = line;
			this.column = column;
		}
		internal Mark.from_raw(YAML.Mark mark)
		{
			index = mark.index;
			line = mark.line;
			column = mark.column;
		}
		public size_t index { get; private set; }
		public size_t line { get; private set; }
		public size_t column { get; private set; }
	}
}
