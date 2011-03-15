using Gee;

namespace YamlDB
{
	public class Enumerable<TSource> : Object, Iterable<TSource>
	{
		static HashMap<Type, Enumerable<TSource>> empties;
		public static Enumerable<TSource> empty<TSource>() {
			if (empties == null)
				empties = new HashMap<Type, Enumerable<TSource>>();
			if (empties.has_key(typeof(TSource)))
				return empties[typeof(TSource)];

			var empty = new Enumerable<TSource>(Collection.empty<TSource>());
			empties[typeof(TSource)] = empty;
			return empty;
		}
		public static Enumerable<TSource> yielding<TSource>(YieldEnumeratorPopulate<TSource> populate_delegate) {
			return new Enumerable<TSource>.from_iterator(new YieldEnumerator<TSource>(populate_delegate));
		}
		Type elementType;
		Iterable<TSource>? iterable;
		Iterator<TSource> iter;
		public Enumerable(Iterable<TSource> iterable) {
			this.iter = iterable.iterator();
			this.iterable = iterable;
			this.elementType = typeof(TSource);
		}
		
		public Enumerable.from_iterator(Iterator<TSource> iterator) {
			this.iter = iterator;
			this.elementType = typeof(TSource);
		}

		public Type element_type { get { return elementType; } }
		public Iterator<TSource> iterator() { return iter; }

		public Enumerable<TResult> select<TResult>(TFunc<TSource,TResult> selector) {
			return new Enumerable<TResult>.from_iterator(new SelectEnumerator<TSource,TResult>(iter, p=>true, selector));
		}
		public Enumerable<TSource> where(Predicate<TSource> predicate)
		{
			return new Enumerable<TSource>.from_iterator(new Enumerator<TSource>(iter, predicate));
		}
		public Enumerable<TSource> sort(CompareFunc<TSource> compare)
		{
			var list = this.to_list();
			list.sort((GLib.CompareFunc?)compare);
			return new Enumerable<TSource>(list);
		}

		public TSource first() {
			var list = iterable as Gee.List<TSource>;
			if (list != null)
				return (list.size > 0) ? list.first() : null;

			if (iter.first())
				return iter.get();
			return null;
		}
		public TSource first_where(Predicate<TSource> predicate) {
			return this.where(predicate).first();
		}
		public TSource last() {
			var list = iterable as Gee.List<TSource>;
			if (list != null)
				return (list.size > 0) ? list.last() : null;

			TSource last = null;
			foreach(var item in this)
				last = item;
			return last;
		}
		public TSource last_where(Predicate<TSource> predicate) {
			return this.where(predicate).last();
		}

		public int size() {
			Collection col = iterable as Collection;
			if (col != null)
				return col.size;
			if (iter.first() == false)
				return 0;
			int count = 1;
			while(iter.has_next()) {
				if (iter.next() == false)
					return count;
				else
					count++;
			}
			return count;
		}
		public int size_where(Predicate<TSource> predicate) {
			return this.where(predicate).size();
		}

		public Gee.List<TSource> to_list() {
			Gee.List<TSource> list;
			if (iterable != null) {
				list = iterable as Gee.List<TSource>;
				if (list != null)
					return list;
				var collection = iterable as Collection<TSource>;
				if (collection != null) {
					list = new ArrayList<TSource>();
					list.add_all(collection);
					return list;
				}
			}
			list = new ArrayList<TSource>();
			foreach(var item in this)
				list.add(item);
			return list;
		}
		public Collection<TSource> to_collection() {
			Collection<TSource> collection = iterable as Collection<TSource>;
			if (collection != null)
				return collection;
			collection = new ArrayList<TSource>();
			foreach(var e in this)
				collection.add(e);
			return collection;
		}
		public TSource[] to_array() {
			return this.to_collection().to_array();
		}

	}
}
