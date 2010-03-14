package com.dutchlady.pages.factory {
	import com.dutchlady.components.getmilk.Clock;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.BasePage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import swfaddress.SWFAddress;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Factory extends BasePage {
		
		public var clockMovie: Clock;
		public var bgMovie: MovieClip;
		public var ladyMovie: MovieClip;
		public var maskMovie: MovieClip;
		public var boardMovie: MovieClip;
		public var board2Movie: MovieClip;
		//public var highlight1Movie: MovieClip;
		//public var highlight2Movie: MovieClip;
		//public var highlight3Movie: MovieClip;
		//public var highlight4Movie: MovieClip;
		public var pos1Movie: MovieClip;
		public var pos2Movie: MovieClip;
		public var pos3Movie: MovieClip;
		public var pos4Movie: MovieClip;
		public var comp1Movie: MovieClip;
		public var comp2Movie: MovieClip;
		public var comp3Movie: MovieClip;
		public var comp4Movie: MovieClip;
		public var leftText: MovieClip;
		public var middleText: MovieClip;
		public var rightText: MovieClip;
		
		private var activeComp: Bitmap;
		private var glow: GlowFilter = new GlowFilter(0xFFFF00, 1, 10, 10);
		private var brightness: ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,20,0,1,0,0,20,0,0,1,0,20,0,0,0,1,0]);
		
		public function Factory() {
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
			initEvents();
		}
		
		private function initEvents():void {
			comp1Movie.addEventListener(MouseEvent.ROLL_OVER, compMouseHandler);
			comp2Movie.addEventListener(MouseEvent.ROLL_OVER, compMouseHandler);
			comp3Movie.addEventListener(MouseEvent.ROLL_OVER, compMouseHandler);
			comp4Movie.addEventListener(MouseEvent.ROLL_OVER, compMouseHandler);
			
			comp1Movie.addEventListener(MouseEvent.ROLL_OUT, compMouseHandler);
			comp2Movie.addEventListener(MouseEvent.ROLL_OUT, compMouseHandler);
			comp3Movie.addEventListener(MouseEvent.ROLL_OUT, compMouseHandler);
			comp4Movie.addEventListener(MouseEvent.ROLL_OUT, compMouseHandler);
			
			comp1Movie.addEventListener(MouseEvent.MOUSE_DOWN, compMouseHandler);
			comp2Movie.addEventListener(MouseEvent.MOUSE_DOWN, compMouseHandler);
			comp3Movie.addEventListener(MouseEvent.MOUSE_DOWN, compMouseHandler);
			comp4Movie.addEventListener(MouseEvent.MOUSE_DOWN, compMouseHandler);
			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseHandler);
			this.stage.addEventListener(Event.MOUSE_LEAVE, stageMouseHandler);
			
			clockMovie.addEventListener(Clock.TIME_UP, timeUpHandler);
			
			//	result board
			boardMovie.retryMovie.addEventListener(MouseEvent.ROLL_OVER, resultButtonMouseHandler);
			boardMovie.goPackageMovie.addEventListener(MouseEvent.ROLL_OVER, resultButtonMouseHandler);
			boardMovie.goFarmMovie.addEventListener(MouseEvent.ROLL_OVER, resultButtonMouseHandler);
			boardMovie.retryMovie.addEventListener(MouseEvent.ROLL_OUT, resultButtonMouseHandler);
			boardMovie.goPackageMovie.addEventListener(MouseEvent.ROLL_OUT, resultButtonMouseHandler);
			boardMovie.goFarmMovie.addEventListener(MouseEvent.ROLL_OUT, resultButtonMouseHandler);
			boardMovie.retryMovie.addEventListener(MouseEvent.CLICK, resultButtonMouseHandler);
			boardMovie.goPackageMovie.addEventListener(MouseEvent.CLICK, resultButtonMouseHandler);
			boardMovie.goFarmMovie.addEventListener(MouseEvent.CLICK, resultButtonMouseHandler);
			
			board2Movie.retryMovie.addEventListener(MouseEvent.ROLL_OVER, resultButtonMouseHandler);
			board2Movie.goFarmMovie.addEventListener(MouseEvent.ROLL_OVER, resultButtonMouseHandler);
			board2Movie.retryMovie.addEventListener(MouseEvent.ROLL_OUT, resultButtonMouseHandler);
			board2Movie.goFarmMovie.addEventListener(MouseEvent.ROLL_OUT, resultButtonMouseHandler);
			board2Movie.retryMovie.addEventListener(MouseEvent.CLICK, resultButtonMouseHandler);
			board2Movie.goFarmMovie.addEventListener(MouseEvent.CLICK, resultButtonMouseHandler);
			//
		}
		
		private function resultButtonMouseHandler(event: MouseEvent): void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					event.currentTarget.gotoAndStop(2);
				break;
				case MouseEvent.ROLL_OUT:
					event.currentTarget.gotoAndStop(1);
				break;
				case MouseEvent.CLICK:
					switch (event.currentTarget) {
						case boardMovie.retryMovie:
						case board2Movie.retryMovie:
							init();
							startGame();
						break;
						case boardMovie.goPackageMovie:
							SWFAddress.setValue("upload-photo");
						break;
						case boardMovie.goFarmMovie:
						case board2Movie.goFarmMovie:
							//	...
							this.dispatchEvent(new PageEvent(PageEvent.GO_TO_HOMEPAGE, true));
						break;
					}
				break;
			}
		}
		
		private function stageMouseHandler(event: Event): void {
			trace( "event target : " + event.target );
			if (!activeComp || !this.contains(activeComp))	return;
			switch (event.type) {
				case MouseEvent.MOUSE_UP:
					var isRight: Boolean = false;
					if (pos1Movie.hitTestObject(activeComp) && activeComp.name == "1") {
						pos1Movie.alpha = 1;
						comp1Movie.mouseEnabled = comp1Movie.mouseChildren = false;
						isRight = true;
						//highlight1Movie.visible = false;
						pos1Movie.filters = [glow];
					}
					else if (pos2Movie.hitTestObject(activeComp) && activeComp.name == "2") {
						pos2Movie.alpha = 1;
						comp2Movie.mouseEnabled = comp2Movie.mouseChildren = false;
						isRight = true;
						//highlight2Movie.visible = false;
						pos2Movie.filters = [glow];
					}
					else if (pos3Movie.hitTestObject(activeComp) && activeComp.name == "3") {
						pos3Movie.alpha = 1;
						comp3Movie.mouseEnabled = comp3Movie.mouseChildren = false;
						isRight = true;
						//highlight3Movie.visible = false;
						pos3Movie.filters = [glow];
					}
					else if (pos4Movie.hitTestObject(activeComp) && activeComp.name == "4") {
						pos4Movie.alpha = 1;
						comp4Movie.mouseEnabled = comp4Movie.mouseChildren = false;
						isRight = true;
						//highlight4Movie.visible = false;
						pos4Movie.filters = [glow];
					}
					if (!isRight)	this.getChildByName("comp" + activeComp.name + "Movie").alpha = 1;
					checkGame();
				case Event.MOUSE_LEAVE:
					this.removeChild(activeComp);
					activeComp = null;
					this.dispatchEvent(new PageEvent(PageEvent.CURSOR_NORMAL, true));
				break;
				case MouseEvent.MOUSE_MOVE:
					activeComp.x = this.mouseX - activeComp.width / 2;
					activeComp.y = this.mouseY - activeComp.height / 2;
					if (pos1Movie.alpha < 1)	{
						leftText.visible = pos1Movie.hitTestObject(activeComp);
						if (activeComp.name == "1") {
							pos1Movie.filters = (leftText.visible) ? [glow] : [];
							pos1Movie.alpha = (leftText.visible) ? 0.5 : 0;
							//highlight1Movie.visible = leftText.visible;
						}
					}
					if (pos2Movie.alpha < 1 || pos3Movie.alpha < 1) {
						middleText.visible = pos2Movie.hitTestObject(activeComp) || pos3Movie.hitTestObject(activeComp);
						if (activeComp.name == "2") {
							pos2Movie.filters = (pos2Movie.hitTestObject(activeComp)) ? [glow] : [];
							pos2Movie.alpha = (pos2Movie.hitTestObject(activeComp)) ? 0.5 : 0;
							//highlight2Movie.visible = pos2Movie.hitTestObject(activeComp);
						}
						if (activeComp.name == "3") {
							pos3Movie.filters = (pos3Movie.hitTestObject(activeComp)) ? [glow] : [];
							pos3Movie.alpha = (pos3Movie.hitTestObject(activeComp)) ? 0.5 : 0;
							//highlight3Movie.visible = pos3Movie.hitTestObject(activeComp);
						}
					}
					if (pos4Movie.alpha < 1) {
						rightText.visible = pos4Movie.hitTestObject(activeComp);
						if (activeComp.name == "4") {
							pos4Movie.filters = (rightText.visible) ? [glow] : [];
							pos4Movie.alpha = (rightText.visible) ? 0.5 : 0;
							//highlight4Movie.visible = rightText.visible;
						}
					}
				break;
				
			}
		}
		
		private function compMouseHandler(event: MouseEvent): void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					event.currentTarget.filters = [glow, brightness];
				break;
				case MouseEvent.ROLL_OUT:
					event.currentTarget.filters = [];
				break;
				case MouseEvent.MOUSE_DOWN:
					event.currentTarget.filters = [];
					var compMovie: MovieClip;
					activeComp = new Bitmap();
					activeComp.smoothing = true;
					
					switch (event.currentTarget) {
						case comp1Movie:
							compMovie = pos1Movie;
							activeComp.name = "1";
						break;
						case comp2Movie:
							compMovie = pos2Movie;
							activeComp.name = "2";
						break;
						case comp3Movie:
							compMovie = pos3Movie;
							activeComp.name = "3";
						break;
						case comp4Movie:
							compMovie = pos4Movie;
							activeComp.name = "4";
						break;
					}
					var bitmapdata: BitmapData = new BitmapData(compMovie.width, compMovie.height, true, 0xFFFFFF);
					bitmapdata.draw(compMovie, null, null, null, null, true);
					activeComp.bitmapData = bitmapdata;
					
					this.addChild(activeComp);
					activeComp.x = this.mouseX - activeComp.width / 2;
					activeComp.y = this.mouseY - activeComp.height / 2;
					this.dispatchEvent(new PageEvent(PageEvent.CURSOR_NULL, true));
					event.currentTarget.alpha = 0;
				break;
			}
		}
		
		private function init():void {
			/*highlight1Movie.visible = false;
			highlight2Movie.visible = false;
			highlight3Movie.visible = false;
			highlight4Movie.visible = false;*/
			//highlight1Movie.visible = true;
			//highlight2Movie.visible = true;
			//highlight3Movie.visible = true;
			//highlight4Movie.visible = true;
			
			comp1Movie.alpha = 1;
			comp2Movie.alpha = 1;
			comp3Movie.alpha = 1;
			comp4Movie.alpha = 1;
			
			comp1Movie.mouseEnabled = comp1Movie.mouseChildren = true;
			comp2Movie.mouseEnabled = comp2Movie.mouseChildren = true;
			comp3Movie.mouseEnabled = comp3Movie.mouseChildren = true;
			comp4Movie.mouseEnabled = comp4Movie.mouseChildren = true;
			
			pos1Movie.alpha = 0;
			pos2Movie.alpha = 0;
			pos3Movie.alpha = 0;
			pos4Movie.alpha = 0;
			
			comp1Movie.buttonMode = true;
			comp2Movie.buttonMode = true;
			comp3Movie.buttonMode = true;
			comp4Movie.buttonMode = true;
			
			boardMovie.visible = false;
			board2Movie.visible = false;
			
			maskMovie.gotoAndStop(1);			
			this.gotoAndStop(1);
			
			leftText.visible = false;
			middleText.visible = false;
			rightText.visible = false;
			
			//	Result board init
			boardMovie.retryMovie.buttonMode = true;
			board2Movie.retryMovie.buttonMode = true;
			boardMovie.goPackageMovie.buttonMode = true;
			boardMovie.goFarmMovie.buttonMode = true;
			board2Movie.goFarmMovie.buttonMode = true;
			//
			
			//TEST ONLY
			//startGame();
		}
		
		public function startGame(): void {
			clockMovie.startClock(60);
			ladyMovie.gotoAndPlay(1);
		}
		
		private function timeUpHandler(event: Event): void {
			board2Movie.visible = true;
			if (stage)	this.stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		
		public function checkGame(): void {
			if ( pos1Movie.alpha == 1 &&
				 pos2Movie.alpha == 1 &&
				 pos3Movie.alpha == 1 &&
				 pos4Movie.alpha == 1) {	//	WIN					
					clockMovie.stopClock();
					//pos1Movie.filters = [];
					//pos2Movie.filters = [];
					//pos3Movie.filters = [];
					//pos4Movie.filters = [];
					this.gotoAndPlay(2);
					this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
					maskMovie.play();
			}
			else {
				
			}
		}
		
		private function enterFrameHandler(event: Event): void {			
			if (this.currentFrame == this.totalFrames) {
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				boardMovie.visible = true;
			}
		}
			
		// OVERRIDE		
		override public function startBeginPage(): void {
			super.startBeginPage();
			this.dispatchEvent(new PageEvent(PageEvent.STAR_BEGIN_PAGE));
			completeBeginPage();
		}
		
		override public function completeBeginPage():void {
			trace( "Factory.completeBeginPage" );
			super.completeBeginPage();
			this.dispatchEvent(new PageEvent(PageEvent.COMPLETE_BEGIN_PAGE));			
			startGame();
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
	}

}