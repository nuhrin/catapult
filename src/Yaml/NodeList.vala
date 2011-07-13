using Gee;

namespace Catapult.Yaml
{
	public class NodeList : ArrayList<Node>
	{
		public Enumerable<ScalarNode> scalars() {
			return new Enumerable<Node>(this)
				.where(p=>p.Type == NodeType.SCALAR)
				.select<ScalarNode>(p=>(ScalarNode)p);
		}
		public Enumerable<MappingNode> mappings() {
			return new Enumerable<Node>(this)
				.where(p=>p.Type == NodeType.MAPPING)
				.select<MappingNode>(p=>(MappingNode)p);
		}
		public Enumerable<SequenceNode> sequences() {
			return new Enumerable<Node>(this)
				.where(p=>p.Type == NodeType.SEQUENCE)
				.select<SequenceNode>(p=>(SequenceNode)p);
		}
	}
}
