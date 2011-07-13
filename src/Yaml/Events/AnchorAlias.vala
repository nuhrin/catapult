using YAML;
using Catapult.Helpers;

namespace Catapult.Yaml.Events
{
	public class AnchorAlias : Event
	{
		public AnchorAlias(string anchor)
		{
			base(EventType.ALIAS);
			Anchor = anchor;
		}
		public string Anchor { get; private set; }

		internal AnchorAlias.from_raw(RawEvent event)
			requires(event.type == YAML.EventType.ALIAS_EVENT)
		{
			base.from_raw(event);
			Anchor = event.data.alias.anchor;
			if (RegexHelper.NonAlphaNumericCharacters.match(Anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", Anchor);
		}
		internal override int NestingIncrease { get { return 0; } }

		internal override RawEvent create_raw_event()
		{
			RawEvent event = {0};
			RawEvent.alias_initialize(ref event, Anchor);
			return event;
		}
	}
}
