using YAML;
using Catapult.Helpers;

namespace Catapult.Yaml
{
	public abstract class Node
	{
		static int next_id;
		protected static Gee.HashMap<Node,Node> node_mappings;
		protected static Gee.TreeMultiMap<Node,Node> node_children;
		static construct {
			node_mappings = new Gee.HashMap<Node,Node>((Gee.HashDataFunc?)node_hash, (Gee.EqualDataFunc?)node_equal, (Gee.EqualDataFunc?)node_equal);
			node_children = new Gee.TreeMultiMap<Node,Node>((GLib.CompareDataFunc?)node_compare, (GLib.CompareDataFunc?)node_compare);
		}
		static uint node_hash(Node node) { return node.id; }
		static bool node_equal(Node a, Node b) { return (a.id == b.id); }
		static int node_compare(Node a, Node b) { return (int)a.id - (int)b.id; }

		protected Node(string? anchor, string? tag)
		{
			if (RegexHelper.non_alpha_numeric_characters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);

			this.anchor = anchor;
			this.tag = tag;
			id = next_id;
			next_id++;
		}
		internal Node.from_event(Events.NodeEvent event) {
			anchor = event.anchor;
			tag = event.tag;
			id = next_id;
			next_id++;
		}
		internal Node.from_raw(RawEvent event)
		{
			anchor = event.scalar_anchor;
			tag = event.scalar_tag;
			id = next_id;
			next_id++;
		}
		public string? anchor { get; private set; }
		public string? tag { get; private set; }
		public abstract bool is_canonical { get; }
		public abstract NodeType node_type { get; }


		internal uint id { get; private set; }

		internal abstract Events.Event get_event();

		public static Node empty {
			get {
				if (_empty == null)
					_empty = new EmptyNode();
				return _empty;
			}
		}
		static Node _empty;
	}
	public class EmptyNode : Node
	{
		internal EmptyNode()
		{
			base(null, null);
		}
		public override bool is_canonical { get { return false; } }
		public override NodeType node_type { get { return NodeType.NONE; } }
		internal override Events.Event get_event() { return new Events.EmptyEvent(); }
	}
}
