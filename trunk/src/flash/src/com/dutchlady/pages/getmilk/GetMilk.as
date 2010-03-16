package com.dutchlady.pages.getmilk {
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.components.getmilk.Clock;
	import com.dutchlady.components.getmilk.Cow;
	import com.dutchlady.components.getmilk.DutchLady;
	import com.dutchlady.components.getmilk.GrassCow;
	import com.dutchlady.components.getmilk.Trough;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.BasePage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	import gs.TweenLite;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class GetMilk extends BasePage {
		// events
		public static const RETRY: String = "retry";
		public static const NEXT_LEVEL: String = "next_level";
		public static const GO_FACTORY: String = "go_factory";
		//
		
		public var resultMovie: MovieClip;
		public var busyMovie: MovieClip;
		public var coverMovie: MovieClip;
		public var mask1Movie: MovieClip;
		public var mask2Movie: MovieClip;
		public var mask3Movie: MovieClip;
		public var mask4Movie: MovieClip;
		public var mask5Movie: MovieClip;
		public var clockMovie: Clock;
		public var milkMovie: MovieClip;
		public var cow1Movie: Cow;
		public var cow2Movie: Cow;
		public var cow3Movie: Cow;
		public var cow4Movie: Cow;
		public var cow5Movie: Cow;
		public var trough1Movie: Trough;
		public var trough2Movie: Trough;
		public var trough3Movie: Trough;
		public var trough4Movie: Trough;
		public var trough5Movie: Trough;
		public var ladyMovie: DutchLady;
		
		private var grassCow1: GrassCow;
		private var grassCow2: GrassCow;
		private var grassCow3: GrassCow;
		private var grassCow4: GrassCow;
		private var grassCow5: GrassCow;
		private var currentTrough: Trough;
		private var currentCow: Cow;
		public var isSaying: Boolean = false;
		private var orderArray0: Array;
		private var orderArray1: Array;
		private var orderArray2: Array;
		private var gameTime: Number;
		
		private var gameOver: Boolean = false;
		
		public function GetMilk() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
			initEvents();
		}
		
		private function initEvents():void {
			trough1Movie.addEventListener(Trough.TROUGH_CLICKED, troughEventHandler);
			trough2Movie.addEventListener(Trough.TROUGH_CLICKED, troughEventHandler);
			trough3Movie.addEventListener(Trough.TROUGH_CLICKED, troughEventHandler);
			trough4Movie.addEventListener(Trough.TROUGH_CLICKED, troughEventHandler);
			trough5Movie.addEventListener(Trough.TROUGH_CLICKED, troughEventHandler);
			
			cow1Movie.addEventListener(Cow.COW_CLICKED, cowEventHandler);
			cow2Movie.addEventListener(Cow.COW_CLICKED, cowEventHandler);
			cow3Movie.addEventListener(Cow.COW_CLICKED, cowEventHandler);
			cow4Movie.addEventListener(Cow.COW_CLICKED, cowEventHandler);
			cow5Movie.addEventListener(Cow.COW_CLICKED, cowEventHandler);
		}
		
		private function resultShowMode(value: Boolean): void {
			resultMovie.alpha = 0;
			resultMovie.visible = value;
			if (value)	TweenLite.to(resultMovie, 2, {alpha: 1} );
			busyMode = false;
			
			resultMovie.boardMovie.nextLevelMovie.addEventListener(MouseEvent.ROLL_OVER, resultMouseHandler);
			resultMovie.boardMovie.nextLevelMovie.addEventListener(MouseEvent.ROLL_OUT, resultMouseHandler);
			resultMovie.boardMovie.nextLevelMovie.addEventListener(MouseEvent.CLICK, resultMouseHandler);
			
			resultMovie.boardMovie.retryMovie.addEventListener(MouseEvent.ROLL_OVER, resultMouseHandler);
			resultMovie.boardMovie.retryMovie.addEventListener(MouseEvent.ROLL_OUT, resultMouseHandler);
			resultMovie.boardMovie.retryMovie.addEventListener(MouseEvent.CLICK, resultMouseHandler);
			
			resultMovie.boardMovie.goFactoryMovie.addEventListener(MouseEvent.ROLL_OVER, resultMouseHandler);
			resultMovie.boardMovie.goFactoryMovie.addEventListener(MouseEvent.ROLL_OUT, resultMouseHandler);
			resultMovie.boardMovie.goFactoryMovie.addEventListener(MouseEvent.CLICK, resultMouseHandler);
			
			resultMovie.boardMovie.goFarmMovie.addEventListener(MouseEvent.ROLL_OVER, resultMouseHandler);
			resultMovie.boardMovie.goFarmMovie.addEventListener(MouseEvent.ROLL_OUT, resultMouseHandler);
			resultMovie.boardMovie.goFarmMovie.addEventListener(MouseEvent.CLICK, resultMouseHandler);
			
			resultMovie.boardMovie.nextLevelMovie.buttonMode = true;
			resultMovie.boardMovie.retryMovie.buttonMode = true;
			resultMovie.boardMovie.goFactoryMovie.buttonMode = true;
			resultMovie.boardMovie.goFarmMovie.buttonMode = true;
			
			if (resultMovie.boardMovie.currentLabel == "win") {
				resultMovie.boardMovie.retryMovie.buttonMode = false;
			}
			else {
				resultMovie.boardMovie.nextLevelMovie.buttonMode = false;
				resultMovie.boardMovie.goFactoryMovie.buttonMode = false;
			}
		}
		
		private function resultMouseHandler(event: MouseEvent): void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					event.currentTarget.gotoAndStop(2);
				break;
				case MouseEvent.ROLL_OUT:
					event.currentTarget.gotoAndStop(1);
				break;
				case MouseEvent.CLICK:
					resultMovie.visible = false;
					switch (event.currentTarget) {
						case resultMovie.boardMovie.nextLevelMovie:
							startGame(clockMovie.totalTime - 15);
						break;
						case resultMovie.boardMovie.retryMovie:
							startGame(clockMovie.totalTime);
						break;
						case resultMovie.boardMovie.goFactoryMovie:
							this.dispatchEvent(new PageEvent(PageEvent.GO_TO_FACTORYPAGE, true));
						break;
						case resultMovie.boardMovie.goFarmMovie:
							this.dispatchEvent(new PageEvent(PageEvent.GO_TO_HOMEPAGE, true));
						break;
					}
				break;
			}
		}
		
		private function enterFrameHandler(event: Event): void {			
			var array: Array;
			if (ladyMovie.y <= DutchLady.LEVEL0_POINT_LEFT.y) {	//	level 0
				array = orderArray0;
			}
			else if (ladyMovie.y <= DutchLady.LEVEL1_POINT_LEFT.y) {	//	level 1
				array = orderArray1;
			}
			else {	//	level 2
				array = orderArray2;
			}
			for (var i: int = 0; i < array.length; i++) {
				var movie: MovieClip = array[i] as MovieClip;
				this.setChildIndex(movie, this.numChildren - (i + 1));
			}
			cow1Movie.mask = mask1Movie;
			cow2Movie.mask = mask2Movie;
			cow3Movie.mask = mask3Movie;
			cow4Movie.mask = mask4Movie;
			cow5Movie.mask = mask5Movie;
			
			var scale: Number = (ladyMovie.y / DutchLady.LEVEL1_POINT_LEFT.y);
			if (scale < 1)	scale += (1 - scale) / 5;
			if (scale > 1)	scale -= (scale -1 ) / 2;
			ladyMovie.scaleX = ladyMovie.scaleY = scale;
			
			busyMovie.x = this.mouseX;
			busyMovie.y = this.mouseY;
		}
		
		private function ladyActionCompleteHandler(event: Event): void {
			var ladyCurrentLabel: String = ladyMovie.currentLabel;
			//var ladyCurrentLabel: String = "normal";
			if (currentTrough) {
				if (!currentTrough.isGoAway) {
					if (ladyCurrentLabel == ladyMovie.LEFT_TO_RIGHT)	ladyMovie.gotoAndStop(ladyMovie.LEFT_TO_RIGHT_DROP);
					else	ladyMovie.gotoAndStop(ladyMovie.RIGHT_TO_LEFT_DROP);
					//ladyMovie.dropMovie.gotoAndPlay(1);
					setTimeout(function () {
									setMouseEnable(true);
									if (ladyCurrentLabel == ladyMovie.LEFT_TO_RIGHT) ladyMovie.gotoAndStop(ladyMovie.NORMAL_LEFT);
									else ladyMovie.gotoAndStop(ladyMovie.NORMAL_RIGHT);
								}, 2000);
					if (currentTrough) {
						currentTrough.fillGrass();
						currentTrough = null;
					}
				}
				else setMouseEnable(true); 
			}
			
			if (currentCow) {
				if (!currentCow.isGoAway) {
				if (ladyMovie.x < currentCow.x)	ladyMovie.gotoAndStop(ladyMovie.LEFT_TO_RIGHT_GET);
				else	ladyMovie.gotoAndStop(ladyMovie.RIGHT_TO_LEFT_GET);
				currentCow.goGettingMilk();
				setTimeout(function () {
								setMouseEnable(true);
								if (ladyCurrentLabel == ladyMovie.LEFT_TO_RIGHT) ladyMovie.gotoAndStop(ladyMovie.NORMAL_LEFT);
									else ladyMovie.gotoAndStop(ladyMovie.NORMAL_RIGHT);
								if (currentCow) {
									goNextMilkLevel();
									currentCow.goWaitingForGrass();
									currentCow = null;									
								}
							}, 2000);
				}
				else setMouseEnable(true);
			}
		}
		
		private function timeUpHandler(event: Event): void {
			clockMovie.removeEventListener(Clock.TIME_UP, timeUpHandler);
			goLose();
		}
		
		private function cowEventHandler(event: Event): void {
			switch (event.type) {
				case Cow.COW_CLICKED:
					var cow: Cow = event.currentTarget as Cow;
					var targetY: Number;
					switch (cow) {
						case cow1Movie:
							targetY = DutchLady.LEVEL0_POINT_LEFT.y;
							trough1Movie.overable = true;
						break;
						case cow2Movie:
							targetY = DutchLady.LEVEL0_POINT_LEFT.y;
							trough2Movie.overable = true;
						break;
						case cow3Movie:
							targetY = DutchLady.LEVEL1_POINT_LEFT.y;
							trough3Movie.overable = true;
						break;
						case cow4Movie:
							targetY = DutchLady.LEVEL1_POINT_LEFT.y;
							trough4Movie.overable = true;
						break;
						case cow5Movie:
							targetY = DutchLady.LEVEL1_POINT_LEFT.y;
							trough5Movie.overable = true;
						break;
					}
					if (cow.currentLabel == Cow.START_WAITING_FOR_MILK) {
						currentCow = cow;
						setMouseEnable(false);
						//ladyMovie.walkTo(new Point(cow.x + 90 * ((ladyMovie.x > cow.x) ? 1 : -1), targetY));
						ladyMovie.smartWalkTo(new Point(cow.x + 80 * ((ladyMovie.x > cow.x) ? 1 : -1), targetY));
						cow.overable = false;
					}			
				break;
			}
		}
		
		private function troughEventHandler(event: Event): void {
			switch (event.type) {
				case Trough.TROUGH_CLICKED:
					var cowIsFull: Boolean = false;
					var targetY: Number;
					switch (event.currentTarget) {
						case trough1Movie:
							cowIsFull = (cow1Movie.currentLabel == Cow.START_WAITING_FOR_MILK);	//	True: Cow is full
							targetY = DutchLady.LEVEL1_POINT_LEFT.y;
							cow1Movie.overable = false;
						break;
						case trough2Movie:
							cowIsFull = (cow2Movie.currentLabel == Cow.START_WAITING_FOR_MILK);	//	True: Cow is full
							targetY = DutchLady.LEVEL1_POINT_LEFT.y;
							cow2Movie.overable = false;
						break;
						case trough3Movie:
							cowIsFull = (cow3Movie.currentLabel == Cow.START_WAITING_FOR_MILK);	//	True: Cow is full
							targetY = DutchLady.LEVEL2_POINT_LEFT.y;
							cow3Movie.overable = false;
						break;
						case trough4Movie:
							cowIsFull = (cow4Movie.currentLabel == Cow.START_WAITING_FOR_MILK);	//	True: Cow is full
							targetY = DutchLady.LEVEL2_POINT_LEFT.y;
							cow4Movie.overable = false;
						break;
						case trough5Movie:
							cowIsFull = (cow5Movie.currentLabel == Cow.START_WAITING_FOR_MILK);	//	True: Cow is full
							targetY = DutchLady.LEVEL2_POINT_LEFT.y;
							cow5Movie.overable = false;
						break;
					}					
					if (!cowIsFull) {						
						var trough: Trough = event.currentTarget as Trough;						
						if (trough.currentLevel <= 0) {							
							currentTrough = trough;
							//ladyMovie.walkTo(new Point(trough.x, targetY));
							ladyMovie.smartWalkTo(new Point(trough.x, targetY));
							setMouseEnable(false);		
							trough.overable = false;
						}		
					}
				break;
			}
		}
		
		private function init():void {
			grassCow1 = new GrassCow(cow1Movie, trough1Movie);
			grassCow2 = new GrassCow(cow2Movie, trough2Movie);
			grassCow3 = new GrassCow(cow3Movie, trough3Movie);
			grassCow4 = new GrassCow(cow4Movie, trough4Movie);
			grassCow5 = new GrassCow(cow5Movie, trough5Movie);
			
			busyMovie.visible = false;
			
			//ladyMovie.walkTo(new Point(917, 370));
			//ladyMovie.x = DutchLady.LEVEL1_POINT_RIGHT.x;
			//ladyMovie.y = DutchLady.LEVEL1_POINT_RIGHT.y;
			
			setMouseEnable(true);
			cow2Movie.mirror();
			cow5Movie.mirror();
				
			resultMovie.visible = false;
			
			orderArray0 = [coverMovie,
							resultMovie,
							busyMovie,
							mask5Movie, cow5Movie, trough5Movie,
							mask4Movie, cow4Movie, trough4Movie,
							mask3Movie,	cow3Movie, trough3Movie,
							mask2Movie,	cow2Movie, trough2Movie,
							mask1Movie,	cow1Movie, trough1Movie,
							ladyMovie];
			orderArray1 = [coverMovie,
							resultMovie,
							busyMovie,
							mask5Movie, cow5Movie, trough5Movie,
							mask4Movie, cow4Movie, trough4Movie,
							mask3Movie,	cow3Movie, trough3Movie,
							ladyMovie,
							mask2Movie,	cow2Movie, trough2Movie,
							mask1Movie,	cow1Movie, trough1Movie];
			orderArray2 = [coverMovie,
							resultMovie,
							busyMovie,
							ladyMovie,							
							mask5Movie, cow5Movie, trough5Movie,
							mask4Movie, cow4Movie, trough4Movie,
							mask3Movie,	cow3Movie, trough3Movie,
							mask2Movie,	cow2Movie, trough2Movie,
							mask1Movie,	cow1Movie, trough1Movie];
			//	Test only
			//startGame();
		}
		
		private function setMouseEnable(value: Boolean): void {
			if (!value) {
				this.setChildIndex(coverMovie, this.numChildren - 1);
				//coverMovie.visible = true;
				busyMode = true;
			}
			else {
				//coverMovie.visible = false;
				busyMode = false;
			}
		}
		
		private function goNextMilkLevel(): void {
			if (milkMovie.currentFrame < milkMovie.totalFrames) {
				milkMovie.gotoAndStop(milkMovie.currentFrame + 1);
				checkGameResult();
			}
		}
		
		public function checkGameResult(): void {
			if (gameOver)	return;
			if (cow1Movie.isGoAway && cow2Movie.isGoAway && cow3Movie.isGoAway && cow4Movie.isGoAway && cow5Movie.isGoAway) {
				goLose();
			}
			if (milkMovie.currentFrame == milkMovie.totalFrames) {
				goWin();
			}
		}
		
		private function goWin(): void {
			//	WIN
			trace("WIN **************************** ");
			resultMovie.boardMovie.gotoAndStop("win");
			setMouseEnable(false);
			stopGame();
			resultShowMode(true);
			gameOver = true;
		}
		
		private function goLose(): void {
			//	Time up LOSE
			trace("TIME UP: LOSE **************************** ");
			if (milkMovie.currentFrame > 1) resultMovie.boardMovie.gotoAndStop("half win");
			else resultMovie.boardMovie.gotoAndStop("lose");
			setMouseEnable(false);	
			stopGame();
			resultShowMode(true);
			gameOver = true;
		}
		
		public function startGame(time:Number = 90): void {
			gameTime = time;
			
			grassCow1.reset();
			grassCow2.reset();
			grassCow3.reset();
			grassCow4.reset();
			grassCow5.reset();
			
			milkMovie.gotoAndStop(1);
			busyMode = false;
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			coverMovie.visible = true;
			currentCow = null;
			currentTrough = null;
			
			if (ladyMovie.hasEventListener(DutchLady.ACTION_COMPLETE))	ladyMovie.removeEventListener(DutchLady.ACTION_COMPLETE, ladyActionCompleteHandler);
			ladyMovie.gotoAndStop(1);
			ladyMovie.x = GlobalVars.windowsWidth + ladyMovie.width;
			ladyMovie.y = 370;
			ladyMovie.addEventListener(DutchLady.ACTION_COMPLETE, ladyStartCompleteHandler);
			ladyMovie.smartWalkTo(new Point(890, 370));
			
			resultMovie.visible = false;
		}
		
		private function ladyStartCompleteHandler(event: Event): void {
			ladyMovie.removeEventListener(DutchLady.ACTION_COMPLETE, ladyStartCompleteHandler);
			ladyMovie.gotoAndStop(ladyMovie.NORMAL_RIGHT);
			ladyMovie.addEventListener(DutchLady.ACTION_COMPLETE, ladyActionCompleteHandler);
			clockMovie.addEventListener(Clock.TIME_UP, timeUpHandler);
			clockMovie.startClock(gameTime);
			coverMovie.visible = false;
		}
		
		private function stopGame(): void {
			clockMovie.stopClock();
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function set busyMode(value: Boolean): void {
			coverMovie.visible = value;
			//busyMovie.visible = value;
			if (value)	this.dispatchEvent(new PageEvent(PageEvent.CURSOR_BUSY, true));
			else	this.dispatchEvent(new PageEvent(PageEvent.CURSOR_NORMAL, true));
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
			startGame();
		}
		
		override public function startEndPage():void {
			super.startEndPage();
			this.dispatchEvent(new PageEvent(PageEvent.STAR_BEGIN_PAGE));
			completeEndPage();
			stopGame();
		}
		
		override public function completeEndPage():void {
			super.completeEndPage();
			this.dispatchEvent(new PageEvent(PageEvent.COMPLETE_END_PAGE));
		}
		
	}

}