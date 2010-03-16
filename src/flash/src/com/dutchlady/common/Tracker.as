package com.dutchlady.common {
	import flash.display.Loader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class Tracker {
		
		public function Tracker() {
			
		}
		
		public static function trackGotoUploadPage():void {
			var ebRand = Math.random()+''; 
			ebRand = ebRand * 1000000;
			var activityParams = escape('ActivityID=57079&f=1'); 
			var loader:Loader = new Loader(); 
			var url = 'HTTP://bs.serving-sys.com/BurstingPipe/activity3.swf?ebAS=bs.serving-sys.com&activityParams=' + activityParams + '&rnd=' + ebRand; 
			var request:URLRequest = new URLRequest(url); 
			try { loader.load(request); } catch (error:Error) {} 
		}
		
		public static function trackUpdateDonate():void {
			var ebRand = Math.random()+''; 
			ebRand = ebRand * 1000000; 
			var activityParams = escape('ActivityID=57078&f=1'); 
			var loader:Loader = new Loader(); 
			var url = 'HTTP://bs.serving-sys.com/BurstingPipe/activity3.swf?ebAS=bs.serving-sys.com&activityParams=' + activityParams + '&rnd=' + ebRand; 
			var request:URLRequest = new URLRequest(url); 
			try { loader.load(request); } catch (error:Error) {} 
		}
		
		public static function trackPlayGame():void {
			var ebRand = Math.random()+''; 
			ebRand = ebRand * 1000000; 
			var activityParams = escape('ActivityID=57077&f=1'); 
			var loader:Loader = new Loader(); 
			var url = 'HTTP://bs.serving-sys.com/BurstingPipe/activity3.swf?ebAS=bs.serving-sys.com&activityParams=' + activityParams + '&rnd=' + ebRand; 
			var request:URLRequest = new URLRequest(url); 
			try { loader.load(request); } catch (error:Error) {} 
		}
		
		public static function trackLandingPage():void {
			var ebRand = Math.random()+''; 
			ebRand = ebRand * 1000000; 
			var activityParams = escape('ActivityID=57076&f=1'); 
			var loader:Loader = new Loader(); 
			var url = 'HTTP://bs.serving-sys.com/BurstingPipe/activity3.swf?ebAS=bs.serving-sys.com&activityParams=' + activityParams + '&rnd=' + ebRand; 
			var request:URLRequest = new URLRequest(url); 
			try { loader.load(request); } catch (error:Error) {} 
		}
	}

}