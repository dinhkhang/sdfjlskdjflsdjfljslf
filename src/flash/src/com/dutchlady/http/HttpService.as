package com.dutchlady.http {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * Dispatched when the service returns result
	 */
	[Event(name = "httpServiceResult", type = "com.vng.framework.http.HttpServiceEvent")]
	/**
	 * Dispatched when the service return certain error
	 */
	[Event(name = "httpServiceFault", type = "com.vng.framework.http.HttpServiceEvent")]
	/**
	 * Dispatched when remoting invoking is cancelled
	 */
	[Event(name = "httpServiceCancel", type = "com.vng.framework.http.HttpServiceEvent")]
	
	/**
	 * This is base class for all business services. You should create RemotingService subclasses for your business services such as UserServices, ForumServices, 
	 * rather than using directly RemotingService class.
	 * @includeExample RemotingServiceExample.as
	 * @see com.vng.framework.remoting.RemotingEvent RemotingEvent
	 * @author Hai Nguyen
	 */
	public class HttpService extends EventDispatcher {		
		private var urlLoader		: URLLoader;
		private var urlRequest		: URLRequest;
		
		/**
		 * The constructor of RemotingService class
		 * @param	serviceURL the url to service. Ex: http://domain.com/service.asmx
		 * @param   method indicates http request method is used.
		 */
		public function HttpService(serviceURL: String, method: String = "POST") {
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, serviceCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, serviceErrorHandler);

			urlRequest = new URLRequest(serviceURL);
			urlRequest.method = method;
		}
		
		/**
		 * Make a call to remote serivce with given parameters
		 * @param	method the name matched method's name in server-side service.
		 * @param	...args parameters passed to method.
		 */
		public function invokeService(params: Object = null):void {
			var variables: URLVariables = new URLVariables();
			if (params) {
				for (var prop: String in params) {
					variables[prop] = params[prop];
				}
			}
			variables.ran = new Date().getTime();
			
			urlRequest.data = variables;
			urlLoader.load(urlRequest);
		}
		
		private function serviceCompleteHandler(event: Event):void {
			var serviceEvent: HttpServiceEvent = new HttpServiceEvent(HttpServiceEvent.RESULT, true, true);
			
			serviceEvent.result = urlLoader.data;
			dispatchEvent(serviceEvent);
		}
		
		private function serviceErrorHandler(fault: IOErrorEvent):void {
			var serviceEvent: HttpServiceEvent = new HttpServiceEvent(HttpServiceEvent.FAULT, true, true);
			serviceEvent.error = fault.toString();
			dispatchEvent(serviceEvent);
		}
	}

}