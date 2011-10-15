using YAML;
using Catapult.Helpers;

namespace Catapult.Yaml
{
	public abstract class Node : Object
	{
		protected Node(string? anchor, string? tag)
		{
			if (RegexHelper.NonAlphaNumericCharacters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);

			Anchor = anchor;
			Tag = tag;
		}
		internal Node.from_event(Events.NodeEvent event) {
			Anchor = event.Anchor;
			Tag = event.Tag;
		}
		internal Node.from_raw(RawEvent event)
		{
			Anchor = event.scalar_anchor;
			Tag = event.scalar_tag;
		}
		public string? Anchor { get; private set; }
		public string? Tag { get; private set; }
		public abstract bool IsCanonical { get; }
		public abstract NodeType Type { get; }
		public Yaml.NodeType get_node_type() { return Type; }

		internal abstract Events.Event get_event();
		internal int SortOrder { get; set; }

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
