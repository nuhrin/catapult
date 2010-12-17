using Gee;

namespace YamlDB.Helpers.IndirectGenerics.Gee
{
	public class IndirectMap<A,B> : IndirectBi<A,B>
	{
		public static Type key_type(Map obj)
		{
			Value prop_value = Value(typeof(Type));
			(obj as Object).get_property("key-type", ref prop_value);
			return prop_value.get_gtype();
		}
		public static Type value_type(Map obj)
		{
			Value prop_value = Value(typeof(Type));
			(obj as Object).get_property("value-type", ref prop_value);
			return prop_value.get_gtype();
		}

		public new void set(Map obj, Value key, Value value)
		{
			A k = ValueHelper.extract_value<A>(key);
			B v = ValueHelper.extract_value<B>(value);
			(obj as Map<A,B>).set(k, v);
		}
		public bool has_key(Map obj, Value key)
		{
			A k = ValueHelper.extract_value<A>(key);
			return (obj as Map<A,B>).has_key(k);
		}
		public new Value get(Map obj, Value key)
		{
			A k = ValueHelper.extract_value<A>(key);
			B v = (obj as Map<A,B>).get(k);
			return ValueHelper.populate_value<B>(v);
		}
	}
}