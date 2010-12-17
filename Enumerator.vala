using Gee;

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
		Predicate<TSource> is_match;
		TFunc<TSource,TResult> select_result;

		public SelectEnumerator(Iterator<TSource> iterator,
			Predicate<TSource> is_match,
			TFunc<TSource,TResult> select_result)
		{
			i = iterator;
			this.is_match = is_match;
			this.select_result = select_result;
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

		public new TResult get() {
			return select_result(i.get());
		}

		public void remove() {
			i.remove();
			while (!is_match(i.get()))
				i.remove();
		}
	}
}
