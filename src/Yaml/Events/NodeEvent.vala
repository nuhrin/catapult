using YAML;
using YamlDB.Helpers;

namespace YamlDB.Yaml.Events
{
	public abstract class NodeEvent : Event
	{
		protected NodeEvent(string? anchor, string? tag, EventType type)
		{
			base(type);
			initialize(anchor, tag);
		}
		internal NodeEvent.from_raw(string? anchor, string? tag, RawEvent event)
		{
			base.from_raw(event);
			initialize(anchor, tag);
		}
		private void initialize(string? anchor, string? tag)
		{
			if (RegexHelper.NonAlphaNumericCharacters.match(anchor))
				error("Anchor value must contain alphanumerical characters only: %s.", anchor);

			Anchor = anchor;
			Tag = tag;
		}
		public string? Anchor { get; private set; }
		public string? Tag { get; private set; }
		
		public abstract bool IsCanonical { get; }
	}
}
