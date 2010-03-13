package com.dutchlady.components.getmilk {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class GrassCow extends MovieClip {		
		private const RANDOM_UP: int = 5;
		private const RANDOM_DOWN: int = 3;
		private var timer: Timer;
		
		public var cowMovie: Cow;
		public var troughMovie: Trough;
		
		public function GrassCow(cowMovie: Cow, troughMovie: Trough) {
			this.cowMovie = cowMovie;
			this.troughMovie = troughMovie;			
			init();
		}
		
		private function init():void {
			timer = new Timer((Math.random() * Math.abs(RANDOM_UP - RANDOM_DOWN) + Math.min(RANDOM_UP, RANDOM_DOWN)) * 1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			
			troughMovie.addEventListener(Trough.TROUGH_FULL, troughEventHandler);
			troughMovie.addEventListener(Trough.TROUGH_EMPTY, troughEventHandler);
			
			cowMovie.addEventListener(CowTiming.TIME_OFF, timeOffHandler);
			cowMovie.goWaitingForGrass();
		}
		
		private function timeOffHandler(event: Event): void {
			cowMovie.overable = false;
			troughMovie.overable = false;
			troughMovie.isGoAway = true;
		}
		
		private function troughEventHandler(event: Event): void {
			switch (event.type) {
				case Trough.TROUGH_FULL:
					startEatGrass();
				break;
				case Trough.TROUGH_EMPTY:
					stopEatGrass();
				break;
			}			
		}
		
		private function timerCompleteHandler(event: TimerEvent): void {
			troughMovie.goNextLevel();
			timer.reset();
			timer.start();
		}
		
		public function startEatGrass(): void {
			timer.start();
			cowMovie.goEating();
			troughMovie.overable = false;			
		}
		
		public function stopEatGrass(): void {
			timer.reset();
			cowMovie.goWaitingForMilk();
			cowMovie.overable = true;
		}
		
		public function reset(): void {
			//troughMovie.grassMovie.gotoAndStop(troughMovie.grassMovie.totalFrames);
			timer.reset();
			troughMovie.reset();
			cowMovie.reset();
		}
	}

}