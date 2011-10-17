using YAML;

namespace Catapult.Yaml
{
	public class SequenceNode : Node
	{
		public SequenceNode(string? anchor=null, string? tag=null,
							bool implicit = true,
							SequenceStyle style = SequenceStyle.ANY)
		{
			base(anchor, tag);
			IsImplicit = implicit;
			Style = style;
		}
		internal SequenceNode.from_event(Events.SequenceStart event) {
			base.from_event(event);
			IsImplicit = event.IsImplicit;
			Style = event.Style;
		}
		internal SequenceNode.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SEQUENCE_START_EVENT)
		{
			base.from_raw(event);
			IsImplicit = (event.sequence_start_implicit != 0);
			Style = (SequenceStyle)event.sequence_start_style;
		}
		public bool IsImplicit { get; private set; }
		public SequenceStyle Style { get; private set; }
		public override bool IsCanonical { get { return !IsImplicit; } }
		public override NodeType Type { get { return NodeType.SEQUENCE; } }

		public new void add(Node node) { node_children.set(this, node); }

		public int item_count() { return node_children.get(this).size; }
		public Enumerable<Node> items() {
			return new Enumerable<Node>(node_children.get(this));
		}

		public Enumerable<ScalarNode> scalars() {
			return (Enumerable<ScalarNode>)items().where(n=>n.Type == NodeType.SCALAR);
		}
		public Enumerable<MappingNode> mappings() {
			return (Enumerable<MappingNode>)items().where(n=>n.Type == NodeType.MAPPING);
		}
		public Enumerable<SequenceNode> sequences() {
			return (Enumerable<SequenceNode>)items().where(n=>n.Type == NodeType.SEQUENCE);
		}
		internal override Events.Event get_event() {
			return new Events.SequenceStart(Anchor, Tag, IsImplicit, Style);
		}

	}
}
