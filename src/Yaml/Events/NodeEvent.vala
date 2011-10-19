using YAML;
using Catapult.Helpers;

namespace Catapult.Yaml.Events
{
	public abstract class NodeEvent : Event
	{
		protected NodeEvent(string? anchor, string? tag, EventType type)
		{
			base(type);
			if (RegexHelper.non_alpha_numeric_characters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);

			this.anchor = anchor;
			this.tag = tag;
		}
		internal NodeEvent.from_raw(string? anchor, string? tag, RawEvent event)
		{
			base.from_raw(event);
			this.anchor = anchor;
			this.tag = tag;
		}
		public string? anchor { get; private set; }
		public string? tag { get; private set; }

		public abstract bool is_canonical { get; }
	}
}
