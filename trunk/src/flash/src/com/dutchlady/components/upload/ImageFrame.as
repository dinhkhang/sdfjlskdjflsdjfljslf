package com.dutchlady.components.upload {
	import com.senocular.display.TransformTool;
	import com.senocular.display.TransformToolControl;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class ImageFrame extends Sprite {
		public var maskMovie		: MovieClip;
		public var imageHolder		: MovieClip;
		public var loader			: Loader;
		public var loadingMovie		: MovieClip;
		public var borderMovie		: MovieClip;
		
		private var transformTool	: TransformTool;
		
		public function ImageFrame() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			imageHolder.mask = maskMovie;
			
			maskMovie.visible = false;
			
			hideLoading();
			
			transformTool = new TransformTool();
			transformTool.registrationEnabled = true;
			transformTool.rememberRegistration = true;
			transformTool.registration = transformTool.boundsCenter;
			addChild(transformTool);
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
		}
		
		private function stageMouseDownHandler(event: MouseEvent): void {
			if (event.target == borderMovie || event.target == imageHolder || event.target == this || event.target is TransformToolControl) {
				imageHolder.mask = null;
				
				transformTool.target = imageHolder;
				transformTool.registration = transformTool.boundsCenter;
			} else  {
				transformTool.target = null;
				imageHolder.mask = maskMovie;
			}
		}
		
		public function changeImage(imageUrl: String):void {
			imageHolder.rotation = 0;
			imageHolder.scaleX = 1;
			imageHolder.scaleY = 1;
			imageHolder.x = 0;
			imageHolder.y = 0;
			while (imageHolder.numChildren > 0) imageHolder.removeChildAt(0);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageIOErrorHandler);
			
			showLoading();
			loader.load(new URLRequest(imageUrl));
		}
		
		private function imageIOErrorHandler(event: IOErrorEvent): void {
			trace("imageIOErrorHandler " + event);
		}
		
		private function imageLoadCompleteHandler(event: Event): void {
			hideLoading();
			trace("imageLoadCompleteHandler " + event);
			imageHolder.addChild(event.target.content);
			imageHolder.width = 280;
			imageHolder.height = 188;
			
			transformTool.target = imageHolder;
			transformTool.registration = transformTool.boundsCenter;
		}
		
		private function showLoading():void {
			loadingMovie.visible = true;
			loadingMovie.gotoAndPlay(1);
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function hideLoading():void {
			loadingMovie.visible = false;
			loadingMovie.gotoAndStop(1);
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
	}

}