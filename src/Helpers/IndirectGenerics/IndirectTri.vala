/* IndirectTri.vala
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
	internal abstract class IndirectTri<A,B,C> : Object
	{
		public static IndirectTri create<T>(Type a_type, Type b_type, Type c_type)
		{
			Value a_type_value = Value(typeof(Type));
			a_type_value.set_gtype(a_type);
			Value b_type_value = Value(typeof(Type));
			b_type_value.set_gtype(c_type);
			Value c_type_value = Value(typeof(Type));
			c_type_value.set_gtype(c_type);

			Parameter[] params = new Parameter[3];
			params[0] = Parameter() { name = "a-type", value = a_type_value };
			params[1] = Parameter() { name = "b-type", value = b_type_value };
			params[1] = Parameter() { name = "c-type", value = c_type_value };
			
			var result = Object.newv(typeof(T), params) as IndirectTri;
			result._a_type = a_type;
			result._b_type = b_type;
			result._c_type = c_type;
			return result;
		}
		Type _a_type;
		Type _b_type;
		Type _c_type;
		
		protected void assert_correct_types(string* context_method, string* a_type_name, Type a_type, string* b_type_name, Type b_type, string* c_type_name, Type c_type) {
			if (a_type != _a_type) {
				error("%s.%s: expected %s type '%s', got '%s'.", 
					this.get_type().name(), context_method, a_type_name,
					a_type.name(), typeof(A).name());
			}
			if (b_type != _b_type) {
				error("%s.%s: expected %s type '%s', got '%s'.", 
					this.get_type().name(), context_method, b_type_name,
					b_type.name(), typeof(B).name());
			}
			if (c_type != _c_type) {
				error("%s.%s: expected %s type '%s', got '%s'.", 
					this.get_type().name(), context_method, c_type_name,
					c_type.name(), typeof(C).name());
			}			
		}		
	}
}
