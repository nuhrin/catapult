using YamlDB.Helpers;

namespace YamlDB
{
	public abstract class Entity : YamlObject
	{		
		public string ID { get; private set; }
		
		protected abstract string generate_id();
		internal string i_generate_id() { return this.generate_id(); }
		internal void set_id(string id) { this.ID = id; }

		protected override string get_yaml_tag()
		{
			return this.get_type().name();
		}

		protected override Yaml.Node build_yaml_node(Yaml.NodeBuilder builder)
		{
			return builder.build_object_mapping(this);
		}
		protected override bool apply_yaml_node(Yaml.Node node, Yaml.NodeParser parser)
		{
			var mapping = node as Yaml.MappingNode;
			if (mapping != null) {
				parser.populate_object(mapping, this);
				return true;
			}
			return false;
		}
	}

	public abstract class NamedEntity : Entity
	{
		public string Name { get; set; }

		protected override string generate_id()
		{
			if (Name == "")
				return "";
			return RegexHelper.NonWordCharacters.replace(Name, "").down();
		}
		protected override Yaml.Node build_yaml_node(Yaml.NodeBuilder builder)
		{
			var mapping = new Yaml.MappingNode();
			mapping.Mappings.ScalarKeyCompareFunc = (a,b)=> {
				if (a.Value == "Name")
					return -1;
				else if (b.Value == "Name")
					return 1;
				return 0;
			};
			builder.populate_object_mapping(mapping, this);
			return mapping;
		}
	}
}
