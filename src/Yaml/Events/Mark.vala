using YAML;
using Catapult.Helpers;

namespace Catapult.Yaml.Events
{
	public class Mark
	{
		public Mark(size_t index = 0, size_t line = 0, size_t column = 0)
		{
			Index = index;
			Line = line;
			Column = column;
		}
		internal Mark.from_raw(YAML.Mark mark)
		{
			this.Index = mark.index;
			this.Line = mark.line;
			this.Column = mark.column;
		}
		public size_t Index { get; private set; }
		public size_t Line { get; private set; }
		public size_t Column { get; private set; }
	}
}
