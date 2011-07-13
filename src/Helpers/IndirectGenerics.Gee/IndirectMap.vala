using Gee;

namespace Catapult.Helpers.IndirectGenerics.Gee
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

		public new Map create(Type type) requires(type.is_a(typeof(Map)))
		{
			if (type == typeof(HashMap))
				return new HashMap<A,B>();
			else if (type == typeof(TreeMap))
				return new TreeMap<A,B>();
			else if (type == typeof(AbstractMap))
				return new HashMap<A,B>();
			else if (type == typeof(Map))
				return new HashMap<A,B>();

			assert_not_reached();
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

		public Value[] get_keys(Map obj)
		{
			var map = (obj as Map<A,B>);
			Value[] values = new Value[map.size];
			int index = 0;
			foreach(A key in map.keys)
			{
				values[index] = ValueHelper.populate_value<A>(key);
				index++;
			}
			return values;
		}
	}
}
