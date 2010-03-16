package com.utils {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class QueueLoader extends EventDispatcher{
		
		private var queue: Array;
		private var currentIndex: int;
		
		public var percent: Number;
		public var itemArray: Array;
		
		public var firstItem: DisplayObject;
		
		public function QueueLoader() {
			queue = new Array();
			itemArray = new Array();
			percent = 0;
			currentIndex = -1;
		}
		
		public function addItemURL(url: String): void {
			queue.push(url);
		}
		
		public function start(): void {
			currentIndex++;
			if (currentIndex < queue.length) {
				var loader: Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, itemLoaderCompleteHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, itemLoaderProgressHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, itemLoaderErrorHandler);
				loader.load(new URLRequest(queue[currentIndex]));
				itemArray.push(loader);
			}
			else this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function itemLoaderCompleteHandler(event: Event): void {			
			if (!firstItem)	firstItem = event.currentTarget.loader.content;
			trace("Current done is " + currentIndex);
			start();
		}
		
		private function itemLoaderProgressHandler(event: ProgressEvent): void {
			percent = (currentIndex + event.bytesLoaded / event.bytesTotal) * 100 / queue.length;
			this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		private function itemLoaderErrorHandler(event: IOErrorEvent): void {
			trace("Item " + currentIndex + " error: " + event.text );
			start();
		}
	}

}