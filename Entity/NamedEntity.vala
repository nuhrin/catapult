using YamlDB.Helpers;

namespace YamlDB.Entity
{	
	public abstract class NamedEntity : Entity
	{		
		public string Name { get; set; }
		
		protected override string generate_id()
		{
			if (Name == "")
				return "";
			return RegexHelper.NonWordCharacters.replace(Name, "");			
		}
		
		protected override void emit_yaml(EntityEmitter emitter)
		{
			assert_not_reached();
//			emitter.StartMapping(null, GetTag(), false, MappingStyle.Any);
//			emitter.EmitProperty("Name", Name as object);
//			
//			foreach(PropertyData property in this.GetType().GetAllPropertyData())
//			{
//				if (property.Name != "Name" && property.CanWrite == true)
//					emitter.EmitProperty(this, property);
//			}
//					
//			emitter.EndMapping();

		}
//		public override string ToString ()
//		{
//			return
//			return string.Format("[NamedEntity: Name={0}]", Name);
//		}

	}
}

