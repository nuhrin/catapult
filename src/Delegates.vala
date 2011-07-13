namespace Catapult
{
	public delegate void Action<T>(T arg);

	public delegate T GetFunc<T>();
	public delegate TResult TFunc<T,TResult>(T arg);
	public delegate TResult TFunc2<T1,T2,TResult>(T1 arg1, T2 arg2);
	public delegate TResult TFunc3<T1,T2,T3,TResult>(T1 arg1, T2 arg2, T3 arg3);
	public delegate TResult TFunc4<T1,T2,T3,T4,TResult>(T1 arg1, T2 arg2, T3 arg3, T4 arg4);

	public delegate bool Predicate<T>(T arg);

	public delegate int CompareFunc<T>(T a, T b);
}
