
namespace YamlDB.Entity
{
	public abstract class Entity : YamlObject
	{		
		public string ID { get; internal set; }
		
		protected abstract string generate_id();
		internal string i_generate_id() { return this.generate_id(); }
		
		protected override void emit_yaml(EntityEmitter emitter)
		{
			assert_not_reached();
//			emitter.StartMapping(null, GetTag(), false, MappingStyle.Any);
//			emitter.EmitProperties(this);			
//			emitter.EndMapping();
		}

		protected override Object read_yaml(EntityReader reader)
		{
			assert_not_reached();
			//return reader.ReadProperties(this);
		}		
		
		protected override void populate_entity_data (Object yamlData)
		{			
		}
		
	}
}
