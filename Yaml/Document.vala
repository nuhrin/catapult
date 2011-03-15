
namespace YamlDB.Yaml
{
	public class Document : Object
	{
		public Document(Node root, bool isImplicit=true) {
			IsImplicit = isImplicit;
			Root = root;
		}
		internal Document.from_event(Node root, Events.DocumentStart event) {
			IsImplicit = event.IsImplicit;
			Root = root;
		}
		public bool IsImplicit { get; private set; }
		public Node Root { get; private set; }

		internal Events.DocumentStart get_start_event() {
			return new Events.DocumentStart(null, null, IsImplicit);
		}
		internal Events.DocumentEnd get_end_event() {
			return new Events.DocumentEnd(IsImplicit);
		}
		
		public static Document Empty {
			get {
				if (empty == null)
					empty = new EmptyDocument();
				return empty;
			}
		}
		static Document empty;
	}
	public class EmptyDocument : Document {
		internal EmptyDocument() {
			base(ScalarNode.Empty);
		}
	}
}