package com.dutchlady.validators {
	import com.vng.framework.validators.ValidationResult;
	/**
	 * This class is used to validate date
	 * @author Hai Nguyen
	 */
	public class DateValidator extends ValidatorBase {
		public var invalidErrorMessage: String;
		
		public function DateValidator(source: Object = null, field: String = "text", invalidErrorMessage: String = "") {
			super(source, field);
			this.invalidErrorMessage = invalidErrorMessage;
		}
		
		override public function validate():ValidationResult {
			var date: String = source[field];
			
			if (!validateDate(date)) return new ValidationResult(false, source,invalidErrorMessage);
			
			return new ValidationResult(true, null,"");
		}
		
		/**
		 * Validate date
		 * @param	date The string date in format dd/mm/yyyy
		 * @return The Boolean value indicating whether the date is valid
		 */
		public static function validateDate(date: String): Boolean {//dd/mm/yyyy
			var pattern: RegExp = /^((((0?[1-9]|[12]\d|3[01])[\.\-\/](0?[13578]|1[02])[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|((0?[1-9]|[12]\d|30)[\.\-\/](0?[13456789]|1[012])[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|((0?[1-9]|1\d|2[0-8])[\.\-\/]0?2[\.\-\/]((1[6-9]|[2-9]\d)?\d{2}))|(29[\.\-\/]0?2[\.\-\/]((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)|00)))|(((0[1-9]|[12]\d|3[01])(0[13578]|1[02])((1[6-9]|[2-9]\d)?\d{2}))|((0[1-9]|[12]\d|30)(0[13456789]|1[012])((1[6-9]|[2-9]\d)?\d{2}))|((0[1-9]|1\d|2[0-8])02((1[6-9]|[2-9]\d)?\d{2}))|(2902((1[6-9]|[2-9]\d)?(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)|00))))$/;
			var result: Object = pattern.exec(date);
			if (result == null) {
				return false;
			}
			return true;
		}
	}

}