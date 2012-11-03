/* IndirectEnumerable.vala
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
	internal class IndirectEnumerable<A> : IndirectIterable<A>
	{
		public Collection create_collection_obj() {
			return new ArrayList<A>();
		}
		
		public void change_basis(Enumerable enumerable, Iterable new_basis) {
			assert_correct_type("change_basis, enumerable", "element", enumerable.element_type);
			assert_correct_type("change_basis, new_basis", "element", new_basis.element_type);
			((Enumerable<A>)enumerable).iterable = (Iterable<A>)new_basis;
		}		
	}
}
