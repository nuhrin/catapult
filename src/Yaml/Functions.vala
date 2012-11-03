/* Functions.vala
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

namespace Catapult.Yaml 
{
	public Type? get_tag_type(string tag)
	{
		ensure_mappings();
		if (tagTypeMappings.has_key(tag) == true)
			return (Type?)tagTypeMappings[tag];
		if (predefinedTypes.has_key(tag) == true)
			return (Type?)predefinedTypes[tag];

		return null;
	}

	public void set_tag_type(Type type, string tag)
	{
		ensure_mappings();
		tagTypeMappings[tag] = type;
	}

	private HashMap<string, Type> tagTypeMappings;
	private HashMap<string, Type> predefinedTypes;
	private void ensure_mappings() {
		if (tagTypeMappings == null)
			tagTypeMappings = new HashMap<string, Type>();

		if (predefinedTypes == null) {
			predefinedTypes = new HashMap<string, Type>();
			predefinedTypes.set(YAML.MAP_TAG, typeof(HashMap));
			predefinedTypes.set(YAML.SEQ_TAG, typeof(ArrayList));
			predefinedTypes.set(YAML.BOOL_TAG, typeof(bool));
			predefinedTypes.set(YAML.FLOAT_TAG, typeof(double));
			predefinedTypes.set(YAML.INT_TAG, typeof(int));
			predefinedTypes.set(YAML.STR_TAG, typeof(string));
		}
	}
}
