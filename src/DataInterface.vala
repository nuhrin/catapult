using Gee;
using Catapult.Helpers;

namespace Catapult
{
	public class DataInterface : Object
	{
		Yaml.NodeBuilder builder;
		Yaml.NodeParser parser;

		public DataInterface(string root_folder) throws RuntimeError
		{
			if (is_valid_foldername(root_folder) == false)
				throw new RuntimeError.ARGUMENT("Invalid root folder: '%s'", root_folder);

			RootFolder = root_folder;
			builder = new Yaml.NodeBuilder();
			parser = new Yaml.NodeParser(this);
		}
		public string RootFolder { get; private set; }

		public T create<T>(string? entity_id=null) throws RuntimeError requires(typeof(T).is_a(typeof(Entity)))
		{
			if (entity_id == null)
				return (T)Object.new(typeof(T));

			if (is_valid_entity_id(entity_id) == false)
				throw new RuntimeError.ARGUMENT("Invalid Entity ID: '%s'", entity_id);
			Entity e = Object.new(typeof(T)) as Entity;
			e.i_set_id(entity_id);
			return (T)e;
		}

		public Enumerable<T> load_all<T>() throws RuntimeError, YamlError, FileError requires(typeof(T).is_a(typeof(Entity)))
		{
			return load_all_of_type(typeof(T)).of_type<T>();
		}
		public Enumerable<Entity> load_all_of_type(Type entity_type) throws RuntimeError, YamlError, FileError requires(entity_type.is_a(typeof(Entity)))
		{
			string type_name = entity_type.name();
			string data_folder = get_data_folder(type_name);
			Dir d;
			try {
				d = Dir.open(data_folder);
			} catch (FileError ex) {
				print("FileError: %s\n", ex.message);
				return Enumerable.empty<Entity>();
			}

			ArrayList<Entity> entities = new ArrayList<Entity>();
			string filename;
			while ((filename = d.read_name()) != null) {
				entities.add(load_internal(filename, type_name, entity_type));
			}

			return new Enumerable<Entity>(entities);
		}
		public T load<T>(string entity_id, string? data_folder=null) throws RuntimeError, YamlError, FileError
			requires(typeof(T).is_a(typeof(Entity)))
		{
			return (T)load_internal(entity_id, data_folder, typeof(T));
		}
		internal Entity load_internal(string entity_id, string? data_folder, Type entity_type) throws RuntimeError, FileError, YamlError
		{
			if (is_valid_entity_id(entity_id) == false)
				throw new RuntimeError.ARGUMENT("Invalid Entity ID: '%s'", entity_id);

			string folder = (data_folder != null) ? data_folder : entity_type.name();

			string entity_file = get_entity_file_path(folder, entity_id, false);
			if (FileUtils.test(entity_file, FileTest.EXISTS) == false)
				throw new RuntimeError.FILE("%s '%s' not found.", entity_type.name(), entity_id);

			string yaml;
			if (FileUtils.get_contents(entity_file, out yaml) == false)
				throw new RuntimeError.FILE("File not found: %s", entity_file);

			var document = new Yaml.DocumentReader.from_string(yaml).read_document();
			Entity entity = (Entity)parser.parse_value_of_type(document.Root, entity_type);
			entity.i_set_id(entity_id);

			return entity;
		}

//		internal class DataLoadInterface<T>
//		{
//			static HashMap<Type, DataLoadInterface> instances;
//			public static DataLoadInterface<T> instance<T>() {
//				if (instances == null)
//					instances = new HashMap<Type, DataLoadInterface>();
//				if (instances.has_key(typeof(T)))
//					return instances[typeof(T)];
//
//				var instance = new DataLoadInterface<T>();
//				instances[typeof(T)] = instance;
//				return instance;
//			}
//			public Enumerable<T> load_all(DataInterface di) throws RuntimeError, FileError, YamlError
//			{
//				string folder = typeof(T).name();
//				string data_folder = di.get_data_folder(folder);
//				if (FileUtils.test(data_folder, FileTest.EXISTS) == false)
//					return Enumerable.empty<T>();
//
//				Type entity_type = typeof(T);
//				YieldEnumeratorPopulate<T> populate = p=> {
//					Dir d;
//					try {
//						d = Dir.open(data_folder);
//					} catch (FileError ex) {
//						return;
//					}
//
//					string filename;
//					while ((filename = d.read_name()) != null) {
//						Value v = Value(entity_type);
//						v.set_object(di.load_internal(filename, data_folder, entity_type));
//						p.yield_value(v);
//					}
//				};
//				return Enumerable.yielding<T>(populate);
//			}
//		}

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

		static bool is_valid_filename(string filename)
		{
			if (filename == "")
				return false;
			return !RegexHelper.NonWordCharacters.match(filename);
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
				return RootFolder;
			if (is_valid_foldername(folder) == false)
				throw new RuntimeError.ARGUMENT("Invalid folder name: '%s'", folder);

			return Path.build_filename(RootFolder, folder);
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
