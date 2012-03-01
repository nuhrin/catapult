namespace Catapult
{
	public abstract class EntityProvider<E> : Object
	{
		DataInterface di;
		protected EntityProvider(string root_folder) throws RuntimeError
		{
			if (typeof(E).is_a(typeof(Entity)) == false)
				error("Type E (%s) is not an Entity type.", typeof(E).name());
			di = new DataInterface(root_folder);
		}
		
		public void register_entity_provider<T>(EntityProvider<T> provider) {
			di.register_entity_provider<T>(provider);
		}
		
		protected abstract Entity? get_entity(string entity_id);		
		internal Entity? i_get_entity(string entity_id) { return get_entity(entity_id); }		
		
		protected E load(string entity_id, string? data_folder=null) throws RuntimeError, YamlError, FileError
		{
			return di.load<E>(entity_id, data_folder);
		}
		protected Enumerable<E> load_all(bool throw_on_error=true) throws RuntimeError, YamlError, FileError
		{
			return di.load_all<E>(throw_on_error);
		}
		protected void save(E entity, string? entity_id=null, string? data_folder=null) throws YamlError, RuntimeError, FileError
		{
			di.save((Entity)entity, entity_id, data_folder);
		}
		protected void remove(E entity) throws RuntimeError, Error
		{
			di.remove((Entity)entity);
		}
		
	}
}
