namespace YamlDB
{
	public abstract class YamlObject : Object, IYamlObject
	{			
		protected virtual string get_yaml_tag() { return ""; }

		protected abstract Yaml.Node build_yaml_node(Yaml.NodeBuilder builder);
		protected abstract bool apply_yaml_node(Yaml.Node node, Yaml.NodeParser parser);
	}
}
