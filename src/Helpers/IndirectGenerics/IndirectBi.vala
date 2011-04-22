namespace YamlDB.Helpers.IndirectGenerics
{
	public abstract class IndirectBi<A,B> : Object
	{
		public static IndirectBi create<T>(Type a_type, Type b_type)
		{
			Value a_type_value = Value(typeof(Type));
			a_type_value.set_gtype(a_type);
			Value b_type_value = Value(typeof(Type));
			b_type_value.set_gtype(b_type);

			Parameter[] params = new Parameter[2];
			params[0] = Parameter() { name = "a-type", value = a_type_value };
			params[1] = Parameter() { name = "b-type", value = b_type_value };
			return Object.newv(typeof(T), params) as IndirectBi;
		}
	}
}
