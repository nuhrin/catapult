using Gee;

namespace YamlDB.Helpers.IndirectGenerics.Gee
{
	public class IndirectList<A> : IndirectCollection<A>
	{
		public new global::Gee.List empty() { return global::Gee.List.empty<A>(); }

		public new Value get(global::Gee.List obj, int index)
		{
			A v = (obj as global::Gee.List<A>).get(index);
			return ValueHelper.populate_value<A>(v);
		}
		public new void set(global::Gee.List obj, int index, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			(obj as global::Gee.List<A>).set(index, v);
		}
		public int index_of(global::Gee.List obj, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			return (obj as global::Gee.List<A>).index_of(v);
		}
		public void insert(global::Gee.List obj, int index, Value value)
		{
			A v = ValueHelper.extract_value<A>(value);
			(obj as global::Gee.List<A>).insert(index, v);
		}
		public Value remove_at(global::Gee.List obj, int index)
		{
			A v = (obj as global::Gee.List<A>).remove_at(index);
			return ValueHelper.populate_value<A>(v);
		}
		public global::Gee.List<A>? slice(global::Gee.List obj, int start, int stop)
		{
			return obj.slice(start, stop);
		}
		public Value first(global::Gee.List obj)
		{
			A v = (obj as global::Gee.List<A>).first();
			return ValueHelper.populate_value<A>(v);
		}
		public Value last(global::Gee.List obj)
		{
			A v = (obj as global::Gee.List<A>).last();
			return ValueHelper.populate_value<A>(v);
		}
	}
}
