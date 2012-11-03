/* SequenceNode.vala
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
	public class SequenceNode : Node
	{
		public SequenceNode(string? tag = null,
							bool implicit = true,
							SequenceStyle style = SequenceStyle.ANY)
		{
			base(tag);
			is_implicit = implicit;
			this.style = style;
		}
		internal SequenceNode.from_event(SequenceStart event) {
			base.from_event(event);
			is_implicit = event.is_implicit;
			style = event.style;
		}
		internal SequenceNode.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SEQUENCE_START_EVENT)
		{
			base.from_raw(event);
			is_implicit = (event.sequence_start_implicit != 0);
			style = (SequenceStyle)event.sequence_start_style;
		}
		public bool is_implicit { get; private set; }
		public SequenceStyle style { get; private set; }
		public override bool is_canonical { get { return !is_implicit; } }
		public override NodeType node_type { get { return NodeType.SEQUENCE; } }

		public new void add(Node node) { node_children.set(this, node); }

		public int item_count() { return node_children.get(this).size; }
		public Enumerable<Node> items() {
			return new Enumerable<Node>(node_children.get(this));
		}

		public Enumerable<ScalarNode> scalars() {
			return (Enumerable<ScalarNode>)items().where(n=>n.node_type == NodeType.SCALAR);
		}
		public Enumerable<MappingNode> mappings() {
			return (Enumerable<MappingNode>)items().where(n=>n.node_type == NodeType.MAPPING);
		}
		public Enumerable<SequenceNode> sequences() {
			return (Enumerable<SequenceNode>)items().where(n=>n.node_type == NodeType.SEQUENCE);
		}
		internal override Event get_event() {
			return new SequenceStart(null, tag, is_implicit, style);
		}

	}
}
