package com.dutchlady.pages.tour {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.http.HttpServiceEvent;
	import com.dutchlady.services.AppServices;
	import fl.video.FLVPlayback;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class TourNewsList extends Sprite {
		
		public var playButton: SimpleButton;
		public var flvPlayback: FLVPlayback;
		
		public function TourNewsList() {
			var service: AppServices = new AppServices(Configuration.instance.getTourNewsServiceUrl);
			//var service: AppServices = new AppServices("http://demo.intelligent-content.net/flashapi/FlashServices.asmx/GetContents");
			service.addEventListener(HttpServiceEvent.RESULT, getDataResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, getDataFaultHandler);
			service.getTourNews();
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
				item.update(contentXml.ns::Id, contentXml.ns::PhotoUrl, contentXml.ns::Title, contentXml.ns::Description);
				item.y = posY;
				
				posY += item.height + 10;
				
				addChild(item);
			}
			
			flvPlayback.buttonMode = true;
			flvPlayback.autoPlay = true;
			//flvPlayback.source = "http://www.toiyeucogaihalan.com/staging/video/DL_Heart_S30s.flv";
			trace( "flvPlayback.source : " + flvPlayback.source );
			flvPlayback.addEventListener(MouseEvent.CLICK, videoClickHandler);
			playButton.visible = false;
			playButton.addEventListener(MouseEvent.CLICK, playClickHandler);
		}
		
		private function videoClickHandler(event: MouseEvent): void {
			flvPlayback.pause();
			playButton.visible = true;
		}
		
		private function playClickHandler(event: MouseEvent): void {
			flvPlayback.play();
			playButton.visible = false;
		}
		
		private function getDataFaultHandler(event: HttpServiceEvent): void {
			trace("getDataFaultHandler");
		}
		
	}

}