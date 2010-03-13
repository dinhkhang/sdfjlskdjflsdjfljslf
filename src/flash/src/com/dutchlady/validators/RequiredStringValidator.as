package com.dutchlady.validators {
	import com.dutchlady.utils.StringUtil;
	/**
	 * This class is used to check to see whether a string value is not empty.
	 * @author Hai Nguyen
	 */
	public class RequiredStringValidator extends ValidatorBase {
		public var requiredErrorMessage: String = "";
		
		/**
		 * The constructor
		 */
		public function RequiredStringValidator(source: Object = null, field: String = "text", requiredErrorMessage: String = "") {
			super(source, field);
			this.requiredErrorMessage = requiredErrorMessage;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function validate(): ValidationResult {
			var result: Boolean = validateRequiredString(source[field]);
			
			if (result) return new ValidationResult(true, null,"");
			
			return new ValidationResult(false, source, requiredErrorMessage);
		}
		
		/**
		 * Check to see whether given value is not empty.
		 * @param	value The string needs to be validated.
		 * @return  The Boolean value indicates whether given value is not empty.
		 */
		public static function validateRequiredString(value: String):Boolean {
			return StringUtil.trim(value) != "";
		}
	}

}