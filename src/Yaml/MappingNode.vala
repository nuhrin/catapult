/* MappingNode.vala
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
 

using YAML;

namespace Catapult.Yaml
{
	public class MappingNode : Node
	{
		public MappingNode(string? anchor = null, string? tag = null,
						   bool implicit = true,
						   MappingStyle style = MappingStyle.ANY)
		{
			base(anchor, tag);
			is_implicit = implicit;
			this.style = style;
		}
		internal MappingNode.from_event(Events.MappingStart event) {
			base.from_event(event);
			is_implicit = event.is_implicit;
			this.style = event.style;
		}
		internal MappingNode.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.MAPPING_START_EVENT)
		{
			base.from_raw(event);
			is_implicit = (event.mapping_start_implicit != 0);
			style = (MappingStyle)event.mapping_start_style;
		}
		public bool is_implicit { get; private set; }
		public MappingStyle style { get; private set; }
		public override bool is_canonical { get { return !is_implicit; } }
		public override NodeType node_type { get { return NodeType.MAPPING; } }

		public bool has_key(Node key) { return node_mappings.has_key(key); }
		public new Node get(Node key) { return node_mappings[key]; }
		public new void set(Node key, Node value) {
			node_children.set(this, key);
			node_mappings.set(key, value);
		}

		public Node? get_scalar(string key) {
			foreach(var scalar_key in scalar_keys()) {
				if (scalar_key.value == key)
					return get(scalar_key);
			}
			return null;			
		}
		public void set_scalar(string key, Node value) {
			this.set(new ScalarNode(null, null, key), value);
		}
		public Enumerable<Node> keys() { return new Enumerable<Node>(node_children.get(this)); }
		public Enumerable<ScalarNode> scalar_keys() { return (Enumerable<ScalarNode>)keys().where(n=>n.node_type == NodeType.SCALAR); }

		internal override Events.Event get_event() {
			return new Events.MappingStart(anchor, tag, is_implicit, style);
		}
	}
}
