using Gee;
//using YamlDB.Helpers.IndirectGenerics;

namespace YamlDB.Helpers.IndirectGenerics.Gee
{
	public class IndirectMap<A,B> : IndirectBi<A,B>
	{
		public void set_value(Map obj, Value key, Value value)
		{
			A k = ValueHelper.extract_value<A>(key);
			B v = ValueHelper.extract_value<B>(value);
			(obj as Map<A,B>).set(k, v);
		}
		public Value? get_value(Map obj, Value key)
		{
			A k = ValueHelper.extract_value<A>(key);
			return (obj as Map<A,B>).get(k);
		}
	}
}