/* TimerBlock.vala
 * 
 * Copyright (C) 2012 nuhrin
 * 
 * This file is part of catapult.
 * 
 * This library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this library.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Author:
 *      nuhrin <nuhrin@oceanic.to>
 */
 

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
			print("%s: %f seconds\n".printf(message, time));
		}
	}
}
