package com.dutchlady.utils {
	import br.com.stimuli.string.printf;
	/**
	 * <p>
	 * In Vng Flash Framework, the <code>StringUtil</code> class
	 * assumes responsibilities:
	 * <ul>
	 * <li>Supplying some string utilities.</li>
	 * </ul>
	 * </p>
	 * <p>
	 * @example
	 * <listing>
	 * 
	 * import com.vng.framework.utils.StringUtil;
	 * 
	 * var src: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
	 * trace(StringUtil.truncate(src, 100));// return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been..."
	 * </listing>
	 * </p>
	 * @author Hai Nguyen
	 */
	public class StringUtil {
		
		/**
        *   Very similiar to printf
        *   @param 		message	The string to be substituted.
        *   @param 		args	The objects to be substituted, can be positional or by properties inside the object (in which case only one object can be passed)
        *   @return 			The formatted and substituted string.
        *   @example
		*   <br />
        *   import com.vng.framework.utils.StringUtil;<br /><br />
        *   
		*   // objects are substituted in the order they appear<br />
        *   StringUtil.format("This is an %s library for creating %s", "Actioscript 3.0", "strings");<br />
        *   // outputs: "This is an Actioscript 3.0 library for creating strings";<br /><br />
        *   
		*   // you can also format numbers:<br />
        *   StringUtil.format("You can also display numbers like PI: %f, and format them to a fixed precision, such as PI with 3 decimal places %.3f", Math.PI, Math.PI);<br />
        *   // outputs: " You can also display numbers like PI: 3.141592653589793, and format them to a fixed precision, such as PI with 3 decimal places 3.142"<br /><br />
        *   
		*   // Instead of position (the order of arguments to printf, you can also use properties of an object):<br />
        *   var userInfo : Object = {"name": "Arthur Debert", "email": "arthur&#64;stimuli.com.br", "website":"http://www.stimuli.com.br/", "ocupation": "developer"};<br />
        *   StringUtil.format("My name is %(name)s and I am a %(ocupation)s. You can read more on my personal %(website)s, or reach me through my %(email)s", userInfo);<br />
        *   // outputs: "My name is Arthur Debert and I am a developer. You can read more on my personal http://www.stimuli.com.br/, or reach me through my arthur&#64;stimuli.com.br"<br /><br />
        *   
		*   // you can also use date parts:<br />
        *   var date : Date = new Date();<br />
        *   StringUtil.format("Today is %d/%m/%Y", date, date, date);
        */
		public static function format(message: String, ...args):String {
			args.unshift(message);
			return printf.apply(null, args);
		}
		
		/**
		 * Remove leading and trailing spaces
		 * @param	source	String needs to be removed leading and trailing spaces.
		 * @return
		 */
		public static function trim(source:String):String {
			if (!source) { 
				return ""; 
			}
			return source.replace(/^\s+|\s+$/g, '');
		}

		/**
		 * Remove leading spaces
		 * @param	source	String needs to be removed leading space.
		 * @return
		 */
		public static function trimLeft(source:String):String {
			if (!source) { 
				return ""; 
			}
			return source.replace(/^\s+/, '');
		}

		/**
		 * Remove trailing spaces
		 * @param	source	String needs to be removed trailing space.
		 * @return
		 */
		public static function trimRight(source:String):String {
			if (!source) { 
				return ""; 
			}
			return source.replace(/\s+$/, '');
		}
		
		/**
		 * Truncate source string and attach suffix after to form a new string fit in a specific length.
		 * @param	source		Original string.
		 * @param	length		The length storing enough some WORDS of source string and suffix.
		 * @param	suffix		The suffix added after truncating source string.
		 * @return
		 */
		public static function truncate(source:String, length:uint, suffix:String = "..."):String {
			if (source == null) { 
				return ""; 
			}
			length -= suffix.length;
			var trunc:String = source;
			if (trunc.length > length) {
				trunc = trunc.substr(0, length);
				if (/[^\s]/.test(source.charAt(length))) {
					trunc = trimRight(trunc.replace(/\w+$|\s+$/, ''));
				}
				trunc += suffix;
			}

			return trunc;
		}
		
		/**
		 * Change the first character of source string to uppercase.
		 * @param	s	Original string.
		 * @return
		 */
		public static function toProperCase(s: String): String {
			return s.replace(/(^| )[a-z]/mg, function (m: String, ... rest): String {
				return m.toUpperCase();
			});
		} 
		
		/**
		 * Replace all matched strings with a specific content.
		 * @param	src		Original string.
		 * @param	from	Pattern string needs to be replaced.
		 * @param	to		String is used to replace.
		 * @return
		 */
		public static function replace(src: String, from: String, to: String): String {
			var reg: RegExp = new RegExp(from, "g");
			return src.replace(reg, to);
		}
		
		/**
		 * Parse a text which has prefix and/or suffix
		 * @param	s		the input text
		 * @param	prefix	prefix
		 * @param	suffix	suffix
		 * @return	an object whose properties contain 3 parts of the text: mainText, prefix and suffix.<br/>
		 * If both prefix and suffix are not found, return null.
		 */
		public static function parseTextWithAffixes(s: String, prefix: String = null, suffix: String = null ): Object {
			var regStr: String = "(?P<mainText>.+)";
			if (prefix) regStr = "^(?P<prefix>\\s*" + prefix + ")" + regStr;
			if (suffix) regStr = regStr + "(?P<suffix>" + suffix + "\\s*)$";
			var reg: RegExp = new RegExp(regStr);
			var result: Object = reg.exec(s);
			return result;
		}
		
		/**
		 * Remove CR from a pair of new line maker CRLF to avoid double new line
		 * @param	src	String needs to be removed CR from a pair of new line maker CRLF to avoid double new line.
		 * @return
		 */
		public static function trimNewLine(src: String): String {
			var newStr: String = replace(src, "\r\n", "\n");
			return newStr;
		}
	}

}