namespace Catapult.Helpers.IndirectGenerics
{
	public abstract class IndirectUni<A> : Object
	{
		public static IndirectUni create<T>(Type a_type)
		{
			Value a_type_value = Value(typeof(Type));
			a_type_value.set_gtype(a_type);

			Parameter[] params = new Parameter[1];
			params[0] = Parameter() { name = "a-type", value = a_type_value };
			return Object.newv(typeof(T), params) as IndirectUni;
		}
	}
}
