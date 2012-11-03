/* RegexHelper.vala
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
 
namespace Catapult.Helpers
{
	public class RegexHelper
	{
		internal static unowned RegexHelper non_word_characters { 
			get { 
				if (_nonWordChars == null)
					_nonWordChars = new RegexHelper("""[^\w]+""");
				return _nonWordChars;
			}
		}				
		static RegexHelper _nonWordChars = null;

		internal static unowned RegexHelper non_filename_characters { 
			get { 
				if (_nonFilenameChars == null)
					_nonFilenameChars = new RegexHelper("""[^\w\.-]+""");
				return _nonFilenameChars;
			}
		}
		static RegexHelper _nonFilenameChars = null;


		internal static unowned RegexHelper non_alpha_numeric_characters { 
			get { 
				if (_nonAlphaNumericChars == null)
					_nonAlphaNumericChars = new RegexHelper("""^[0-9a-zA-Z_\-]+$""");
				return _nonAlphaNumericChars;
			}
		}
		static RegexHelper _nonAlphaNumericChars = null;

		Regex regex;
		public RegexHelper(string regex)
		{
			try {
				this.regex = new Regex(regex);
			} catch (RegexError e) {
				error(e.message);
			}
		}

		public bool match(string? str)
		{
			if (str == null)
				return false;
			return regex.match(str);
		}

		public string replace(string? str, string? replacement)
		{
			if (str == null || replacement == null)
				return str;
			try {
				return regex.replace(str, -1, 0, replacement);
			} catch (RegexError e) {
				return str;
			}
		}
	}
}
