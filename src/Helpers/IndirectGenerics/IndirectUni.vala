/* IndirectUni.vala
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
 
namespace Catapult
{
	internal abstract class IndirectUni<A> : Object
	{
		public static IndirectUni create<T>(Type a_type)
		{
			Value a_type_value = Value(typeof(Type));
			a_type_value.set_gtype(a_type);

			Parameter[] params = new Parameter[1];
			params[0] = Parameter() { name = "a-type", value = a_type_value };
			
			var result = Object.newv(typeof(T), params) as IndirectUni;
			result._a_type = a_type;
			return result;
		}
		Type _a_type;
		
		protected void assert_correct_type(string* context_method, string* a_type_name, Type a_type) {
			if (a_type != _a_type) {
				error("%s.%s: expected %s type '%s', got '%s'.", 
					this.get_type().name(), context_method, a_type_name,
					a_type.name(), typeof(A).name());
			}			
		}
	}
}
