
namespace Catapult
{
	// intended for 'using (new TimerBlock(...)) { ... }' syntax, though not sure that's supported...
	public class TimerBlock
	{
		GLib.Timer timer;
		string? message;
		public TimerBlock(string? done_message=null) {
			message = done_message;
			timer = new GLib.Timer();
		}
		~TimerBlock() {
			if (message != null)
				elapsed_print(message);
		}

		public void elapsed_print(string message) {
			double time = timer.elapsed();
			print("%s: %f seconds\n".printf(message, time * 100));
		}
	}
}
