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
			if (RegexHelper.NonAlphaNumericCharacters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);

			Anchor = anchor;
			Tag = tag;
			id = next_id;
			next_id++;
		}
		internal Node.from_event(Events.NodeEvent event) {
			Anchor = event.Anchor;
			Tag = event.Tag;
			id = next_id;
			next_id++;
		}
		internal Node.from_raw(RawEvent event)
		{
			Anchor = event.scalar_anchor;
			Tag = event.scalar_tag;
			id = next_id;
			next_id++;
		}
		public string? Anchor { get; private set; }
		public string? Tag { get; private set; }
		public abstract bool IsCanonical { get; }
		public abstract NodeType Type { get; }
		public Yaml.NodeType get_node_type() { return Type; }


		internal uint id { get; private set; }

		internal abstract Events.Event get_event();

		public static Node Empty {
			get {
				if (empty == null)
					empty = new EmptyNode();
				return empty;
			}
		}
		static Node empty;
	}
	public class EmptyNode : Node
	{
		internal EmptyNode()
		{
			base(null, null);
		}
		public override bool IsCanonical { get { return false; } }
		public override NodeType Type { get { return NodeType.NONE; } }
		internal override Events.Event get_event() { return new Events.EmptyEvent(); }
	}
}
