namespace YamlDB.Helpers
{
	public class RegexHelper
	{
		static RegexHelper _nonWordChars;
		public static RegexHelper NonWordCharacters
		{
			get 
			{
				if (_nonWordChars == null)
					_nonWordChars = new RegexHelper("""[^\w]+""");
				return _nonWordChars;
			}
		}
		static RegexHelper _nonAlphaNumeric;
		public static RegexHelper NonAlphaNumericCharacters
		{
			get
			{
				if (_nonAlphaNumeric == null)
					_nonAlphaNumeric = new RegexHelper("""^[0-9a-zA-Z_\-]+$""");
				return _nonAlphaNumeric;				
			}
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
