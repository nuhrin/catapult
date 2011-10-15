using Gee;

namespace Catapult.Yaml
{
	public class OrderedMappingSet : HashMap<Node, Node>
	{
		public new void set(Node key, Node value) {
			if (this.has_key(key) == false)
				key.SortOrder = this.size;
			base.set(key, value);
		}

		public void set_scalar(string key, Node value) {
			set(new ScalarNode(null, null, key), value);
		}

		public CompareDataFunc<ScalarNode>? ScalarKeyCompareFunc { get; owned set; }

		public Enumerable<Node> sorted_keys() {
			return scalar_keys().concat(sequence_keys()).concat(mapping_keys());
		}

		public Enumerable<ScalarNode> scalar_keys() {
			if (ScalarKeyCompareFunc != null) {
				return new Enumerable<Node>(this.keys)
					.of_type<ScalarNode>()
					.sort(KeyAddedOrderComparison)
					.sort((owned)ScalarKeyCompareFunc);
			}
			return new Enumerable<Node>(this.keys)
				.of_type<ScalarNode>()
				.sort(KeyAddedOrderComparison);
		}
		public Enumerable<MappingNode> mapping_keys() {
			return new Enumerable<Node>(this.keys)
				.of_type<MappingNode>()
				.sort(KeyAddedOrderComparison);
		}
		public Enumerable<SequenceNode> sequence_keys() {
			return new Enumerable<Node>(this.keys)
				.of_type<SequenceNode>()
				.sort(KeyAddedOrderComparison);
		}

		int KeyAddedOrderComparison(Node a, Node b) {
			if (a.SortOrder == b.SortOrder)
				return 0;
			if (a.SortOrder < b.SortOrder)
				return -1;
			return 1;
		}
	}
}
