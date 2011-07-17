using Gee;

namespace Catapult
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
//		public static Enumerable<TSource> yielding<TSource>(YieldEnumeratorPopulate<TSource> populate_delegate) {
//			return new Enumerable<TSource>.from_iterator(new YieldEnumerator<TSource>(populate_delegate));
//		}
		Type elementType;
		Iterable<TSource>? iterable;
		public Enumerable(Iterable<TSource> iterable) {
			this.iterable = iterable;
			this.elementType = typeof(TSource);
		}

		public Type element_type { get { return elementType; } }
		public virtual Iterator<TSource> iterator() { return iterable.iterator(); }

		public Enumerable<TSource> where(Predicate<TSource> predicate) { return new EnumerableWhere<TSource>(this, predicate); }
		public Enumerable<TResult> select<TResult>(TFunc<TSource,TResult> selector) { return new EnumerableSelect<TSource,TResult>(this, selector); }
		public Enumerable<TSource> concat(Iterable<TSource> other) { return new EnumerableConcat<TSource>(this, other); }

		public Enumerable<TResult> of_type<TResult>() {
			Type resultType = typeof(TResult);
			if (element_type.is_classed() == true) {
				if (element_type.is_a(resultType) == true)
					return this;
				if (resultType.is_a(element_type) == false)
					return Enumerable.empty<TResult>();
				if (element_type.is_object() == true)
					return this.where(p=>((Object)p).get_type().is_a(resultType));
				return this.where(p=>item_is_a(p, resultType));
			}
			else if (element_type == typeof(Value))
				return this.where(p=>((Value?)p).type().is_a(resultType));

			if (Value.type_compatible(element_type, resultType))
				return this;

			return this.where(p=>item_is_a(p, resultType));
		}
		static bool item_is_a(Value item, Type type) {
			return Value.type_compatible(Type.from_instance(item.peek_pointer()), type);
		}

		public TSource first() {
			var list = iterable as Gee.List<TSource>;
			if (list != null)
				return (list.size > 0) ? list.first() : null;
			var iter = iterator();
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
			var iter = iterator();
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

		public Enumerable<TSource> sort(CompareFunc<TSource> compare)
		{
			var list = new ArrayList<TSource>();
			foreach(var item in this)
				list.add(item);
			list.sort((GLib.CompareFunc?)compare);
			return new Enumerable<TSource>(list);
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
//		public Enumerable<Value?> to_values() {
//			if (element_type == typeof(Value))
//				return this;
//			var list = new ArrayList<Value?>();
//			foreach(Value item in this) {
//				Value newV = Value(typeof(TSource));
//				newV.set_instance(item.peek_pointer());
//				//Value newV = *item.peek_pointer();
//				list.add(newV);
////				Type type = Type.from_instance(ptr);
////				debug("  type from instance: %s", type.name());
////				Value newV = Value(type);
////				newV.set_instance(ptr);
////				list.add(newV);
//			}
//			return new Enumerable<Value?>(list);
//		}
		//Value get_value(Value v) { debug(return (TSource)v.peek_pointer(); }
		//Value get_real_value(Value v) { return v; }
	}

	public class EnumerableWhere<TSource> : Enumerable<TSource>
	{
		internal EnumerableWhere(Iterable<TSource> iterable, Predicate<TSource> predicate) {
			base(iterable);
			this.predicate = predicate;
		}
		Predicate<TSource> predicate;
		public override Iterator<TSource> iterator() { return new Enumerator<TSource>(base.iterator(), predicate); }
	}
	public class EnumerableSelect<TSource,TResult> : Enumerable<TSource>
	{
		internal EnumerableSelect(Iterable<TSource> iterable, TFunc<TSource,TResult> selector) {
			base(iterable);
			this.selector = selector;
		}
		TFunc<TSource,TResult> selector;
		public override Iterator<TSource> iterator() { return new SelectEnumerator<TSource,TResult>(base.iterator(), selector); }
	}
	public class EnumerableConcat<TSource> : Enumerable<TSource>
	{
		internal EnumerableConcat(Iterable<TSource> iterable, Iterable<TSource> other_iterable) {
			base(iterable);
			this.other_iterable = other_iterable;
		}
		Iterable<TSource> other_iterable;
		public override Iterator<TSource> iterator() { return new ConcatEnumerator<TSource>(base.iterator(), other_iterable.iterator()); }
	}
}
