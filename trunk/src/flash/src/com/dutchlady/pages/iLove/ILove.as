package com.dutchlady.pages.iLove {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.components.heart.BigHeart;
	import com.dutchlady.http.HttpServiceEvent;
	import com.dutchlady.services.AppServices;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class ILove extends MovieClip {
		
		public var boardMovie: ILoveBoard;
		public var containerMovie: BigHeart;
		
		private var xml: XML;
		
		public function ILove() {
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(new URLRequest("xml/big_heart_service.xml"));
	
			/*var service: AppServices = new AppServices(Configuration.instance.getProfileServiceUrl);
			service.addEventListener(HttpServiceEvent.RESULT, getDataResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, getDataFaultHandler);
			service.getProfile();*/
			
			boardMovie.visible = false;
		}
		
		private function getDataFaultHandler(event: HttpServiceEvent): void {
			
		}
		
		private function getDataResultHandler(event: HttpServiceEvent): void {
			var data: XML = new XML(String(event.result));
			trace( "data : " + data );
			
		}
		
		private function xmlLoadCompleteHandler(event: Event): void {
			xml = XML(event.currentTarget.data);
			containerMovie.setData(xml);
		}
		
		private function ioErrorHandler(event: IOErrorEvent): void {
			
		}
		
	}

}