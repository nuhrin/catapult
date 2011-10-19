using YAML;
using Catapult.Helpers;

namespace Catapult.Yaml.Events
{
	public class AnchorAlias : Event
	{
		public AnchorAlias(string anchor)
		{
			base(EventType.ALIAS);
			this.anchor = anchor;
		}
		public string anchor { get; private set; }

		internal AnchorAlias.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.ALIAS_EVENT)
		{
			base.from_raw(event);
			anchor = event.alias_anchor;
			if (RegexHelper.non_alpha_numeric_characters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);
		}
		internal override int nesting_increase { get { return 0; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.alias_initialize(ref event, anchor);
			return event;
		}
	}
}
