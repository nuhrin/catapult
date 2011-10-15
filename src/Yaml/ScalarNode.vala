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
			Value = value;
			IsPlainImplicit = plain_implicit;
			IsQuotedImplicit = quoted_implicit;
			Style = style;
		}
		internal ScalarNode.from_event(Events.Scalar event) {
			base.from_event(event);
			Value = event.Value;
			IsPlainImplicit = event.IsPlainImplicit;
			IsQuotedImplicit = event.IsQuotedImplicit;
			Style = event.Style;
		}
		internal ScalarNode.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.SCALAR_EVENT)
		{
			base.from_raw(event);
			IsPlainImplicit = (event.scalar_plain_implicit != 0);
			IsQuotedImplicit = (event.scalar_quoted_implicit != 0);
			Value = event.scalar_value;
			Style = (ScalarStyle)event.scalar_style;
		}
		public string Value { get; private set; }
		public bool IsPlainImplicit { get; private set; }
		public bool IsQuotedImplicit { get; private set; }
		public ScalarStyle Style { get; private set; }
		public override bool IsCanonical { get { return !IsPlainImplicit && !IsQuotedImplicit; } }
		public override NodeType Type { get { return NodeType.SCALAR; } }

		internal override Events.Event get_event() {
			return new Events.Scalar(Anchor, Tag, Value, IsPlainImplicit, IsQuotedImplicit, Style);
		}

		public new static ScalarNode Empty {
			get {
				if (empty == null)
					empty = new EmptyScalarNode();
				return empty;
			}
		}
		static ScalarNode empty;
	}
	public class EmptyScalarNode : ScalarNode
	{
		internal EmptyScalarNode() {
			base(null, null, "");
		}
	}
}
