using YamlDB.Yaml.Events;

namespace YamlDB.Entity
{
	public abstract class Entity : YamlObject
	{		
		public string ID { get; private set; }
		
		protected abstract string generate_id();
		internal string i_generate_id() { return this.generate_id(); }
		internal void set_id(string id) { this.ID = id; }

		protected override void emit_yaml(EntityEmitter emitter) throws YamlError
		{
			emitter.start_mapping(this.get_tag(), false);
			emitter.emit_properties(this);
			emitter.end_mapping();
		}

		protected override Object read_yaml(EntityReader reader) throws YamlError
		{
			reader.populate_object_properties(this);
			return this;
		}
		
		protected override void populate_entity_data (Object yamlData)
		{			
		}
		
	}
}
