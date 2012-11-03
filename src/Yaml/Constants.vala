/* Constants.vala
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
 
namespace Catapult.Yaml
{
	internal class Constants
	{
		public class Tag
		{
			public static string DEFAULT_SCALAR { get { return YAML.DEFAULT_SCALAR_TAG; } }
			public static string DEFAULT_SEQUENCE { get { return YAML.DEFAULT_SEQUENCE_TAG; } }
			public static string DEFAULT_MAPPING_TAG { get { return YAML.DEFAULT_MAPPING_TAG; } }
			public static string NULL { get { return YAML.NULL_TAG; } }
			public static string BOOL { get { return YAML.BOOL_TAG; } }
			public static string STR { get { return YAML.STR_TAG; } }
			public static string INT { get { return YAML.INT_TAG; } }
			public static string FLOAT { get { return YAML.FLOAT_TAG; } }
			public static string TIMESTAMP { get { return YAML.TIMESTAMP_TAG; } }
			public static string SEQ { get { return YAML.SEQ_TAG; } }
			public static string MAP { get { return YAML.MAP_TAG; } }
		}
	}
}
