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
			var type = typeof(B);
			Value typed_value = Value(type);
			if (type == typeof(string))
				typed_value.take_string((string)v);
			else if (type.is_object())
				typed_value.take_object((Object)v);
			else
				typed_value = v;
			return typed_value;
		}

		public Value[] get_keys(Map obj)
		{
			var map = (obj as Map<A,B>);
			Value[] values = new Value[map.size];
			int index = 0;
			var type = typeof(A);
			foreach(A key in map.keys)
			{
				Value typed_value = Value(type);
				if (type == typeof(string))
					typed_value.take_string((string)key);
				else if (type.is_object())
					typed_value.take_object((Object)key);
				else
					typed_value = key;

				values[index] = typed_value;
				index++;
			}
			return values;
		}
	}
}
