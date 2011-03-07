namespace YamlDB
{
	public abstract class YamlObject : Object
	{			
		protected virtual string get_yaml_tag()
		{
			return this.get_type().name();			
		}
		internal string? get_tag()
		{
			string tag = get_yaml_tag();
			if (tag != "")
			{
				if (tag.get(0) == '!')
					return tag;
				return "!" + tag;
			}
			return null;
		}

		protected abstract void emit_yaml(EntityEmitter emitter) throws YamlError;
		internal void i_emit_yaml(EntityEmitter emitter) throws YamlError { emit_yaml(emitter); }
		
		protected abstract Object read_yaml(EntityReader reader) throws YamlError;
		internal Object i_read_yaml(EntityReader reader) throws YamlError { return read_yaml(reader); }
		
		protected abstract void populate_entity_data(Object yamlData);
		internal void i_populate_entity_data(Object yamlData) { populate_entity_data(yamlData); }			
	}
}
