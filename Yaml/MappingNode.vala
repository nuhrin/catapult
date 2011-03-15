
namespace YamlDB.Yaml
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
			Mappings = new OrderedMappingSet();
		}
		internal MappingNode.from_event(Events.MappingStart event) {
			base.from_event(event);
			IsImplicit = event.IsImplicit;
			Style = event.Style;
			Mappings = new OrderedMappingSet();
		}
		public bool IsImplicit { get; private set; }
		public MappingStyle Style { get; private set; }
		public override bool IsCanonical { get { return !IsImplicit; } }
		public override NodeType Type { get { return NodeType.MAPPING; } }

		public OrderedMappingSet Mappings { get; private set; }

		internal override Events.Event get_event() {
			return new Events.MappingStart(Anchor, Tag, IsImplicit, Style);
		}
	}
}
