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
			IsImplicit = implicit;
			Style = style;
		}
		internal MappingNode.from_event(Events.MappingStart event) {
			base.from_event(event);
			IsImplicit = event.IsImplicit;
			Style = event.Style;
		}
		internal MappingNode.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.MAPPING_START_EVENT)
		{
			base.from_raw(event);
			IsImplicit = (event.mapping_start_implicit != 0);
			Style = (MappingStyle)event.mapping_start_style;
		}
		public bool IsImplicit { get; private set; }
		public MappingStyle Style { get; private set; }
		public override bool IsCanonical { get { return !IsImplicit; } }
		public override NodeType Type { get { return NodeType.MAPPING; } }

		public bool has_key(Node key) { return node_mappings.has_key(key); }
		public new Node get(Node key) { return node_mappings[key]; }
		public new void set(Node key, Node value) {
			node_children.set(this, key);
			node_mappings.set(key, value);
		}

		public void set_scalar(string key, Node value) {
			this.set(new ScalarNode(null, null, key), value);
		}
		public Enumerable<Node> keys() { return new Enumerable<Node>(node_children.get(this)); }
		public Enumerable<ScalarNode> scalar_keys() { return (Enumerable<ScalarNode>)keys().where(n=>n.Type == NodeType.SCALAR); }

		internal override Events.Event get_event() {
			return new Events.MappingStart(Anchor, Tag, IsImplicit, Style);
		}
	}
}
