/* IndirectGenericsHelper.vala
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
	internal class IndirectGenericsHelper
	{
		public class Enumerable 
		{
			public static IndirectEnumerable indirect(global::Catapult.Enumerable enumerable) {
				return IndirectFactory.get_uni<IndirectEnumerable>(enumerable.element_type);
			}
		}
		public class Gee
		{
			public class Map
			{
				public static IndirectMap indirect(global::Gee.Map map) {
					return IndirectFactory.get_bi<IndirectMap>(map.key_type, map.value_type);
				}
			}
			public class Iterable
			{
				public static IndirectIterable indirect(global::Gee.Iterable iterable) {
					return IndirectFactory.get_uni<IndirectIterable>(iterable.element_type);
				}
				public static Value[] get_values(global::Gee.Iterable iterable) {
					return Iterable.indirect(iterable).get_values(iterable);
				}
			}
			public class Collection
			{
				public static IndirectCollection indirect(global::Gee.Collection collection) {
					return IndirectFactory.get_uni<IndirectCollection>(collection.element_type);
				}
			}
//~ 			public class List
//~ 			{
//~ 				public static IndirectCollection indirect(global::Gee.List list) {
//~ 					return IndirectFactory.get_uni<IndirectList>(list.element_type);
//~ 				}
//~ 			}
		}

	}




}
