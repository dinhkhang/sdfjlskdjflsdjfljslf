package com.dutchlady {
	import com.utils.QueueLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class PreLoader extends MovieClip {
		public var loadingMovie: MovieClip;
		private var queueLoader: QueueLoader;
		
		public function PreLoader() {
			loadingMovie.gotoAndStop(1);
			
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(new URLRequest("xml/queueconfig.xml"));
		}
		
		private function completeHandler(event: Event): void {
			var xml: XML = XML(event.currentTarget.data);
			trace( "xml : " + xml );
			queueLoader = new QueueLoader();
			queueLoader.addEventListener(Event.COMPLETE, queueCompleteHandler);
			queueLoader.addEventListener(ProgressEvent.PROGRESS, queueProgressHandler);
			for each (var item: XML in xml.item) {
				queueLoader.addItemURL(item.toString());
				trace( "item.toString() : " + item.toString() );
			}
			queueLoader.start();
		}
		
		private function queueCompleteHandler(event: Event): void {
			queueLoader.removeEventListener(Event.COMPLETE, queueCompleteHandler);
			queueLoader.removeEventListener(ProgressEvent.PROGRESS, queueProgressHandler);
			while (this.numChildren)	this.removeChildAt(0);
			this.addChild(queueLoader.firstItem);
			
			var maskMovie: MovieClip = new MovieClip();
			maskMovie.graphics.beginFill(0, 0);
			maskMovie.graphics.drawRect(0, 0, 1280, 668);
			maskMovie.graphics.endFill();
			this.addChild(maskMovie);
			maskMovie.x = -139;
			
			queueLoader.firstItem.mask = maskMovie;
		}
		
		private function queueProgressHandler(event: ProgressEvent): void {
			loadingMovie.gotoAndStop(queueLoader.percent);
		}
		
		private function ioErrorHandler(event: IOErrorEvent): void {
			trace(event.text);
		}
		
	}

}