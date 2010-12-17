using Gee;

namespace YamlDB.Helpers.IndirectGenerics.Gee
{
	public class IndirectCollection<A> : IndirectUni<A>
	{
		public static Type element_type(Collection obj)
		{
			Value prop_value = Value(typeof(Type));
			(obj as Object).get_property("element-type", ref prop_value);
			return prop_value.get_gtype();
		}

		public Collection empty() { return Collection.empty<A>(); }

		public int size(Collection obj) { return obj.size; }
		public bool is_empty(Collection obj) { return obj.is_empty; }

		public bool contains(Collection obj, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			return (obj as Collection<A>).contains(v);
		}
		public void add(Collection obj, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			(obj as Collection<A>).add(v);
		}
		public void remove(Collection obj, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			(obj as Collection<A>).remove(v);
		}

		public void clear(Collection obj) { obj.clear(); }
	}
}