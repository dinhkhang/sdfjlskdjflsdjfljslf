package com.dutchlady.components.getmilk {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import gs.TweenLite;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class DutchLady extends MovieClip {
		public static var LEVEL0_POINT_LEFT: Point = new Point(25.0, 285.0);
		public static var LEVEL1_POINT_LEFT: Point = new Point(25.0, 370.0);
		public static var LEVEL2_POINT_LEFT: Point = new Point(25.0, 480.0);
		public static var LEVEL0_POINT_RIGHT: Point = new Point(967.0, 285.0);
		public static var LEVEL1_POINT_RIGHT: Point = new Point(967.0, 370.0);
		public static var LEVEL2_POINT_RIGHT: Point = new Point(967.0, 480.0);
		
		// events
		public static const ACTION_COMPLETE: String = "action_complete";
		
		public const delta: Number = 15;
		public const LEFT_TO_RIGHT: String = "left to right";
		public const LEFT_TO_RIGHT_DROP: String = "left to right drop";
		public const LEFT_TO_RIGHT_GET: String = "left to right get";
		public const RIGHT_TO_LEFT: String = "right to left";
		public const RIGHT_TO_LEFT_DROP: String = "right to left drop";
		public const RIGHT_TO_LEFT_GET: String = "right to left get";
		public const UP_TO_DOWN: String = "up to down";
		public const DOWN_TO_UP: String = "down to up";
		public const NORMAL_RIGHT: String = "normal right";
		public const NORMAL_LEFT: String = "normal left";
		private const DELAY: int = 60;
		
		public var getMovie: MovieClip;
		public var dropMovie: MovieClip;
		
		private var timer: Timer;
		private var currentAction: String;
		private var deltaX: Number = 0;
		private var deltaY: Number = 0;
		private var currentLevel: int = 1;		
		private var targetPoint: Point;		
		private var smartTargetPoint: Point;		
		
		public function DutchLady() {
			timer = new Timer(DELAY, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			
			targetPoint = new Point(this.x, this.y);
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		private function timerCompleteHandler(event: TimerEvent): void {
			if (this.currentLabel != currentAction)	this.gotoAndStop(currentAction);
			else this.gotoAndStop(this.currentFrame + 1);
			if (this.currentLabel != currentAction)	this.gotoAndStop(currentAction);
			var hDelta: Number = Math.round(targetPoint.x - this.x);
			var vDelta: Number = Math.round(targetPoint.y - this.y);
			if (hDelta == 0 && vDelta == 0) {
				if (!smartTargetPoint || targetPoint.equals(smartTargetPoint)) {
					this.dispatchEvent(new Event(ACTION_COMPLETE));
					stopAction();
				}
				else {					
					smartWalkTo(smartTargetPoint);
				}
			}
			else {
				var newX: Number = this.x + Math.min(Math.abs(hDelta), delta) * ((hDelta > 0) ? 1 : -1);
				var newY: Number = this.y + Math.min(Math.abs(vDelta), delta) * ((vDelta > 0) ? 1 : -1);
				
				//TweenLite.to(this, (DELAY)/ 1000, {x: newX, y: newY});
				this.x = Math.round(newX);
				this.y = Math.round(newY);
				
				timer.reset();
				timer.start();
			}
		}
		
		public function startAction(action: String): void {
			currentAction = action;
			timer.start();
		}
		
		public function stopAction(): void {
			timer.reset();
			this.stop();
		}
		
		public function goLevel(level: int): void {		//	0: away	1: normal	2: close
			var scale: Number = 1;
			if (level == 0)	scale = 0.85;
			if (level == 2)	scale = 1.1;
			TweenLite.to(this, Math.abs(level - currentLevel), { scaleX: scale, scaleY: scale } );
			currentLevel = level;
		}

		public function walkTo(point: Point): void {
			targetPoint = point;			
			var hDelta: Number = point.x - this.x;
			var vDelta: Number = point.y - this.y;
			var isH: Boolean = (Math.abs(hDelta) > Math.abs(vDelta));
			if (isH) {
				if (hDelta > 0)	{	//	to RIGHT
					startAction(LEFT_TO_RIGHT);
				}
				else startAction(RIGHT_TO_LEFT);
			}
			else {
				if (vDelta > 0)	{	//	to DOWN
					startAction(UP_TO_DOWN);
				}
				else startAction(DOWN_TO_UP);
			}			
		}
		
		public function smartWalkTo(point: Point): void {
			stopAction();
			smartTargetPoint = point;
			optimizeRoad();
		}
		
		private function optimizeRoad(): void {
			if (smartTargetPoint.y == this.y) {	//	are same level
				walkTo(smartTargetPoint);
			}
			else {	// are NOT same level
				//	check the y-pos
				if (smartTargetPoint.y == this.y) {	// in the same level (line)
					walkTo(new Point(smartTargetPoint.x, this.y));
				}
				else {	// NOT in the same level (line)
					//	check if lady is on the edge
					if (this.x == LEVEL1_POINT_LEFT.x || this.x == LEVEL1_POINT_RIGHT.x) {	//	lady is on the edge
						walkTo(new Point(this.x, smartTargetPoint.y));
					}
					else {	//	lady is NOT on the edge	
						// go to LEFT or RIGHT edge ?
						if (this.x > (LEVEL1_POINT_RIGHT.x - LEVEL1_POINT_LEFT.x) / 2 + 50) {	//	should go to right
							walkTo(new Point(LEVEL1_POINT_RIGHT.x, this.y));
						}
						else {
							walkTo(new Point(LEVEL1_POINT_LEFT.x, this.y));
						}
					}
				}				
			}
		}
	}

}