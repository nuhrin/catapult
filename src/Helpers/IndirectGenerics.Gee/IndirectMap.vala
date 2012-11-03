/* IndirectMap.vala
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
	internal class IndirectMap<A,B> : IndirectBi<A,B>
	{
		public new void set(Map obj, Value key, Value value)
		{
			assert_correct_map_types("set", obj);
			A k = ValueHelper.extract_value<A>(key);
			B v = ValueHelper.extract_value<B>(value);
			(obj as Map<A,B>).set(k, v);
		}
		public new Value get(Map obj, Value key)
		{
			assert_correct_map_types("get", obj);
			A k = ValueHelper.extract_value<A>(key);
			B v = (obj as Map<A,B>).get(k);
			var type = typeof(B);
			Value typed_value = Value(type);
			if (type == typeof(string))
				typed_value.take_string((string)v);
			else if (type.is_object())
				typed_value.take_object((Object)v);
			else
				typed_value = ValueHelper.populate_value<A>(v);
			return typed_value;
		}
		public Value[] get_keys(Map obj)
		{
			assert_correct_map_types("get_keys", obj);
			var map = (obj as Map<A,B>);
			Value[] values = new Value[map.size];
			int index = 0;
			var type = typeof(A);
			foreach(A key in map.keys)
			{
				Value typed_value = Value(type);
				if (type == typeof(string))
					typed_value.take_string((string)key);
				else if (type.is_object())
					typed_value.take_object((Object)key);
				else
					typed_value = ValueHelper.populate_value<A>(key);

				values[index] = typed_value;
				index++;
			}
			return values;
		}
		
		protected void assert_correct_map_types(string* context_method, Map obj) {
			assert_correct_types(context_method, "key", obj.key_type, "value", obj.value_type);			
		}
		// other methods not currently used
//~ 		public new Map create(Type type) requires(type.is_a(typeof(Map)))
//~ 		{
//~ 			if (type == typeof(HashMap))
//~ 				return new HashMap<A,B>();
//~ 			else if (type == typeof(TreeMap))
//~ 				return new TreeMap<A,B>();
//~ 			else if (type == typeof(AbstractMap))
//~ 				return new HashMap<A,B>();
//~ 			else if (type == typeof(Map))
//~ 				return new HashMap<A,B>();
//~ 
//~ 			assert_not_reached();
//~ 		}
//~ 
//~ 		public bool has_key(Map obj, Value key)
//~ 		{
//~ 			A k = ValueHelper.extract_value<A>(key);
//~ 			return (obj as Map<A,B>).has_key(k);
//~ 		}
	}
}
