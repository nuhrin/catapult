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
using Catapult.Helpers.IndirectGenerics;
using Catapult.Helpers.IndirectGenerics.Gee;

namespace Catapult.Helpers
{
	public class IndirectGenericsHelper
	{
		public class Gee
		{
			public class Map
			{
				public static Type key_type(global::Gee.Map obj) { return IndirectMap.key_type(obj); }
				public static Type value_type(global::Gee.Map obj) { return IndirectMap.value_type(obj); }
				public static IndirectMap indirect(Type key_type, Type value_type)
				{
					return IndirectFactory.get_bi<IndirectMap>(key_type, value_type);
				}
			}
			public class Collection
			{
				public static Type element_type(global::Gee.Collection obj) { return IndirectCollection.element_type(obj); }
				public static IndirectCollection indirect(Type element_type)
				{
					return IndirectFactory.get_uni<IndirectCollection>(element_type);
				}
			}
			public class List
			{
				public static Type element_type(global::Gee.List obj) { return IndirectCollection.element_type(obj); }
				public static IndirectCollection indirect(Type element_type)
				{
					return IndirectFactory.get_uni<IndirectList>(element_type);
				}
			}
		}

	}




}
