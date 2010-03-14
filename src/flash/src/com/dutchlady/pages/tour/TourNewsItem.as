package com.dutchlady.pages.tour {
	import com.dutchlady.common.Configuration;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class TourNewsItem extends Sprite {
		public var thumbMovie		: MovieClip;
		public var titleText		: TextField;
		public var descriptionText	: TextField;
		
		private var tourId: String;
		
		public function TourNewsItem() {
		}
		
		public function update(tourId: String, thumbUrl: String, title: String, description: String):void {
			this.tourId = tourId;
			
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, thumbLoadInitHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, thumbLoadIOErrorHandler);
			loader.load(new URLRequest(thumbUrl));
			
			titleText.text = title;
			descriptionText.text = description;
			
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHanlder);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHanlder);
			this.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function rollOverHanlder(event: MouseEvent): void {
			var colorTrans: ColorTransform = titleText.transform.colorTransform;
			colorTrans.color = 0xFF0000;
			titleText.transform.colorTransform = colorTrans;
		}
		
		private function rollOutHanlder(event: MouseEvent): void {
			var colorTrans: ColorTransform = titleText.transform.colorTransform;
			colorTrans.color = 0xFFFFFF;
			titleText.transform.colorTransform = colorTrans;
		}
		
		private function thumbLoadIOErrorHandler(event: IOErrorEvent): void {
			
		}
		
		private function thumbLoadInitHandler(event: Event): void {
			while (thumbMovie.numChildren > 0) thumbMovie.removeChildAt(0);
			
			var content: DisplayObject = event.target.content;
			content.width = 206;
			content.height = 138;
			thumbMovie.addChild(event.target.content);
		}
		
		private function clickHandler(event: MouseEvent): void {
			trace("TourNewsItem clickHandler");
			var url: String = Configuration.instance.viewTourItemUrl + "?id=" + tourId;
			navigateToURL(new URLRequest(url), "_blank");
		}
	}

}