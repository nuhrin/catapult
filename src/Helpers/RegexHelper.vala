namespace Catapult.Helpers
{
	public class RegexHelper
	{
		public static unowned RegexHelper NonWordCharacters { get { return get_regex(ref _nonWordChars, """[^\w]+"""); } }
		static RegexHelper _nonWordChars = null;

		public static unowned RegexHelper NonAlphaNumericCharacters { get { return get_regex(ref _nonAlphaNumericChars, """^[0-9a-zA-Z_\-]+$"""); } }
		static RegexHelper _nonAlphaNumericChars = null;

		static unowned RegexHelper get_regex(ref RegexHelper value, string regex)
		{
			if (value == null)
				value = new RegexHelper(regex);
			return value;
		}


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
