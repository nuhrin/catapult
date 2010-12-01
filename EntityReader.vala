using YAML;
using YamlDB.Yaml.Events;

namespace YamlDB
{
	public class EntityReader : Object
	{
		public EventReader reader { get; private set; }
		
		public EntityReader(FileStream input)
		{
			reader = new EventReader(input);
		}
		public EntityReader.from_string(string yaml)
		{
			reader = new EventReader.from_string(yaml);
		}
	}
}