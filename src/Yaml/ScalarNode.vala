using YAML;

namespace Catapult.Yaml
{
	public class ScalarNode : Node
	{
		public ScalarNode(string? anchor, string? tag, string value,
		              bool plain_implicit = true, bool quoted_implicit = false,
		              ScalarStyle style = ScalarStyle.ANY)
		{
			base(anchor, tag);
			this.value = value;
			is_plain_implicit = plain_implicit;
			is_quoted_implicit = quoted_implicit;
			this.style = style;
		}
		internal ScalarNode.from_event(Events.Scalar event) {
			base.from_event(event);
			this.value = event.value;
			is_plain_implicit = event.is_plain_implicit;
			is_quoted_implicit = event.is_quoted_implicit;
			this.style = event.style;
		}
		internal ScalarNode.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SCALAR_EVENT)
		{
			base.from_raw(event);
			value = event.scalar_value;
			is_plain_implicit = (event.scalar_plain_implicit != 0);
			is_quoted_implicit = (event.scalar_quoted_implicit != 0);
			style = (ScalarStyle)event.scalar_style;
		}
		public string value { get; private set; }
		public bool is_plain_implicit { get; private set; }
		public bool is_quoted_implicit { get; private set; }
		public ScalarStyle style { get; private set; }
		public override bool is_canonical { get { return !is_plain_implicit && !is_quoted_implicit; } }
		public override NodeType node_type { get { return NodeType.SCALAR; } }

		internal override Events.Event get_event() {
			return new Events.Scalar(anchor, tag, value, is_plain_implicit, is_quoted_implicit, style);
		}

		public new static ScalarNode empty {
			get {
				if (_empty == null)
					_empty = new EmptyScalarNode();
				return _empty;
			}
		}
		static ScalarNode _empty;
	}
	public class EmptyScalarNode : ScalarNode
	{
		internal EmptyScalarNode() {
			base(null, null, "");
		}
	}
}
