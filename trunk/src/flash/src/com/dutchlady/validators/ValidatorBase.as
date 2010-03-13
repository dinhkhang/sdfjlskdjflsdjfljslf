package com.dutchlady.validators {
	import com.dutchlady.validators.ValidationResult;
	/**
	 * The base class for validators
	 * @author Hai Nguyen
	 */
	public class ValidatorBase implements IValidator {
		private var _source: Object;
		private var _field: String;
		
		public function ValidatorBase(source: Object = null, field: String = "text") {
			_source = source;
			_field = field;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get source():Object{
			return _source;
		}
		
		public function set source(value:Object):void{
			_source = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get field():String{
			return _field;
		}
		
		public function set field(value:String):void{
			_field = value;
		}
		
		/**
		 * Check to see whether given value is not empty.
		 * @param	value The string needs to be validated.
		 * @return The Boolean value indicates whether given value is not empty.
		 */
		public function validate():ValidationResult {
			return new ValidationResult(true, null, "");
		}
	}
}