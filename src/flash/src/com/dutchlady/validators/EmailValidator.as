package com.dutchlady.validators {
	import com.dutchlady.validators.ValidationResult;
	/**
	 * This class is used to check email valid
	 * @author Hai Nguyen
	 */
	public class EmailValidator extends ValidatorBase {
		public var validateOnlyNotEmpty: Boolean;
		public var requiredErrorMessage: String;
		public var invalidErrorMessage: String;
		
		public function EmailValidator(source: Object = null, field: String = "text", 
										requiredErrorMessage: String = "", invalidErrorMessage: String = "", validateOnlyNotEmpty: Boolean = false) {
			super(source, field);
			this.validateOnlyNotEmpty = validateOnlyNotEmpty;
			this.requiredErrorMessage = requiredErrorMessage;
			this.invalidErrorMessage = invalidErrorMessage;
		}
		
		override public function validate(): ValidationResult {
			var result: ValidationResult;
			var email: String = source[field];
			
			if (!RequiredStringValidator.validateRequiredString(email)) {
				if (!validateOnlyNotEmpty) return new ValidationResult(false, source, requiredErrorMessage);
				else return new ValidationResult(true, null, "");
			}
			if (!validateEmail(email)) return new ValidationResult(false, source,invalidErrorMessage);
			
			return new ValidationResult(true, null,"");
		}
		
		public static function validateEmail(email: String): Boolean {
			//var pattern: RegExp = /([0-9a-zA-Z]+[-._])*[0-9a-zA-Z]+[_]?@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/;
			var nameID: String = email.split("@")[0];
			if (nameID.split(".").length > 2) {
				return false;
			}
			//var pattern: RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
			//var pattern: RegExp = /^[A-Za-z]+[A-Z0-9.!#$%*\/?|^{}`~&‘+-=_]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
			//var pattern: RegExp =/^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$/i;
			var pattern: RegExp =/^[A-Za-z0-9](([_\.\-]?[a-zA-Z0-9]+_?)*)@([A-Za-z0-9]+)(([\.\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})$/i;
			var result: Object = pattern.exec(email);
			if (result == null) {
				return false;
			}
			return true;
		}
	}

}