/* IndirectFactory.vala
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
	internal class IndirectFactory
	{
		static HashMap<string, IndirectUni> _unis;
		static HashMap<string, IndirectBi> _bis;
//~ 		static HashMap<string, IndirectTri> _tris;

		public static T get_uni<T>(Type a_type)
		{
			if (_unis == null)
				_unis = new HashMap<string, IndirectUni>();
			string key = typeof(T).name() + a_type.name();
			if (_unis.has_key(key))
				return (T)_unis[key];

			IndirectUni uni = IndirectUni.create<T>(a_type);
			_unis[key] = uni;
			return (T)uni;
		}
		public static T get_bi<T>(Type a_type, Type b_type)
		{
			if (_bis == null)
				_bis = new HashMap<string, IndirectBi>();
			string key = typeof(T).name() + a_type.name() + b_type.name();
			if (_bis.has_key(key))
				return (T)_bis[key];

			IndirectBi bi = IndirectBi.create<T>(a_type, b_type);

			_bis[key] = bi;
			return (T)bi;
		}
//~ 		public static T get_tri<T>(Type a_type, Type b_type, Type c_type)
//~ 		{
//~ 			if (_tris == null)
//~ 				_tris = new HashMap<string, IndirectTri>();
//~ 			string key = typeof(T).name() + a_type.name() + b_type.name() + c_type.name();
//~ 			if (_tris.has_key(key))
//~ 				return (T)_tris[key];
//~ 
//~ 			IndirectTri tri = IndirectTri.create<T>(a_type, b_type, c_type);
//~ 			_tris[key] = tri;
//~ 			return (T)tri;
//~ 		}
	}

}
