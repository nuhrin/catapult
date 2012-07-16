/* EventEmitter.vala
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
 
using YAML;

namespace Catapult.Yaml.Events
{
	public class EventEmitter
	{
		Emitter emitter;
		unowned StringBuilder sb;

		public EventEmitter(FileStream output)
		{
			emitter = Emitter();
			emitter.set_output_file(output);
		}
		public EventEmitter.to_string_builder(StringBuilder sb)
		{
			this.sb = sb;
			emitter = Emitter();
			emitter.set_output(emit_to_string_builder_handler);
		}
		~EventEmitter()
		{
			emitter.flush();
			sb = null;
		}

		public void emit(Event event) throws YamlError
		{
			RawEvent raw_event = event.create_raw_event();
			if (!emitter.emit(ref raw_event))
			{
				throw new YamlError.EMIT("EventEmitter error: %s", emitter.problem);
			}
			RawEvent.clean(ref raw_event);
		}

		public void flush() throws YamlError
		{
			if (!emitter.flush())
			{
				throw new YamlError.EMIT("EventEmitter error: %s", emitter.problem);
			}
		}

		public void set_encoding(EncodingType encoding)
		{
			emitter.set_encoding((YAML.EncodingType)encoding);
		}
		public void set_canonical(bool canonical)
		{
			emitter.set_canonical(canonical);
		}
		public void set_indent(int indent)
		{
			emitter.set_indent(indent);
		}
		public void set_width(int width)
		{
			emitter.set_width(width);
		}
		public void set_unicode(bool unicode)
		{
			emitter.set_unicode(unicode);
		}
		public void set_break(BreakType @break)
		{
			emitter.set_break((YAML.BreakType)@break);
		}

		private int emit_to_string_builder_handler(uchar *buffer, size_t length) {
			sb.append_len((string)buffer, (ssize_t)length);
			return 1;
		}
	}
}
