using Catapult.Helpers;

namespace Catapult
{
	public abstract class Entity : YamlObject
	{
		public string id { get; private set; }

		protected abstract string generate_id();
		internal string i_generate_id() { return this.generate_id(); }
		internal void i_set_id(string id) { this.id = id; }

		protected override string get_yaml_tag()
		{
			return this.get_type().name();
		}

		protected override Yaml.Node build_yaml_node(Yaml.NodeBuilder builder)
		{
			var mapping = new Yaml.MappingNode(null, this.get_tag());
			builder.populate_object_mapping(mapping, this);
			return mapping;
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
		public string name { get; set; }

		protected override string generate_id()
		{
			if (name == null || name == "")
				return "";
			return RegexHelper.NonWordCharacters.replace(name, "").down();
		}
		protected override Yaml.Node build_yaml_node(Yaml.NodeBuilder builder)
		{
			var mapping = new Yaml.MappingNode(null, this.get_tag());
			mapping.Mappings.ScalarKeyCompareFunc = (a,b)=> {
				if (a.Value == "name")
					return -1;
				else if (b.Value == "name")
					return 1;
				return 0;
			};
			builder.populate_object_mapping(mapping, this);
			return mapping;
		}
	}
}
