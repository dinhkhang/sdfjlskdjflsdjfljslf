﻿package com.dutchlady.pages.iLove {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.components.heart.BigHeart;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.http.HttpServiceEvent;
	import com.dutchlady.services.AppServices;
	import fl.controls.ComboBox;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class ILove extends MovieClip {
		
		public var boardParentMovie: ILoveBoard;
		public var containerMovie: BigHeart;
		public var combox: ComboBox;
		
		private var currentPageIndex:int = 0;
		private var xml: XML;
		
		public function ILove() {			
			/*var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, xmlLoadCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(new URLRequest("xml/big_heart_service.xml"));*/
			
			boardParentMovie.visible = false;
			boardParentMovie.buttonMovie.buttonMode = true;
			boardParentMovie.buttonMovie.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			
			this.addEventListener(PageEvent.ILOVE_SEARCH, searchHandler);
			
			var service: AppServices = new AppServices(Configuration.instance.getProfileServiceUrl);
			service.addEventListener(HttpServiceEvent.RESULT, getDataResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, getDataFaultHandler);
			service.getProfile();
			
			combox.visible = false;
			combox.addEventListener(Event.CHANGE, comboxChangeHandler);
		}
		
		private function comboxChangeHandler(event: Event): void {
			var service: AppServices = new AppServices(Configuration.instance.getProfileServiceUrl);
			service.addEventListener(HttpServiceEvent.RESULT, getDataResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, getDataFaultHandler);
			currentPageIndex = combox.selectedIndex;
			service.getProfile("", 10, combox.selectedItem.data);
		}
		
		private function searchHandler(event: PageEvent): void {
			var target: ILoveBoard = event.target as ILoveBoard;
			var service: AppServices = new AppServices(Configuration.instance.getProfileServiceUrl);
			service.addEventListener(HttpServiceEvent.RESULT, getDataResultHandler);
			service.addEventListener(HttpServiceEvent.FAULT, getDataFaultHandler);
			service.getProfile(target.emailText.text);
		}
		
		private function buttonClickHandler(event: MouseEvent): void {
			boardParentMovie.buttonMovie.gotoAndStop((boardParentMovie.buttonMovie.currentFrame == 1) ? 2 : 1);
			if (boardParentMovie.currentLabel == "expand")	boardParentMovie.gotoAndPlay("collapse");
			else	boardParentMovie.gotoAndPlay("expand");
		}

		private function getDataFaultHandler(event: HttpServiceEvent): void {
			
		}
		
		private function getDataResultHandler(event: HttpServiceEvent): void {
			xml = new XML(String(event.result));
			containerMovie.setData(xml);
			var ns: Namespace = xml.namespace();
			var numPage: int;
			numPage = Math.ceil(int(xml.ns::string[0].toString()) / 10);
			if (numPage) {
				combox.removeAll();
				for (var i: int = 1; i <= numPage; i++) {
					trace( "Add Item i : " + i );
					combox.addItem( {label: i.toString(), data: i} );
				}
				combox.selectedIndex = currentPageIndex;
			}
		}
		
		private function xmlLoadCompleteHandler(event: Event): void {
			xml = XML(event.currentTarget.data);
			containerMovie.setData(xml);
		}
		
		private function ioErrorHandler(event: IOErrorEvent): void {
			
		}
		override public function get x(): Number { return super.x; }
		
		override public function set x(value: Number): void {
			super.x = value;
			//orderBoard();
		}
		override public function get y(): Number { return super.y; }
		
		override public function set y(value: Number): void {
			super.y = value;
			//orderBoard();
		}
	}

}