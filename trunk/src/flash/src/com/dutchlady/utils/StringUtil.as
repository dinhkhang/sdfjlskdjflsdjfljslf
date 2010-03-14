package com.dutchlady.utils {
	import flash.text.TextField;
	
	/**
	* ...
	* @author quy.tran - pyramid-consulting
	*/
	public class StringUtil {
		
		public function StringUtil() {
			
		}
		
		public static function replace(orgString: String, find: String, replace: String): String {
			return orgString.split(find).join(replace);
		}
		
		public static function leftTrim(orgString: String): String {
			var s: String = orgString;
		
			while(s.length > 0 && s.charAt(0) == " ")
				s = s.substring(1);	
			return s;
		}
		
		public static function rightTrim(orgString: String): String {
			var s: String = orgString;
		
			while(s.length > 0 && s.charAt(s.length-1) == " ")
				s = s.substring(0, s.length - 1);	
				
			return s;		
		}
		
		public static function trim(orgString: String): String {
			var s: String = orgString;
			
			while (s.indexOf("  ") >= 0) {
				s = replace(s, "  ", " ");
			}
			s = leftTrim(s);
			s = rightTrim(s);
			
			return s;
		}
		
		public static function capitolize(s:String) :String {
			var firstLetter:String = s.substr(0, 1).toUpperCase();
			return (firstLetter + s.substr(1, s.length));
		}
		
		public static function titleCase(s:String, delimiter:String = " ") :String {
			var newStr:String = s;
			var arr:Array = s.split(delimiter);
			for (var i:int = 0; i < arr.length; i++) {
				if (arr[i] != "") {
					arr[i] = capitolize(arr[i]);
				}
			}
			newStr = arr.join(delimiter);
			return (newStr);
		}
		
		public static function dateFormat(src: String): String {
			var arr: Array = src.split("-");
			return digitFormat(arr[0]) + "-" + digitFormat(arr[1]) + "-" + arr[2];
		}
		
		public static function digitFormat(src: String): String {
			return (src.length < 2) ? ("0" + src) : src;
		}
		
		// autocut content in order to fit TextField
		public static function fixStringInTextField(tf: TextField, source: String, maxLine: int = 1): String {		
			var result: String = "";		
			var s1: String = source;
			var s2: String;
			var a1: Array;
			//var maxLine: Number = 1;
			var i: uint;
			a1 = s1.split(" ");
			s1 = ""; 
			s2 = "";

			if (tf.multiline) {
				////////trace(( "------------ multiline :" );
				tf.text = source;
				if (tf.maxScrollV > maxLine) {
					for (i = 0; i < a1.length; i++) {
						s1 += a1[i] + " ";
						if (i > 1) {
							s2 = s2 + a1[i - 1] + " ";
						} else {
							s2 = a1[0] + " ";
						}
						tf.text = s1 + "...";
						if (tf.maxScrollV > maxLine) {
							break;
						}

					}
					result = trim(s2) + "...";
				} else {
					if (tf.textWidth < tf.width) return source;
					for (i = 0; i < a1.length; i++) {
						s1 += a1[i] + " ";
						tf.text = s1 + "...";
						if (tf.maxScrollV > maxLine) {
							////////trace(( "------------ i :" + a1[i] );
							break;
						}
						if (i > 0) {
							s2 = s2 + a1[i] + " ";
						} else {
							s2 = a1[0] + " ";
						}
					}
					////////trace(("i " + i + " : " + (a1.length - 1));
					////////trace(("i " + i + " : " + a1[a1.length - 1]);
					result = trim(s2) + "...";
				}
			} else {
				////////trace(( "------------ single line :" );
				tf.text = source;			
				if (tf.textWidth < tf.width) return source;
				for (i = 0; i < a1.length; i++) {
					s1 += a1[i] + " ";
					tf.text = s1 + "...";
					if (tf.textWidth > tf.width) {
						break;
					}
					if (i > 0) {
						s2 = s2 + a1[i] + " ";
					} else {
						s2 = a1[0] + " ";
					}

				}
				result = trim(s2) + "...";
			}
			//tf.text;
			return result;
		}
	}
	
}