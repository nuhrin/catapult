/* EntityProvider.vala
 * 
 * Copyright (C) 2012 nuhrin
 * 
 * This file is part of catapult.
 * 
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */
 
namespace Catapult
{
	public abstract class EntityProvider<E>
	{
		DataInterface di;
		protected EntityProvider(string root_folder) throws RuntimeError
		{
			if (typeof(E).is_a(typeof(Entity)) == false)
				error("Type E (%s) is not an Entity type.", typeof(E).name());
			di = new DataInterface(root_folder);
			parser = di.get_parser();
		}
		protected Yaml.NodeParser parser { get; private set; }
				
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
			di.save((Entity)entity, entity_id, data_folder ?? typeof(E).name());
		}
		protected void remove(E entity, string? data_folder=null) throws RuntimeError, Error
		{
			di.remove((Entity)entity, data_folder ?? typeof(E).name());
		}				
		
		protected void register_entity_provider<G>(EntityProvider<G> provider) {
			di.register_entity_provider<G>(provider);
		}		
		
		protected Enumerable<string> get_ids() throws RuntimeError, FileError
		{
			return di.get_entity_ids(typeof(E));
		}
		protected Yaml.Document load_document(string entity_id, string? data_folder=null) throws RuntimeError, YamlError
		{
			return di.load_entity_document(entity_id, data_folder, typeof(E));
		}
		protected void apply_yaml_node(E entity, Yaml.Node node) {
			((Entity)entity).i_apply_yaml_node(node, parser);
		}
		protected void set_id(E entity, string id) {
			((Entity)entity).i_set_id(id);
		}
	}
}
