namespace YamlDB
{
	public abstract class YamlObject : Object
	{			
		protected virtual string get_tag_name() 
		{
			return this.get_type().name();			
		}
		internal string i_get_tag_name()  { return this.get_tag_name(); }
		
		protected abstract void emit_yaml(EntityEmitter emitter);	
		internal void i_emit_yaml(EntityEmitter emitter) { emit_yaml(emitter); }
		
		protected abstract Object read_yaml(EntityReader reader);
		internal Object i_read_yaml(EntityReader reader) { return read_yaml(reader); }
		
		protected abstract void populate_entity_data(Object yamlData);
		internal void i_populate_entity_data(Object yamlData) { populate_entity_data(yamlData); }			
	}
}
