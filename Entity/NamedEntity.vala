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
			return RegexHelper.NonWordCharacters.replace(Name, "").down();			
		}
		
		protected override void emit_yaml(EntityEmitter emitter) throws YamlException
		{
			emitter.start_mapping(this.get_tag(), false);
			emitter.emit_property(this, "Name");
			unowned ObjectClass klass = this.get_class();
	    	var properties = klass.list_properties();
	    	foreach(var prop in properties)
	    	{
		    	if (prop.name != "Name")
		    		emitter.emit_property(this, prop.get_name());
	    	}
			emitter.end_mapping();
		}
//		public override string ToString ()
//		{
//			return
//			return string.Format("[NamedEntity: Name={0}]", Name);
//		}

	}
}

