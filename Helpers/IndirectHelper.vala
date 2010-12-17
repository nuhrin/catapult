using Gee;
using YamlDB.Helpers.IndirectGenerics;
using YamlDB.Helpers.IndirectGenerics.Gee;

namespace YamlDB.Helpers
{
	public class IndirectGenericsHelper
	{
		public class Gee
		{
			public static IndirectMap Map(Type key_type, Type value_type)
			{
				return IndirectFactory.get_bi<IndirectMap>(key_type, value_type);
			}
		}

	}




}
