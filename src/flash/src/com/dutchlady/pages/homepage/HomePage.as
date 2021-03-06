﻿package com.dutchlady.pages.homepage {
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.components.milkbox.MilkBox;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.BasePage;
	import fl.transitions.easing.None;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import gs.TweenLite;
	import swfaddress.SWFAddress;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class HomePage extends BasePage {
		public var game1Button: SimpleButton;
		public var game2Button: SimpleButton;
		public var milkBoxHolder: Sprite;
		public var milkBox: MilkBox;
		public var fireFlyMovie: MovieClip;
		public var cloudMovie: MovieClip;
		
		public function HomePage() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//TweenLite.to(fireFlyMovie, 2, { x: 70, ease: None.easeNone, onComplete: fireFlyTweenCompleteHandler } );
			milkBox = new MilkBox();
			milkBox.x = -300;
			milkBox.y = -300;
			//milkBox.visible = false;
			milkBox.addEventListener(MilkBox.CREATION_COMPLETE, milkBoxCreationCompleteHandler);
			milkBoxHolder.y = 290;
			milkBoxHolder.addChild(milkBox);
			
			game1Button.addEventListener(MouseEvent.CLICK, gameClickHandler);
			game2Button.addEventListener(MouseEvent.CLICK, gameClickHandler);
			
			fireFlyMovie.addEventListener(MouseEvent.ROLL_OVER, digitalPanelMouseHandler);
			fireFlyMovie.addEventListener(MouseEvent.ROLL_OUT, digitalPanelMouseHandler);
			fireFlyMovie.addEventListener(MouseEvent.CLICK, digitalPanelMouseHandler);
		}
		
		private function digitalPanelMouseHandler(event: MouseEvent): void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					fireFlyMovie.filters = [new GlowFilter(0xFFFFFF, 1, 15, 15, 3)];
				break;
				case MouseEvent.ROLL_OUT:
					fireFlyMovie.filters = [];
				break;
				case MouseEvent.CLICK:
					SWFAddress.setValue("upload-photo");
				break;
			}			
		}
		
		private function gameClickHandler(event: MouseEvent): void {
			switch (event.currentTarget) {
				case game1Button:
					//this.dispatchEvent(new PageEvent(PageEvent.GO_TO_GETMILKPAGE, true));
					SWFAddress.setValue("game-nong-trai");
				break;
				case game2Button:
					//this.dispatchEvent(new PageEvent(PageEvent.GO_TO_FACTORYPAGE, true));
					SWFAddress.setValue("game-nha-may");
				break;
			}
		}
		
		private function milkBoxCreationCompleteHandler(event: Event): void {
			//milkBox.visible = true;
			//milkBox.alpha = 0;
			//TweenLite.to(milkBox, 2, { alpha: 1, ease: None.easeNone } );
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// OVERRIDE
		
		override public function startBeginPage(): void {
			super.startBeginPage();
			this.dispatchEvent(new PageEvent(PageEvent.STAR_BEGIN_PAGE));
			completeBeginPage();
		}
		
		override public function completeBeginPage():void {
			super.completeBeginPage();
			this.dispatchEvent(new PageEvent(PageEvent.COMPLETE_BEGIN_PAGE));			
			
		}
		
		override public function startEndPage():void {
			super.startEndPage();
			this.dispatchEvent(new PageEvent(PageEvent.STAR_BEGIN_PAGE));
			completeEndPage();
		}
		
		override public function completeEndPage():void {
			super.completeEndPage();
			this.dispatchEvent(new PageEvent(PageEvent.COMPLETE_END_PAGE));
		}
		
		override public function get mouseCheckingMode(): Boolean { return milkBox.isRollOver; }
		
		override public function set mouseCheckingMode(value: Boolean): void {
			milkBox.isRollOver = value;
		}
		
		override public function resize(): void {
			super.resize();
			fireFlyMovie.x = GlobalVars.windowsWidth + (GlobalVars.movieWidth - GlobalVars.windowsWidth) / 2 - fireFlyMovie.width - 20; 
			fireFlyMovie.y = (GlobalVars.movieHeight - GlobalVars.windowsHeight) / 2 + 50;
			
			cloudMovie.y = fireFlyMovie.y + cloudMovie.height;
			//if (GlobalVars.windowsHeight > GlobalVars.movieHeight)	fireFlyMovie.y -= (GlobalVars.windowsHeight - GlobalVars.movieHeight) / 2;
			//trace( "fireFlyMovie.y : " + fireFlyMovie.y );
		}
	}

}