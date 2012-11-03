/* IndirectIterable.vala
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
 
using Gee;

namespace Catapult
{
	internal class IndirectIterable<A> : IndirectUni<A>
	{		
		public Value[] get_values(Iterable obj)
		{
			assert_correct_type("add", "element", obj.element_type);
			var iterable = (obj as Iterable<A>);
			ValueArray values = new ValueArray(0);
			var type = typeof(A);
			foreach(A item in iterable) {
				Value typed_value = Value(type);
				if (type == typeof(string))
					typed_value.take_string((string)item);
				else if (type.is_object())
					typed_value.take_object((Object)item);
				else
					typed_value = ValueHelper.populate_value<A>(item);

				values.append(typed_value);
			}

			return values.values;
		}
	}
}
