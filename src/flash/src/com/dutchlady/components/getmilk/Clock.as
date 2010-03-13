package com.dutchlady.components.getmilk {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class Clock extends MovieClip {
		public static const TIME_UP: String = "time_up";
		
		//private const CLOCK_TIME: Number = 120;	//	seconds
		
		public var contentMovie: MovieClip;
		public var totalTime: Number;
		public var timer: Timer;
		
		public function Clock() {
			contentMovie.gotoAndStop(1);
		}
		
		private function timerCompleteHandler(event: TimerEvent): void {
			contentMovie.gotoAndStop(contentMovie.currentFrame + 1);
			if (contentMovie.currentFrame < contentMovie.totalFrames) {
				timer.reset();
				timer.start();
			}
			else this.dispatchEvent(new Event(TIME_UP));
		}
		
		public function startClock(CLOCK_TIME: Number = 120): void {
			totalTime = CLOCK_TIME;
			contentMovie.gotoAndStop(1);
			timer = new Timer(CLOCK_TIME * 1000 / contentMovie.totalFrames, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			timer.start();
		}
		
		public function stopClock(): void {
			if (timer) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			}
		}
	}

}