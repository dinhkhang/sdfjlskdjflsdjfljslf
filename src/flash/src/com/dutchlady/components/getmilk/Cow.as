package com.dutchlady.components.getmilk {
	import com.dutchlady.pages.getmilk.GetMilk;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import gs.TweenLite;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Cow extends MovieClip {
		public static const COW_CLICKED: String = "cow_clicked";
		public static const START_EATTING: String = "start_eatting";
		public static const START_WAITING_FOR_GRASS: String = "start_waiting_for_grass";
		public static const START_WAITING_FOR_MILK: String = "start_waiting_for_milk";
		public static const GETTING_MILK: String = "getting_milk";
		public static const START_GO_AWAY: String = "start_go_away";		
		
		private const WAITING_FOR_GRASS: String = "Cho xin cỏ!";
		private const WAITING_FOR_MILK: String = "Có sữa rồi!";
		//private const LONG_WAITING_FOR_MILK: String = "Lấy sữa của tôi đi,\ngần hết giờ rồi!";
		
		private var currentAction: String;
		private var _overable: Boolean = false;
		
		public var tailMovie: MovieClip;
		public var cowMovie: MovieClip;
		public var bubbleMovie: MovieClip;
		public var timingMovie: CowTiming;
		public var contentText: TextField;
		public var isGoAway: Boolean = false;
		private var isSaying: Boolean = false;
		private var timer: Timer;
		private var timeOutId: uint;
		public function Cow() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			contentText.mouseEnabled = false;
			bubbleMovie.alpha = 0;
			contentText.alpha = 0;
			
			tailMovie.play();
			timeOutId = setTimeout(playTail, Math.random() * 5000);
			
			timer = new Timer(Math.random() * 5000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
			timer.start();
			
			//this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			
			timingMovie.addEventListener(CowTiming.TIME_OFF, timeOffHandler);
			//reset();
		}
		
		public function reset(): void {
			overable = false;
			isGoAway = false;
			goWaitingForGrass();
			clearTimeout(timeOutId);
			timeOutId = setTimeout(playTail, Math.random() * 5000);
		}
		
		private function playTail():void {
			var index: int = Math.round(Math.random() * 4) + 1;
			var label: String = "style" + index.toString();
			if (tailMovie)	tailMovie.gotoAndPlay(label);
			timeOutId = setTimeout(playTail, Math.random() * 5000 + 5000);
		}
		
		private function timerCompleteHandler(event: TimerEvent): void {			
			event.currentTarget.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			if (!GetMilk(parent).isSaying) {
				isSaying = true;
				GetMilk(parent).isSaying = true;
				TweenLite.to(bubbleMovie, 0.5, {alpha: 1 } );
				TweenLite.to(contentText, 0.5, { alpha: 1 } );
			}
			else if (isSaying) {
				GetMilk(parent).isSaying = false;
				isSaying = false;
				TweenLite.to(bubbleMovie, 0.5, {alpha: 0 } );
				TweenLite.to(contentText, 0.5, { alpha: 0 } );
			}
			timer = new Timer(Math.random() * 5000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
			timer.start();
		}
		
		private function timeOffHandler(event: Event): void {
			this.goAway();
			//this.dispatchEvent(event);
		}
		
		private function mouseHandler(event: MouseEvent): void {
			switch (event.type) {
				case MouseEvent.ROLL_OVER:
					if (overable)	this.filters = [new ColorMatrixFilter([1,0,0,0,50,0,1,0,0,50,0,0,1,0,50,0,0,0,1,0])];
				break;
				case MouseEvent.ROLL_OUT:
					this.filters = [];
				break;
				case MouseEvent.CLICK:
					this.dispatchEvent(new Event(COW_CLICKED));
				break;
			}
		}
		
		public function goEating(): void {
			currentAction = START_EATTING;
			goAction();
			
			timingMovie.visible = false;
			bubbleMovie.visible = false;
			contentText.visible = false;
		}
		
		public function goWaitingForGrass(): void {
			currentAction = START_WAITING_FOR_GRASS;
			goAction();
			
			timingMovie.visible = true;
			timingMovie.startTiming(Math.random() * 30000 + 30000);
			
			bubbleMovie.visible = true;
			contentText.visible = true;
			contentText.text = WAITING_FOR_GRASS;
		}
		
		public function goAway(): void {
			isGoAway = true;
			currentAction = START_GO_AWAY;
			goAction();
			
			//cowMovie.gotoAndPlay(1);
			timingMovie.visible = false;
			bubbleMovie.visible = false;
			contentText.visible = false;
			
			GetMilk(parent).checkGameResult();
		}
		
		public function goWaitingForMilk(): void {
			currentAction = START_WAITING_FOR_MILK;
			goAction();
			
			timingMovie.visible = true;
			//timingMovie.gotoAndPlay(1);
			timingMovie.startTiming(Math.random() * 30000 + 30000);
			
			bubbleMovie.visible = true;
			contentText.visible = true;
			contentText.text = WAITING_FOR_MILK;
			overable = true;
		}
		
		public function goGettingMilk(): void {
			currentAction = GETTING_MILK;
			goAction();
			
			timingMovie.visible = false;
			bubbleMovie.visible = false;
			contentText.visible = false;
		}
		
		private function goAction(): void {
			this.gotoAndStop(currentAction);
		}
		
		public function mirror(): void {
			bubbleMovie.scaleX *= -1;
			contentText.scaleX *= -1;
			contentText.x += 60;
			timingMovie.scaleX *= -1;
		}
		
		public function get overable(): Boolean { return _overable; }
		
		public function set overable(value: Boolean): void {
			_overable = value;
			this.buttonMode = value;
			this.mouseEnabled = this.mouseChildren = value;
		}
	}

}