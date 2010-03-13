package com.dutchlady.validators {
	/**
	 * The class is used to wrap result validation.
	 * @author Hai Nguyen
	 */
	public class ValidationResult {
		/**
		 * Indicates whether the validation is successful.
		 */
		public var success: Boolean;
		
		/**
		 * Indicates the source field which causes the error.
		 */
		public var errorSource: Object;
		
		/**
		 * Indicates the error message returned from the validation.
		 */
		public var errorMessage: String;
		
		/**
		 * The constructor
		 * @param	success Specifies whether the validation is successful.
		 * @param	errorMessage Specifies the error message returned from the validation.
		 */
		public function ValidationResult(success: Boolean, errorSource: Object, errorMessage: String) {
			this.success = success;
			this.errorSource = errorSource;
			this.errorMessage = errorMessage;
		}
	}

}