using Gee;

namespace YamlDB
{
	public class Enumerable<TSource> : Object, Iterable<TSource>
	{
		static HashMap<Type, Enumerable<TSource>> empties;
		public static Enumerable<TSource> Empty<TSource>() {
			if (empties == null)
				empties = new HashMap<Type, Enumerable<TSource>>();
			if (empties.has_key(typeof(TSource)))
				return empties[typeof(TSource)];

			var empty = new Enumerable<TSource>(Set.empty<TSource>());
			empties[typeof(TSource)] = empty;
			return empty;
		}

		Iterator<TSource> iter;
		public Enumerable(Iterable<TSource> iterable) {
			iter = iterable.iterator();
		}
		public Enumerable.from_iterator(Iterator<TSource> iterator) {
			iter = iterator;
		}

		public Type element_type { get { return typeof(TSource); } }
		public Iterator<TSource> iterator() { return iter; }

		public Enumerable<TResult> select<TResult>(TFunc<TSource,TResult> selector)
		{
			return new Enumerable<TResult>.from_iterator(
				new SelectEnumerator<TSource,TResult>(this.iter, p=>true, selector));
		}

		public Enumerable<TSource> where(Predicate<TSource> predicate) {
			return new Enumerable<TSource>.from_iterator(
				new Enumerator<TSource>(this.iter, predicate));
		}
	}
}
