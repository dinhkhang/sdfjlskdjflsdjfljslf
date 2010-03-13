package com.dutchlady.http {
	import flash.events.Event;
	
	/**
	 * A RemotingEvent object is dispatched into the event flow whenever remoting call's events occur.
	 * @see RemotingService
	 * @author Hai Nguyen
	 */
	public class HttpServiceEvent extends Event {
		/**
		 * Defines the value of the type property of a remotingResult event object.
		 */
		public static const RESULT: String = "httpServiceResult";
		
		/**
		 * Defines the value of the type property of a remotingFault event object.
		 */
		public static const FAULT: String = "httpServiceFault";
		
		/**
		 * Defines the value of the type property of a remotingCancel event object.
		 */
		public static const CANCEL: String = "httpServiceCancel";
		
		/**
		 * The returned data object.
		 * @example
		 * <listing>
		 * private function serviceResultHanlder(event: HttpServiceEvent):void {
		 *     Logger.info("serviceResultHanlder \n %s", event.result);
		 * }
		 * </listing>
		 */
		public var result: Object;
		
		/**
		 * The description of error
		 * @example
		 * <listing>
		 * private function serviceFaultHanlder(fault: HttpServiceEvent):void {
		 *     Logger.info("serviceFaultHanlder \n %s", fault.error);
		 * }
		 * </listing>
		 */
		public var error: String;
		
		public function HttpServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event {
			var object: HttpServiceEvent = new HttpServiceEvent(type, bubbles, cancelable);
			object.result = result;
			object.error = error;
			
			return object;
		} 
		
		public override function toString():String { 
			return formatToString("RemotingEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}