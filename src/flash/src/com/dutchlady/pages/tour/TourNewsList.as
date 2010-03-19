package com.dutchlady.pages.tour {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.http.HttpServiceEvent;
	import com.dutchlady.services.AppServices;
	import fl.video.FLVPlayback;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class TourNewsList extends Sprite {
		
		public var playButton: SimpleButton;
		public var flvPlayback: FLVPlayback;
		
		public function TourNewsList() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			var service: AppServices = new AppServices(Configuration.instance.getTourNewsServiceUrl);
			//var service: AppServices = new AppServices("http://demo.intelligent-content.net/flashapi/FlashServices.asmx/GetContents");
			service.addEventListener(HttpServiceEvent.RESULT, getDataResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, getDataFaultHandler);
			service.getTourNews();
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
		}
		
		private function removedFromStageHandler(event: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			flvPlayback.stop();
		}
		
		private function getDataResultHandler(event: HttpServiceEvent): void {
			var data: XML = new XML(String(event.result));
			var item: TourNewsItem;
			var posY: Number;
			
			var ns: Namespace = data.namespace();
			var newsList: XMLList = data.ns::Content;
			var contentXml: XML;
			
			posY = 0;
			for (var i: int = 0; i < newsList.length(); i++) {
				contentXml = newsList[i];
				item = new TourNewsItem();
				addChild(item);
				item.title = contentXml.ns::Title;
				item.body = contentXml.ns::Body;
				item.update(contentXml.ns::Id, contentXml.ns::PhotoUrl, contentXml.ns::Title, contentXml.ns::Description);
				item.y = posY;
				posY += item.height + 10;
			}
			
			//playButton.alpha = 0;
			playButton.addEventListener(MouseEvent.CLICK, playClickHandler);
		}

		private function playClickHandler(event: MouseEvent): void {
			if (playButton.alpha == 1)	flvPlayback.play();
			else flvPlayback.stop();
			if(playButton.alpha == 1)	playButton.alpha = 0;
			else	playButton.alpha = 1;
		}
		
		private function getDataFaultHandler(event: HttpServiceEvent): void {
			trace("getDataFaultHandler");
		}
		
	}

}