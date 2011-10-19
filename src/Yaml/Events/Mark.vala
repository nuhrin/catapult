using YAML;
using Catapult.Helpers;

namespace Catapult.Yaml.Events
{
	public class Mark
	{
		public Mark(size_t index = 0, size_t line = 0, size_t column = 0)
		{
			this.index = index;
			this.line = line;
			this.column = column;
		}
		internal Mark.from_raw(YAML.Mark mark)
		{
			index = mark.index;
			line = mark.line;
			column = mark.column;
		}
		public size_t index { get; private set; }
		public size_t line { get; private set; }
		public size_t column { get; private set; }
	}
}
