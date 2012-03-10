namespace Catapult.Helpers
{
	public class RegexHelper
	{
		public static unowned RegexHelper non_word_characters { 
			get { 
				if (_nonWordChars == null)
					_nonWordChars = new RegexHelper("""[^\w]+""");
				return _nonWordChars;
			}
		}				
		static RegexHelper _nonWordChars = null;

		public static unowned RegexHelper non_filename_characters { 
			get { 
				if (_nonFilenameChars == null)
					_nonFilenameChars = new RegexHelper("""[^\w\.-]+""");
				return _nonFilenameChars;
			}
		}
		static RegexHelper _nonFilenameChars = null;


		public static unowned RegexHelper non_alpha_numeric_characters { 
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
