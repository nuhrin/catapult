using Gee;

namespace YamlDB.Yaml
{
	public class OrderedMappingSet : HashMap<Node, Node>
	{
		public new void set(Node key, Node value) {
			if (this.has_key(key) == false)
				key.SortOrder = this.size;
			base.set(key, value);
		}

		public CompareFunc<ScalarNode>? ScalarKeyCompareFunc { get; set; }

		public Enumerable<Node> sorted_keys() {
			var list = new ArrayList<Node>();
			list.add_all(scalar_keys().to_list());
			list.add_all(sequence_keys().to_list());
			list.add_all(mapping_keys().to_list());
			return new Enumerable<Node>(list);
		}

		public Enumerable<ScalarNode> scalar_keys() {
			if (ScalarKeyCompareFunc != null) {
				return new Enumerable<Node>(this.keys)
					.where(p=>p.Type == NodeType.SCALAR)
					.select<ScalarNode>(p=>(ScalarNode)p)
					.sort(KeyAddedOrderComparison)
					.sort(ScalarKeyCompareFunc);
			}
			return new Enumerable<Node>(this.keys)
				.where(p=>p.Type == NodeType.SCALAR)
				.select<ScalarNode>(p=>(ScalarNode)p)
				.sort(KeyAddedOrderComparison);
		}
		public Enumerable<MappingNode> mapping_keys() {
			return new Enumerable<Node>(this.keys)
				.where(p=>p.Type == NodeType.MAPPING)
				.select<MappingNode>(p=>(MappingNode)p)
				.sort(KeyAddedOrderComparison);
		}
		public Enumerable<SequenceNode> sequence_keys() {
			return new Enumerable<Node>(this.keys)
				.where(p=>p.Type == NodeType.SEQUENCE)
				.select<SequenceNode>(p=>(SequenceNode)p)
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
