/* DataInterface.vala
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
 
using Gee;
using Catapult.Helpers;

namespace Catapult
{
	public class DataInterface
	{
		Yaml.NodeBuilder builder;
		Yaml.NodeParser parser;
		HashMap<Type,EntityProvider> provider_hash;

		public DataInterface(string root_folder) throws RuntimeError
		{
			if (is_valid_foldername(root_folder) == false)
				throw new RuntimeError.ARGUMENT("Invalid root folder: '%s'", root_folder);

			this.root_folder = root_folder;
			builder = new Yaml.NodeBuilder();
			parser = new Yaml.NodeParser.with_data_interface(this);
		}
		public string root_folder { get; private set; }

		public E create<E>(string? entity_id=null) throws RuntimeError requires(typeof(E).is_a(typeof(Entity)))
		{
			if (entity_id == null)
				return (E)Object.new(typeof(E));

			if (is_valid_entity_id(entity_id) == false)
				throw new RuntimeError.ARGUMENT("Invalid Entity ID: '%s'", entity_id);
			Entity e = Object.new(typeof(E)) as Entity;
			e.i_set_id(entity_id);
			return (E)e;
		}

		public E load<E>(string entity_id, string? data_folder=null) throws RuntimeError, YamlError, FileError
			requires(typeof(E).is_a(typeof(Entity)))
		{
			return (E)load_internal(entity_id, data_folder, typeof(E));
		}
		
		public Enumerable<E> load_all<E>(bool throw_on_error=true) throws RuntimeError, YamlError, FileError requires(typeof(E).is_a(typeof(Entity)))
		{
			return load_all_of_type(typeof(E)).of_type<E>();
		}
		public Enumerable<Entity> load_all_of_type(Type entity_type, bool throw_on_error=true) throws RuntimeError, YamlError, FileError requires(entity_type.is_a(typeof(Entity)))
		{
			string type_name = entity_type.name();
			string data_folder = get_data_folder(type_name);
			Dir d;
			try {
				d = Dir.open(data_folder);
			} catch (FileError e) {
				if (throw_on_error)
					throw e;
				warning("FileError: %s", e.message);
				return Enumerable.empty<Entity>();
			}

			ArrayList<Entity> entities = new ArrayList<Entity>();
			string filename;
			while ((filename = d.read_name()) != null) {
				try {
					entities.add(load_internal(filename, type_name, entity_type));
				} catch(RuntimeError e) {
					if (throw_on_error)
						throw e;
					warning("RuntimeError: %s", e.message);					
				} catch(YamlError e) {
					if (throw_on_error)
						throw e;
					warning("YamlError: %s", e.message);					
				}
			}

			return new Enumerable<Entity>(entities);
		}
		
		public void save(Entity entity, string? entity_id=null, string? data_folder=null) throws YamlError, RuntimeError, FileError
		{
			string id = entity_id;
			if (entity_id == null)
			{
				id = (entity.id != null && entity.id != "") ? entity.id : entity.i_generate_id();
				if (is_valid_entity_id(id) == false)
					throw new RuntimeError.ARGUMENT("Entity could not be saved: Invalid Entity ID: '%s'", id);
			}
			if (data_folder == null)
				data_folder = entity.get_type().name();

//			//if (string.IsNullOrEmpty(entity.ID) == false && entityID != entity.ID)
//			//	Rename(...);
//			//		(this would mean updating any references to this entity also)
//						// save all entity references also?
//			// only when they have actually changed? how to do this? while keeping data in automatic properties? attribute?
//
			string filepath = get_entity_file_path(data_folder, id, true);
			string yaml = get_yaml(entity);
			//print("yaml:\n%s\n", yaml);
			FileUtils.set_contents(filepath, yaml + "\n");
			entity.i_set_id(id);
		}
		public void remove(Entity entity) throws RuntimeError, Error
		{
			if (entity.id == null || entity.id == "")
				throw new RuntimeError.ARGUMENT("Invalid attempt to delete unsaved %s entity.");
			string data_folder = entity.get_type().name();
			string filepath = get_entity_file_path(data_folder, entity.id, true);
			if (FileUtils.test(filepath, FileTest.EXISTS) == false)
				throw new RuntimeError.FILE("%s entity '%s' not found for deletion.", entity.get_type().name(), entity.id);
			var file = File.new_for_path(filepath);
			file.delete();
		}

		public void register_entity_provider<E>(EntityProvider<E> provider) {
			if (provider_hash == null)
				provider_hash = new HashMap<Type,EntityProvider>();
			provider_hash[typeof(E)] = provider;
		}
		public EntityProvider? get_provider(Type type) {
			return (has_entity_provider(type)) ? provider_hash[type] : null;
		}
				
		internal Yaml.NodeParser get_parser() { return parser; }
		internal Entity load_internal(string entity_id, string? data_folder, Type entity_type) throws RuntimeError, YamlError
		{
			//if (is_valid_entity_id(entity_id) == false)
			//	throw new RuntimeError.ARGUMENT("Invalid Entity ID: '%s'", entity_id);

			if (has_entity_provider(entity_type) == true) {
				var e = provider_hash[entity_type].i_get_entity(entity_id);
				if (e == null)
					throw new RuntimeError.ARGUMENT("%s entity not found: %s", entity_type.name(), entity_id);
				return e;
			}
			
			var document = load_entity_document(entity_id, data_folder, entity_type);
			
			Entity entity = (Entity)parser.parse_value_of_type(document.root, entity_type);
			entity.i_set_id(entity_id);

			return entity;
		}
		internal Yaml.Document load_entity_document(string entity_id, string? data_folder, Type entity_type) throws RuntimeError, YamlError
		{
			string folder = (data_folder != null) ? data_folder : entity_type.name();

			string entity_file = get_entity_file_path(folder, entity_id, false);
			if (FileUtils.test(entity_file, FileTest.EXISTS) == false)
				throw new RuntimeError.FILE("%s '%s' not found.", entity_type.name(), entity_id);

			var file = FileStream.open(entity_file, "r");
			if (file == null)
				throw new RuntimeError.FILE("File not found: %s", entity_file);

			return new Yaml.DocumentReader(file).read_document();
		}
		internal Enumerable<string> get_entity_ids(Type entity_type) throws RuntimeError, FileError
		{
			string type_name = entity_type.name();
			string data_folder = get_data_folder(type_name);
			Dir d = Dir.open(data_folder);
						
			ArrayList<string> ids = new ArrayList<string>();
			string filename;
			while ((filename = d.read_name()) != null) {
				ids.add(filename);
			}
			
			return new Enumerable<string>(ids);
		}
		
		bool has_entity_provider(Type type) {
			return (provider_hash != null && provider_hash.has_key(type));
		}
		
		static bool is_valid_filename(string filename)
		{
			if (filename == "")
				return false;
			return !RegexHelper.non_filename_characters.match(filename);
			//return true;
		}
		static bool is_valid_foldername(string folder)
		{
			return true;
			//return is_valid_filename(folder);
		}
		static bool is_valid_entity_id(string entity_id)
		{
			return is_valid_filename(entity_id);
		}

		string get_data_folder(string folder) throws RuntimeError
		{
			if (folder == "")
				return root_folder;
			if (is_valid_foldername(folder) == false)
				throw new RuntimeError.ARGUMENT("Invalid folder name: '%s'", folder);

			return Path.build_filename(root_folder, folder);
		}
		string get_entity_file_path(string folder, string entity_id, bool ensure_folder_exists) throws RuntimeError
		{
			var data_folder = get_data_folder(folder);
			if (ensure_folder_exists == true)
			{
				if (FileUtils.test(data_folder, FileTest.EXISTS) == false)
					DirUtils.create_with_parents(data_folder, 0770);
			}
			return Path.build_filename(data_folder, entity_id);
		}

		string get_yaml(Entity entity) throws YamlError
		{
			StringBuilder sb = new StringBuilder();
			var writer = new Yaml.DocumentWriter.to_string_builder(sb);
			var node = entity.i_build_yaml_node(this.builder);
			var document = new Yaml.Document(node);
			writer.write_document(document);
			writer.flush();
			return sb.str;
		}

	}
}
