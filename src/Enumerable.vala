/* Enumerable.vala
 * 
 * Copyright (C) 2012 nuhrin
 * 
 * This file is part of catapult.
 * 
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */
 
using Gee;

namespace Catapult
{
	public class Enumerable<G> : Object, Traversable<G>, Iterable<G>
	{
		static HashMap<Type, Enumerable<G>> empties;
		public static Enumerable<G> empty<G>() {
			if (empties == null)
				empties = new HashMap<Type, Enumerable<G>>();
			if (empties.has_key(typeof(G)))
				return empties[typeof(G)];

			var empty = new Enumerable<G>(Collection.empty<G>());
			empties[typeof(G)] = empty;
			return empty;
		}
		
		public static Enumerable<G> unfold<G>(owned UnfoldFunc<G> unfold_func) {
			return new Enumerable<G>(new UnfoldingIterable<G>((owned)unfold_func));
		}

		internal Iterable<G>? iterable;
		public Enumerable(Iterable<G> iterable) {
			this.iterable = iterable;
		}

		// Iterable<G> implementation
		public virtual Iterator<G> iterator() { return iterable.iterator(); }

		// Traversable<G> implementation
		public bool foreach(ForallFunc<G> f) { return iterator().foreach(f); }
		
		public Enumerable<G> where(owned Predicate<G> predicate) { return (Enumerable<G>)new EnumerableWhere<G>(this, (owned)predicate); }
		public Enumerable<A> select<A>(owned MapFunc<A,G> selector) { return (Enumerable<G>)new EnumerableSelect<A,G>(this, (owned)selector); }
		public Enumerable<G> concat(Iterable<G> other) { return (Enumerable<G>)new EnumerableConcat<G>(this, other); }

		public Enumerable<A> of_type<A>() {
			Type resultType = typeof(A);
			if (element_type.is_classed() == true) {
				if (element_type.is_a(resultType) == true)
					return this;
				if (resultType.is_a(element_type) == false)
					return Enumerable.empty<A>();
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
		bool item_is_a(G item, Type type) {
			return Value.type_compatible(Type.from_instance(ValueHelper.populate_value<G>(item).peek_pointer()), type);
		}

		public G? first() {
			var iter = iterator();
			if (iter.valid == false) {
				if (iter.next() == false)
					return null;
			}
			return iter.get();
		}
		public G first_or_default(G default) {
			return first() ?? default;
		}
		public G? last() {
			var iter = iterator();

			if (iter.valid == false) {
				if (iter.next() == false)
					return null;
			}

			while (iter.has_next())
				iter.next();
			return iter.get();
		}
		public G last_or_default(G default) {
			return last() ?? default;
		}

		public bool any() {
			var iter = iterator();
			if (iter.valid == true)
				return true;
			return iter.has_next();
		}

		public int size() {
			Collection col = iterable as Collection;
			if (col != null)
				return col.size;
			var iter = iterator();
			int count = 0;
			while(iter.next())
				count++;
			
			return count;
		}

		public Enumerable<G> sort(owned CompareDataFunc<G>? compare=null)
		{
			var list = new ArrayList<G>();
			foreach(var item in this)
				list.add(item);
			list.sort((GLib.CompareDataFunc?)(owned)compare);
			return new Enumerable<G>(list);
		}

		public Gee.List<G> to_list() {
			Gee.List<G> list;
			if (iterable != null) {
				list = iterable as Gee.List<G>;
				if (list != null)
					return list;
				var collection = iterable as Collection<G>;
				if (collection != null) {
					list = new ArrayList<G>();
					list.add_all(collection);
					return list;
				}
			}
			list = new ArrayList<G>();
			foreach(var item in this)
				list.add(item);
			return list;
		}
		public Collection<G> to_collection() {
			Collection<G> collection = iterable as Collection<G>;
			if (collection != null)
				return collection;
			collection = new ArrayList<G>();
			foreach(var e in this)
				collection.add(e);
			return collection;
		}
		public G[] to_array() {
			return this.to_collection().to_array();
		}
//		public Enumerable<Value?> to_values() {
//			if (element_type == typeof(Value))
//				return this;
//			var list = new ArrayList<Value?>();
//			foreach(Value item in this) {
//				Value newV = Value(typeof(G));
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
		//Value get_value(Value v) { debug(return (G)v.peek_pointer(); }
		//Value get_real_value(Value v) { return v; }
	}

	class EnumerableWhere<G> : Enumerable<G>
	{
		public EnumerableWhere(Iterable<G> iterable, owned Predicate<G> predicate) {
			base(iterable);
			this.predicate = (owned)predicate;
		}
		Predicate<G> predicate;
		public override Iterator<G> iterator() { return this.iterable.filter((owned)predicate); }
	}
	class EnumerableSelect<A,G> : Enumerable<A>
	{
		public EnumerableSelect(Iterable<G> iterable, owned MapFunc<A,G> selector) {
			base(iterable);
			this.selector = (owned)selector;
		}
		MapFunc<A,G> selector;
		public override Iterator<A> iterator() { return iterable.map<A>(selector); }
	}
	class EnumerableStream<G,A> : Enumerable<A>
	{
		public EnumerableStream(Iterable<G> iterable, owned StreamFunc<G,A> streamer) {
			base(iterable);
			this.streamer = (owned)streamer;
		}
		StreamFunc<G,A> streamer;
		public override Iterator<A> iterator() { return iterable.stream<A>((owned)streamer); }
	}
	class EnumerableConcat<G> : Enumerable<G>
	{
		public EnumerableConcat(Iterable<G> iterable, Iterable<G> other_iterable) {
			base(iterable);
			this.other_iterable = other_iterable;
		}
		Iterable<G> other_iterable;
		public override Iterator<G> iterator() {
			int count = -1;
			return Iterator.concat<G>(Iterator.unfold<Iterator<G>>(() => {
				count++;
				if (count == 0)
					return new Lazy<Iterator<G>>(() => this.iterable.iterator());
				else if (count == 1)
					return new Lazy<Iterator<G>>(() => this.other_iterable.iterator());
				else
					return null;
			}));
		}
	}
	class UnfoldingIterable<G> : Object, Traversable<G>, Iterable<G>
	{
		UnfoldFunc<G> unfold_func;
		public UnfoldingIterable(owned UnfoldFunc<G> unfold_func) {
			this.unfold_func = (owned)unfold_func;
		}

		// Iterable<G> implementation
		public Iterator<G> iterator() { return Iterator.unfold<G>((owned)unfold_func); }
		
		// Traversable<G> implementation
		public bool foreach(ForallFunc<G> f) { return iterator().foreach(f); }
	}
}
