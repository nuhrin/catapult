namespace YamlDB.Yaml
{
	public class Constants
	{
		public class Tag
		{
			public static string DEFAULT_SCALAR { get { return YAML.DEFAULT_SCALAR_TAG; } }
			public static string DEFAULT_SEQUENCE { get { return YAML.DEFAULT_SEQUENCE_TAG; } }
			public static string DEFAULT_MAPPING_TAG { get { return YAML.DEFAULT_MAPPING_TAG; } }
			public static string NULL { get { return YAML.NULL_TAG; } }
			public static string BOOL { get { return YAML.BOOL_TAG; } }
			public static string STR { get { return YAML.STR_TAG; } }
			public static string INT { get { return YAML.INT_TAG; } }
			public static string FLOAT { get { return YAML.FLOAT_TAG; } }
			public static string TIMESTAMP { get { return YAML.TIMESTAMP_TAG; } }
			public static string SEQ { get { return YAML.SEQ_TAG; } }
			public static string MAP { get { return YAML.MAP_TAG; } }
		}
	}
}