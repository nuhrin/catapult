/* PredicateChain.vala
 * 
 * Copyright (C) 2015 nuhrin
 * 
 * This file is part of Pandafe.
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
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
	public class PredicateChain<G>
	{
		public static PredicateChain<G> for<G>(G item) { return new PredicateChain<G>(item); }
			
		G item;
		PredicateChain<G> other_and;
		PredicateChain<G> other_or;
		
		PredicateChain(G item) {
			this.item = item;
		}
		
		public unowned PredicateChain<G> and(G item) {
			return and_other(new PredicateChain<G>(item));
		}
		public unowned PredicateChain<G> and_other(PredicateChain<G> other) {
			if (other_and == null)
				other_and = other;
			else
				other_and.and_other(other);
			return this;
		}
		public PredicateChain<G> or(G item) {
			var newp = new PredicateChain<G>(item);
			newp.other_or = this;
			return newp;
		}	
		
		public bool evaluate(owned Predicate<G> test) {
			if (other_or != null) {
				if (other_or.evaluate((owned)test) == true)
					return true;
			}
			if (test(item) == false)
				return false;
			return (other_and == null || other_and.evaluate((owned)test));
		}			
	}
}
