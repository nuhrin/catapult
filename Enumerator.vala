using Gee;
using YamlDB.Helpers;

namespace YamlDB
{
	public class Enumerator<T> : Object, Iterator<T>
	{
		Iterator<T> i;
		Predicate<T> is_match;

		public Enumerator(Iterator<T> iterator, Predicate<T> is_match)
		{
			i = iterator;
			this.is_match = is_match;
		}

		public bool next() {
			bool retVal = (i.has_next() && i.next());
			while (retVal == true && !is_match(i.get()))
				retVal = (i.has_next() && i.next());
			return retVal;
		}

		public bool has_next() {
			return i.has_next();
		}
		public bool first()
		{
			bool retVal = i.first();
			while (retVal == true && !is_match(i.get()))
				retVal = (i.has_next() && i.next());
			return retVal;
		}

		public new T get() {
			return i.get();
		}

		public void remove() {
			i.remove();
			while (!is_match(i.get()))
				i.remove();
		}
	}

	public class SelectEnumerator<TSource,TResult> : Object, Iterator<TResult>
	{
		Iterator<TSource> i;
		TFunc<TSource,TResult> select_result;

		public SelectEnumerator(Iterator<TSource> iterator, TFunc<TSource,TResult> select_result)
		{
			i = iterator;
			this.select_result = select_result;
		}

		public bool next() { return i.next(); }
		public bool has_next() { return i.has_next(); }
		public bool first() { return i.first(); }
		public new TResult get() { return select_result(i.get()); }
		public void remove() { i.remove(); }
	}

	public class ConcatEnumerator<T> : Object, Iterator<T>
	{
		Iterator<T> iterator_a;
		Iterator<T> iterator_b;
		bool on_b;

		public ConcatEnumerator(Iterator<T> iterator_a, Iterator<T> iterator_b)
		{
			this.iterator_a = iterator_a;
			this.iterator_b = iterator_b;
			on_b = false;
		}

		public bool next() {
			if (on_b == true)
				return iterator_b.next();

			bool retVal = iterator_a.next();
			if (retVal == false) {
				on_b = true;
				retVal = iterator_b.next();
			}
			return retVal;
		}

		public bool has_next() {
			if (on_b == true)
				return iterator_b.has_next();
			return iterator_a.has_next() || iterator_b.has_next();
		}
		public bool first()
		{
			bool retVal = iterator_a.first();
			if (retVal == false) {
				on_b = true;
				retVal = iterator_b.first();
			}
			return retVal;
		}

		public new T get() {
			return (on_b == false)
				? iterator_a.get()
				: iterator_b.get();
		}

		public void remove() {
			if (on_b == false)
				iterator_a.remove();
			else
				iterator_b.remove();
		}
	}

	public delegate void YieldEnumeratorPopulate<T>(YieldEnumerator.Populator<T> populator);
	public class YieldEnumerator<T> : Object, Iterator<T>
	{
		YieldEnumeratorPopulate<T> populate;
		bool population_started;
		bool population_finished;
		T current;

		public YieldEnumerator(YieldEnumeratorPopulate<T> populate_delegate) {
			populate = populate_delegate;
		}

		public bool next() {
			assert_not_reached();
		}

		public bool has_next() {
			assert_not_reached();
		}
		public bool first()
		{
			assert_not_reached();
		}

		public new T get() {
			assert_not_reached();
		}

		public void remove() {
			assert_not_reached();
		}

		public class Populator<T>
		{
			YieldEnumerator<T> e;
			internal Populator(YieldEnumerator<T> enumerator) {
				e = enumerator;
			}
	
			public signal void item_yielded(T item);

			public void yield_item(T item) {
				item_yielded(item);
			}
			public void yield_value(Value value) {
				T v = ValueHelper.extract_value(value);
				yield_item(v);
			}
		}
	}
}
