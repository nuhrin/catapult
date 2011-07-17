using Gee;

namespace Catapult.Helpers.IndirectGenerics.Gee
{
	public class IndirectCollection<A> : IndirectUni<A>
	{
		public static Type element_type(Collection obj)
		{
			Value prop_value = Value(typeof(Type));
			(obj as Object).get_property("element-type", ref prop_value);
			return prop_value.get_gtype();
		}

		public new Collection create(Type type) requires(type.is_a(typeof(Collection)))
		{
			if (type == typeof(ArrayList))
				return new ArrayList<A>();
			else if (type == typeof(LinkedList))
				return new LinkedList<A>();
			else if (type == typeof(PriorityQueue))
				return new PriorityQueue<A>();
			else if (type == typeof(HashSet))
				return new HashSet<A>();
			else if (type == typeof(TreeSet))
				return new TreeSet<A>();
			else if (type == typeof(HashMultiSet))
				return new HashMultiSet<A>();
			else if (type == typeof(TreeMultiSet))
				return new TreeMultiSet<A>();
			else if (type == typeof(AbstractList))
				return new ArrayList<A>();
			else if (type == typeof(AbstractQueue))
				return new PriorityQueue<A>();
			else if (type == typeof(AbstractSet))
				return new HashSet<A>();
			else if (type == typeof(AbstractMultiSet))
				return new HashMultiSet<A>();
			else if (type == typeof(AbstractCollection))
				return new ArrayList<A>();
			else if (type == typeof(global::Gee.List))
				return new ArrayList<A>();
			else if (type == typeof(Deque))
				return new LinkedList<A>();
			else if (type == typeof(global::Gee.Queue))
				return new PriorityQueue<A>();
			else if (type == typeof(SortedSet))
				return new TreeSet<A>();
			else if (type == typeof(Set))
				return new HashSet<A>();
			else if (type == typeof(MultiSet))
				return new HashMultiSet<A>();
			else if (type == typeof(Collection))
				return new ArrayList<A>();

			assert_not_reached();
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

		public Value[] get_values(Collection obj)
		{
			var collection = (obj as Collection<A>);
			Value[] values = new Value[collection.size];
			int index = 0;
			foreach(A value in collection) {
				values[index] = value;
				index++;
			}
			return values;
		}
	}
}
