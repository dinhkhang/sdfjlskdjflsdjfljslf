﻿package com.dutchlady.components {
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.BasePopUp;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			zoomOutButton.scaleX = zoomOutButton.scaleY = 0.6;
			contentMovie = movie;
			oldW = contentMovie.width;
			this.addChild(contentMovie);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			this.graphics.beginFill(0xFFFFFF, 0.5);
			this.graphics.drawRect( -139, -178, 1280, 1024);
			this.graphics.endFill();			
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			resize();
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
			
			/*if (contentMovie is ILove)	{
				ILove(contentMovie).boardParentMovie.visible = true;
				ILove(contentMovie).combox.visible = true;
			}*/
			if (contentMovie is BasePopUp)	BasePopUp(contentMovie).playPopUp();
			
			oldY = contentMovie.y;
			newY = contentMovie.y;
			
			this.addEventListener(Event.ENTER_FRAME, enterFramerHandler, false, 0, true);			
			this.addChild(zoomOutButton);			
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
			newY = contentMovie.y + 50 * event.delta;
			
			var max: Number = (GlobalVars.movieHeight - GlobalVars.windowsHeight)/2;
			var min: Number = max + GlobalVars.windowsHeight - contentMovie.height;
			newY = Math.min(max, newY);
			newY = Math.max(min, newY);
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
		}
		
		private function enterFramerHandler(event: Event): void {
			if (Math.abs(newY - oldY) > 1) {
				var max: Number = (GlobalVars.movieHeight - GlobalVars.windowsHeight)/2;
				var min: Number = max + GlobalVars.windowsHeight - contentMovie.height;
				trace( "min : " + min );
				newY = Math.min(max, newY);
				newY = Math.max(min, newY);
				contentMovie.y += (newY - oldY) * 0.2;
				trace( "contentMovie.y : " + contentMovie.y );
				oldY = contentMovie.y;
			}
		}
		
		private function contentUpHandler(event: Event): void {
			if (contentMovie)	oldMouseY = contentMovie.mouseY;
			stage.removeEventListener(MouseEvent.MOUSE_UP, contentUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, contentMoveHandler);
			stage.removeEventListener(Event.MOUSE_LEAVE, contentUpHandler);
			this.dispatchEvent(new PageEvent(PageEvent.CURSOR_NORMAL, true));
		}
		
		public function resize(): void {
			//contentMovie.width = GlobalVars.windowsWidth;
			//contentMovie.scaleY = contentMovie.scaleX = GlobalVars.windowsWidth / oldW;
			//contentMovie.x = (GlobalVars.movieWidth - GlobalVars.windowsWidth) / 2;
			
			zoomOutButton.x = Math.min( contentMovie.width + zoomOutButton.width/2,
					GlobalVars.windowsWidth - (GlobalVars.windowsWidth - GlobalVars.movieWidth)/2 - zoomOutButton.width/2.5);
			zoomOutButton.y = (GlobalVars.movieHeight - GlobalVars.windowsHeight)/2 + zoomOutButton.height + 10;
		}
	}

}