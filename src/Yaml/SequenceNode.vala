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
			Items = new NodeList();
		}
		internal SequenceNode.from_event(Events.SequenceStart event) {
			base.from_event(event);
			IsImplicit = event.IsImplicit;
			Style = event.Style;
			Items = new NodeList();
		}
		public bool IsImplicit { get; private set; }
		public SequenceStyle Style { get; private set; }
		public override bool IsCanonical { get { return !IsImplicit; } }
		public override NodeType Type { get { return NodeType.SEQUENCE; } }

		public NodeList Items { get; private set; }

		internal override Events.Event get_event() {
			return new Events.SequenceStart(Anchor, Tag, IsImplicit, Style);
		}

	}
}
