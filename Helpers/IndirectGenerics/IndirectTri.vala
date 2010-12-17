namespace YamlDB.Helpers.IndirectGenerics
{
	public abstract class IndirectTri<A,B,C> : Object
	{
		public static IndirectTri create<T>(Type a_type, Type b_type, Type c_type)
		{
			Value a_type_value = Value(typeof(Type));
			a_type_value.set_gtype(a_type);
			Value b_type_value = Value(typeof(Type));
			b_type_value.set_gtype(c_type);
			Value c_type_value = Value(typeof(Type));
			c_type_value.set_gtype(c_type);

			Parameter[] params = new Parameter[3];
			params[0] = Parameter() { name = "a-type", value = a_type_value };
			params[1] = Parameter() { name = "b-type", value = b_type_value };
			params[1] = Parameter() { name = "c-type", value = c_type_value };
			return Object.newv(typeof(T), params) as IndirectTri;
		}
	}
}
