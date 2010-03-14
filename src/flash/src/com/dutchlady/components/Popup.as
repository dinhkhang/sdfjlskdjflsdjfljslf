package com.dutchlady.components {
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.components.milkbox.HandCursor;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.iLove.ILove;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import gs.TweenLite;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Popup extends MovieClip {
		
		//public var bgMovie: MovieClip;
		private var contentMovie: MovieClip;
		public var zoomOutButton: SimpleButton;
		private var oldMouseY: Number;
		private var oldY: Number;
		private var oldW: Number = 991;
		private var newY: Number;
		
		public function Popup(movie: MovieClip) {			
			zoomOutButton = new ZoomOutButton();
			contentMovie = movie;
			//oldW = contentMovie.width;
			this.addChild(contentMovie);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			contentMovie.alpha = 0;
			TweenLite.to(contentMovie, 1, { alpha:1, onComplete: completeHandler} );
		}
		
		private function exitHandler():void {
			this.dispatchEvent(new PageEvent(PageEvent.POPUP_CLOSE));
		}
		
		private function completeHandler():void {
			contentMovie.buttonMode = true;
			contentMovie.addEventListener(MouseEvent.MOUSE_WHEEL, contentWheelHandler);
			contentMovie.addEventListener(MouseEvent.MOUSE_DOWN, contentDownHandler);
			
			var coverMovie: MovieClip = new MovieClip();
			coverMovie.graphics.beginFill(0, 0);
			coverMovie.graphics.drawRect(0, 0, contentMovie.width, contentMovie.height);
			coverMovie.graphics.endFill();
			contentMovie.addChildAt(coverMovie, 0);
			
			if (contentMovie is ILove)	ILove(contentMovie).boardMovie.visible = true;
			
			oldY = contentMovie.y;
			newY = contentMovie.y;
			
			this.addEventListener(Event.ENTER_FRAME, enterFramerHandler, false, 0, true);
			
			this.addChild(zoomOutButton);
			zoomOutButton.x = GlobalVars.windowsWidth - zoomOutButton.width / 2;
			zoomOutButton.y = zoomOutButton.height;
			zoomOutButton.addEventListener(MouseEvent.CLICK, zoomOutClickHandler);
		}
		
		private function zoomOutClickHandler(event: MouseEvent): void {
			TweenLite.to(this, 0.5, { alpha: 0, onComplete: zoomOutHandler } );
		}
		
		private function zoomOutHandler():void {
			this.visible = false;
			this.dispatchEvent(new PageEvent(PageEvent.POPUP_CLOSE));
			//Mouse.show();
		}
		
		private function contentWheelHandler(event: MouseEvent): void {
			var max: Number = 0;
			var min: Number = GlobalVars.windowsHeight - contentMovie.height;
			newY = contentMovie.y + 50 * event.delta;
			if (newY > max)	newY = max;
			if (newY < min) newY = min;
		}
		
		private function contentDownHandler(event: MouseEvent): void {
			oldY = contentMovie.y;
			oldMouseY = contentMovie.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_UP, contentUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, contentUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, contentMoveHandler);
			this.dispatchEvent(new PageEvent(PageEvent.CURSOR_SPAN, true));
		}
		
		private function contentMoveHandler(event: MouseEvent): void {
			newY += (contentMovie.mouseY - oldMouseY);
			oldMouseY = contentMovie.mouseY;
			var max: Number = 0;
			var min: Number = GlobalVars.windowsHeight - contentMovie.height;
			if (newY > max)	newY = max;
			if (newY < min) newY = min;
			//this.dispatchEvent(new PageEvent(PageEvent.CURSOR_SPAN, true));
		}
		
		private function enterFramerHandler(event: Event): void {
			contentMovie.y += (newY - oldY) * 0.2;
			oldY = contentMovie.y;
		}
		
		private function contentUpHandler(event: Event): void {
			if (contentMovie)	oldMouseY = contentMovie.mouseY;
			stage.removeEventListener(MouseEvent.MOUSE_UP, contentUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, contentMoveHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, contentUpHandler);
			this.dispatchEvent(new PageEvent(PageEvent.CURSOR_NORMAL, true));
		}
		
		public function resize(): void {
			contentMovie.width = GlobalVars.windowsWidth;
			trace( "contentMovie.width : " + contentMovie.width );
			contentMovie.scaleY = contentMovie.scaleX;
			contentMovie.x += (oldW - GlobalVars.windowsWidth) / 2;
			trace( "GlobalVars.windowsWidth : " + GlobalVars.windowsWidth );
			trace( "contentMovie.x : " + contentMovie.x );
			trace( "oldW : " + oldW );
			
			zoomOutButton.x = GlobalVars.windowsWidth - zoomOutButton.width / 2 + contentMovie.x;
			zoomOutButton.y = zoomOutButton.height;
		}
	}

}