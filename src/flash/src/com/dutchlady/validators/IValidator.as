package com.dutchlady.validators {
	
	/**
	 * The interface for a validator.
	 * @author Hai Nguyen
	 */
	public interface IValidator {
		function get source():Object;
		function set source(value: Object):void;
		
		function get field():String;
		function set field(value: String):void;
		
		function validate():ValidationResult;
	}
	
}