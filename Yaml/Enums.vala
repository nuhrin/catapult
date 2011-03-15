namespace YamlDB.Yaml
{

	public enum MappingStyle {
		ANY,
		BLOCK,
		FLOW
	}

	public enum NodeType {
		NONE,
		SCALAR,
		SEQUENCE,
		MAPPING
	}

	public enum ScalarStyle {
		ANY,
		PLAIN,
		SINGLE_QUOTED,
		DOUBLE_QUOTED,
		LITERAL,
		FOLDED
	}

	public enum SequenceStyle{
		ANY,
		BLOCK,
		FLOW
	}
}
