/* Document.vala
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
 
namespace Catapult.Yaml
{
	public class Document
	{
		public Document(Node root, bool implicit=true) {
			is_implicit = implicit;
			this.root = root;
		}
		internal Document.from_event(Node root, DocumentStart event) {
			is_implicit = event.is_implicit;
			this.root = root;
		}
		public bool is_implicit { get; private set; }
		public Node root { get; private set; }

		internal DocumentStart get_start_event() {
			return new DocumentStart(null, null, is_implicit);
		}
		internal DocumentEnd get_end_event() {
			return new DocumentEnd(is_implicit);
		}

		internal static Document empty {
			get {
				if (_empty == null)
					_empty = new EmptyDocument();
				return _empty;
			}
		}
		static Document _empty;
	}
	internal class EmptyDocument : Document {
		internal EmptyDocument() {
			base(ScalarNode.empty);
		}
	}
}
