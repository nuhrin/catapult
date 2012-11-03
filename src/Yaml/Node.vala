/* Node.vala
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
	public abstract class Node
	{
		static int next_id;
		internal static Gee.HashMap<Node,Node> node_mappings;
		internal static Gee.TreeMultiMap<Node,Node> node_children;
		static construct {
			node_mappings = new Gee.HashMap<Node,Node>((Gee.HashDataFunc?)node_hash, (Gee.EqualDataFunc?)node_equal, (Gee.EqualDataFunc?)node_equal);
			node_children = new Gee.TreeMultiMap<Node,Node>((GLib.CompareDataFunc?)node_compare, (GLib.CompareDataFunc?)node_compare);
		}
		static uint node_hash(Node node) { return node.id; }
		static bool node_equal(Node a, Node b) { return (a.id == b.id); }
		static int node_compare(Node a, Node b) { return (int)a.id - (int)b.id; }

		internal Node(string? tag)
		{
			this.tag = tag;
			id = next_id;
			next_id++;
		}
		internal Node.from_event(NodeEvent event) {
			tag = event.tag;
			id = next_id;
			next_id++;
		}
		internal Node.from_raw(RawEvent event)
		{
			tag = event.scalar_tag;
			id = next_id;
			next_id++;
		}
		public string? tag { get; private set; }
		public abstract bool is_canonical { get; }
		public abstract NodeType node_type { get; }


		internal uint id { get; private set; }

		internal abstract Event get_event();

		internal static Node empty {
			get {
				if (_empty == null)
					_empty = new EmptyNode();
				return _empty;
			}
		}
		static Node _empty;
	}
	internal class EmptyNode : Node
	{
		internal EmptyNode()
		{
			base(null);
		}
		public override bool is_canonical { get { return false; } }
		public override NodeType node_type { get { return NodeType.NONE; } }
		internal override Event get_event() { return new EmptyEvent(); }
	}
}
