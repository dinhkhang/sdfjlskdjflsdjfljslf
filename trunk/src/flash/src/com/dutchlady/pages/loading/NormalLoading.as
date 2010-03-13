package com.dutchlady.pages.loading {
	import com.dutchlady.events.PageEvent;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class NormalLoading extends BaseLoading {
		
		public function NormalLoading() {
			
		}
		
		override public function get percent(): int { return super.percent; }
		
		override public function set percent(value: int): void {
			super.percent = value;
			loadingMovie.processText.visible = false;
			if (value == 100)	this.dispatchEvent(new PageEvent(PageEvent.PAGE_LOADING_COMPLETE));
		}
	}

}