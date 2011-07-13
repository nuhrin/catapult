using Gee;
using Catapult.Helpers.IndirectGenerics;
using Catapult.Helpers.IndirectGenerics.Gee;

namespace Catapult.Helpers
{
	public class IndirectGenericsHelper
	{
		public class Gee
		{
			public class Map
			{
				public static Type key_type(global::Gee.Map obj) { return IndirectMap.key_type(obj); }
				public static Type value_type(global::Gee.Map obj) { return IndirectMap.value_type(obj); }
				public static IndirectMap indirect(Type key_type, Type value_type)
				{
					return IndirectFactory.get_bi<IndirectMap>(key_type, value_type);
				}
			}
			public class Collection
			{
				public static Type element_type(global::Gee.Collection obj) { return IndirectCollection.element_type(obj); }
				public static IndirectCollection indirect(Type element_type)
				{
					return IndirectFactory.get_uni<IndirectCollection>(element_type);
				}
			}
			public class List
			{
				public static Type element_type(global::Gee.List obj) { return IndirectCollection.element_type(obj); }
				public static IndirectCollection indirect(Type element_type)
				{
					return IndirectFactory.get_uni<IndirectList>(element_type);
				}
			}
		}

	}




}
