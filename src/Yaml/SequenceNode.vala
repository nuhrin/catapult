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
			is_implicit = implicit;
			this.style = style;
		}
		internal SequenceNode.from_event(Events.SequenceStart event) {
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
		internal override Events.Event get_event() {
			return new Events.SequenceStart(anchor, tag, is_implicit, style);
		}

	}
}
