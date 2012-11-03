/* IndirectList.vala
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
	internal class IndirectList<A> : IndirectCollection<A>
	{
		public new global::Gee.List create(Type type) requires(type.is_a(typeof(global::Gee.List)))
		{
			if (type == typeof(ArrayList))
				return new ArrayList<A>();
			else if (type == typeof(LinkedList))
				return new LinkedList<A>();
			else if (type == typeof(AbstractList))
				return new ArrayList<A>();
			else if (type == typeof(global::Gee.List))
				return new ArrayList<A>();

			assert_not_reached();
		}

		public new global::Gee.List empty() { return global::Gee.List.empty<A>(); }

		public new Value get(global::Gee.List obj, int index)
		{
			A v = (obj as global::Gee.List<A>).get(index);
			return ValueHelper.populate_value<A>(v);
		}
		public new void set(global::Gee.List obj, int index, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			(obj as global::Gee.List<A>).set(index, v);
		}
		public int index_of(global::Gee.List obj, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			return (obj as global::Gee.List<A>).index_of(v);
		}
		public void insert(global::Gee.List obj, int index, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			(obj as global::Gee.List<A>).insert(index, v);
		}
		public Value remove_at(global::Gee.List obj, int index)
		{
			A v = (obj as global::Gee.List<A>).remove_at(index);
			return ValueHelper.populate_value<A>(v);
		}
		public global::Gee.List<A>? slice(global::Gee.List obj, int start, int stop)
		{
			return obj.slice(start, stop);
		}
		public Value first(global::Gee.List obj)
		{
			A v = (obj as global::Gee.List<A>).first();
			return ValueHelper.populate_value<A>(v);
		}
		public Value last(global::Gee.List obj)
		{
			A v = (obj as global::Gee.List<A>).last();
			return ValueHelper.populate_value<A>(v);
		}
	}
}
