package com.dutchlady.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class PageEvent extends Event {
		//	pages
		public static const GO_TO_HOMEPAGE: String = "go_to_homepage";
		public static const GO_TO_ILOVEPAGE: String = "go_to_ilovepage";
		public static const GO_TO_STORYPAGE: String = "go_to_storypage";
		public static const GO_TO_TOURPAGE: String = "go_to_tourpage";
		public static const GO_TO_SHAREPAGE: String = "go_to_sharepage";
		public static const GO_TO_GETMILKPAGE: String = "go_to_getmilkpage";
		public static const GO_TO_FACTORYPAGE: String = "go_to_factorypage";
		public static const GO_TO_UPLOADPAGE: String = "go_to_uploadpage";
		
		// Milk box
		public static const SHOW_HEART_POPUP: String = "showHeartPopup";
		public static const SHOW_SHARE_POPUP: String = "showSharePopup";
		public static const SHOW_STORY_POPUP: String = "showStoryPopup";
		public static const SHOW_TOUR_POPUP: String = "showTourPopup";
		
		// Pop Up
		public static const POPUP_CLOSE: String = "popup_close";
		
		// Pages
		public static const STAR_BEGIN_PAGE: String = "star_begin_page";
		public static const COMPLETE_BEGIN_PAGE: String = "complete_begin_page";
		public static const START_END_PAGE: String = "start_end_page";
		public static const COMPLETE_END_PAGE: String = "complete_end_page";
		
		// Mouse Cursors
		public static const CURSOR_NORMAL: String = "cursor_normal";
		public static const CURSOR_BUSY: String = "cursor_busy";
		public static const CURSOR_SPAN: String = "cursor_span";
		public static const CURSOR_ROTATE_LEFT: String = "cursor_rotate_left";
		public static const CURSOR_ROTATE_RIGHT: String = "cursor_rotate_right";
		public static const CURSOR_NULL: String = "cursor_null";
		
		// Heart event
		public static const ILOVE_SEARCH: String = "ilove_search";
		
		public static const PAGE_LOADING_COMPLETE: String = "page_loading_complete";
		
		public function PageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new PageEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("PageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}