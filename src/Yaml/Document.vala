
namespace Catapult.Yaml
{
	public class Document : Object
	{
		public Document(Node root, bool implicit=true) {
			is_implicit = implicit;
			this.root = root;
		}
		internal Document.from_event(Node root, Events.DocumentStart event) {
			is_implicit = event.is_implicit;
			this.root = root;
		}
		public bool is_implicit { get; private set; }
		public Node root { get; private set; }

		internal Events.DocumentStart get_start_event() {
			return new Events.DocumentStart(null, null, is_implicit);
		}
		internal Events.DocumentEnd get_end_event() {
			return new Events.DocumentEnd(is_implicit);
		}

		public static Document empty {
			get {
				if (_empty == null)
					_empty = new EmptyDocument();
				return _empty;
			}
		}
		static Document _empty;
	}
	public class EmptyDocument : Document {
		internal EmptyDocument() {
			base(ScalarNode.empty);
		}
	}
}
