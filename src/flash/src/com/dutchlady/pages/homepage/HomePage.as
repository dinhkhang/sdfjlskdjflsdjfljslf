package com.dutchlady.pages.homepage {
	import com.dutchlady.components.milkbox.MilkBox;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.BasePage;
	import fl.transitions.easing.None;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		public function HomePage() {
			//TweenLite.to(fireFlyMovie, 2, { x: 70, ease: None.easeNone, onComplete: fireFlyTweenCompleteHandler } );
			milkBox = new MilkBox();
			milkBox.x = -300;
			milkBox.y = -300;
			milkBox.visible = false;
			milkBox.addEventListener(MilkBox.CREATION_COMPLETE, milkBoxCreationCompleteHandler);
			milkBoxHolder.addChild(milkBox);
			
			game1Button.addEventListener(MouseEvent.CLICK, gameClickHandler);
			game2Button.addEventListener(MouseEvent.CLICK, gameClickHandler);
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
			milkBox.visible = true;
			milkBox.alpha = 0;
			TweenLite.to(milkBox, 2, { alpha: 1, ease: None.easeNone} );
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
	}

}