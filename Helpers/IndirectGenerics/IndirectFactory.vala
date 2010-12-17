using Gee;

namespace YamlDB.Helpers.IndirectGenerics
{
	public class IndirectFactory
	{
		static HashMap<string, IndirectUni> _unis;
		static HashMap<string, IndirectBi> _bis;
		static HashMap<string, IndirectTri> _tris;

		public static T get_uni<T>(Type a_type)
		{
			if (_unis == null)
				_unis = new HashMap<string, IndirectUni>();
			string key = typeof(T).name() + a_type.name();
			if (_unis.has_key(key))
				return (T)_unis[key];

			IndirectUni uni = IndirectUni.create<T>(a_type);
			_unis[key] = uni;
			return (T)uni;
		}
		public static T get_bi<T>(Type a_type, Type b_type)
		{
			if (_bis == null)
				_bis = new HashMap<string, IndirectBi>();
			string key = typeof(T).name() + a_type.name() + b_type.name();
			if (_bis.has_key(key))
				return (T)_bis[key];

			IndirectBi bi = IndirectBi.create<T>(a_type, b_type);

			_bis[key] = bi;
			return (T)bi;
		}
		public static T get_tri<T>(Type a_type, Type b_type, Type c_type)
		{
			if (_tris == null)
				_tris = new HashMap<string, IndirectTri>();
			string key = typeof(T).name() + a_type.name() + b_type.name() + c_type.name();
			if (_tris.has_key(key))
				return (T)_tris[key];

			IndirectTri tri = IndirectTri.create<T>(a_type, b_type, c_type);
			_tris[key] = tri;
			return (T)tri;
		}
	}

}
