/* Entity.vala
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
 
using Catapult.Helpers;

namespace Catapult
{
	public abstract class Entity : YamlObject
	{
		public string id { get; private set; }

		protected abstract string generate_id();
		internal string i_generate_id() { return this.generate_id(); }
		internal void i_set_id(string id) { this.id = id; }
	}

	public abstract class NamedEntity : Entity
	{
		public string name { get; set; }

		protected override string generate_id()
		{
			if (name == null || name == "")
				return "";
			return RegexHelper.non_word_characters.replace(name, "").down();
		}
//~ 		protected override Yaml.Node build_yaml_node(Yaml.NodeBuilder builder)
//~ 		{
//~ 			var mapping = new Yaml.MappingNode(this.get_tag());
//~ 			mapping.Mappings.ScalarKeyCompareFunc = (a,b)=> {
//~ 				if (a.Value == "name")
//~ 					return -1;
//~ 				else if (b.Value == "name")
//~ 					return 1;
//~ 				return 0;
//~ 			};
//~ 			builder.populate_object_mapping(mapping, this);
//~ 			return mapping;
//~ 		}
	}
}
