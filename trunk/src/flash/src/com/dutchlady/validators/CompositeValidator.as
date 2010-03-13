package com.dutchlady.validators {
	/**
	 * This class is used to do validation of list of validators
	 * @includeExample CompositeValidatorExample.as
	 * @see ValidationResult
	 * @author Hai Nguyen
	 */
	public class CompositeValidator {
		private var validatorsList: Array = [];
		
		public function CompositeValidator() {
			
		}
		
		/**
		 * Add a validator to validation list
		 * @param	validator The instance of class which implements <code>IValidator</code>
		 * @see IValidator
		 */
		public function addValidator(validator: IValidator):void {
			validatorsList.push(validator);
		}
		
		/**
		 * Executes validators queue
		 * @return Array of ValidationResult having error(s)
		 */
		public function validateAll(): Array  {
			var length: int = validatorsList.length;
			var validator: IValidator;
			var errorsList: Array = [];
			var result: ValidationResult;
			
			for (var i: int = 0; i < length; i++) {
				validator = validatorsList[i];
				result = validator.validate();
				if (!result.success) errorsList.push(result);
			}
			
			return errorsList;
		}
	}

}