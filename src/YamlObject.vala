namespace Catapult
{
	public abstract class YamlObject : Object, IYamlObject
	{
		protected virtual string get_yaml_tag() { return ""; }

		protected abstract Yaml.Node build_yaml_node(Yaml.NodeBuilder builder);
		protected virtual Yaml.Node? build_unhandled_value_node(Yaml.NodeBuilder builder, Value value) { return null; }
		protected abstract bool apply_yaml_node(Yaml.Node node, Yaml.NodeParser parser);
		protected virtual bool apply_unhandled_value_node(Yaml.Node node, string property_name, Yaml.NodeParser parser) { return false; }
	}
}
