/* YamlObject.vala
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
	public abstract class YamlObject : Object, IYamlObject
	{
		protected virtual string get_yaml_tag() { return ""; }

		protected abstract Yaml.Node build_yaml_node(Yaml.NodeBuilder builder);
		protected virtual Yaml.Node? build_unhandled_value_node(Yaml.NodeBuilder builder, Value value) { return null; }
		protected abstract bool apply_yaml_node(Yaml.Node node, Yaml.NodeParser parser);
		protected virtual bool apply_unhandled_value_node(Yaml.Node node, string property_name, Yaml.NodeParser parser) { return false; }
	}
}
