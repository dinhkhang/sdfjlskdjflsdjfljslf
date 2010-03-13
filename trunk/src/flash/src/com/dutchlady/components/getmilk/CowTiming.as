package com.dutchlady.components.getmilk {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class CowTiming extends MovieClip {
		// events
		public static const TIME_OFF: String = "time_off";
		//
		
		private var timer: Timer;
		
		public function CowTiming() {
			
		}
		
		public function startTiming(delay: Number): void {	//	delay in miliseconds			
			if (timer) {
				timer.stop();
			}
			this.gotoAndStop(1);
			timer = new Timer(delay / this.totalFrames, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
			timer.start();			
		}
		
		private function timerCompleteHandler(event: TimerEvent): void {
			this.gotoAndStop(this.currentFrame + 1);
			if (this.currentFrame < this.totalFrames) {
				timer.reset();
				timer.start();
			}
			else this.dispatchEvent(new Event(TIME_OFF, true));
		}
		
		override public function get visible(): Boolean { return super.visible; }
		
		override public function set visible(value: Boolean): void {
			super.visible = value;
			if (!value)	timer.stop();
		}
	}

}