/* ValueHelper.vala
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
 
namespace Catapult.Helpers
{
	public class ValueHelper
	{
		public static Value populate_value<T>(T val) {
			Type type = typeof(T);
			Value retVal = Value(type);
			if (val == null)
				return retVal;

			if (type.is_object())
				retVal.set_object((Object)val);
			else if (type.is_enum())
				retVal.set_enum((int)val);
			else if (type.is_flags())
				retVal.set_flags((uint)val);
			else if (type == typeof(string))
				retVal.set_string((string)val);
			else if (type == typeof(int))
				retVal.set_int((int)val);
			else if (type == typeof(bool))
				retVal.set_boolean((bool)val);
			else if (type == typeof(char))
				retVal.set_char((char)val);
			else if (type == typeof(uchar))
				retVal.set_uchar((uchar)val);
			else if (type == typeof(uint))
				retVal.set_uint((uint)val);
			else if (type == typeof(long))
				retVal.set_long((long)val);
			else if (type == typeof(ulong))
				retVal.set_ulong((ulong)val);
			else if (type == typeof(int64))
				retVal.set_int64((int64)val);
			else if (type == typeof(uint64))
				retVal.set_uint64((int64)val);
			else if (type == typeof(Type))
				retVal.set_gtype((Type)val);

			// unsupported due to being unsupported as generic type: float/double
//			else if (type == typeof(float))
//				retVal.set_float(val);
//			else if (type == typeof(double))
//				retVal.set_double(val);
			else
				error("Unsupported type: %s", type.name());

			return retVal;
		}
		public static T extract_value<T>(Value val) {
			Type type = typeof(T);
			if (type.is_object())
				return (T)val.get_object();
			else if (type.is_enum())
				return val.get_enum();
			else if (type.is_flags())
				return val.get_flags();
			else if (type == typeof(string))
				return val.get_string();
			else if (type == typeof(int))
				return val.get_int();
			else if (type == typeof(bool))
				return val.get_boolean();
			else if (type == typeof(char))
				return val.get_char();
			else if (type == typeof(uchar))
				return val.get_uchar();
			else if (type == typeof(uint))
				return val.get_uint();
			else if (type == typeof(long))
				return val.get_long();
			else if (type == typeof(ulong))
				return val.get_ulong();
			else if (type == typeof(int64))
				return val.get_int64();
			else if (type == typeof(uint64))
				return val.get_uint64();
			else if (type == typeof(Type))
				return val.get_gtype();

			// unsupported due to being unsupported as generic type: float/double
//			else if (type == typeof(float))
//				return val.get_float();
//			else if (type == typeof(double))
//				return val.get_double();


			if (type.is_a(Type.BOXED))
				debug("Got BOXED type: "+type.name());
			if (type.is_classed())
				debug("Is Classed: "+type.name());
			error("Unsupported type: %s", type.name());
		}
	}
}
