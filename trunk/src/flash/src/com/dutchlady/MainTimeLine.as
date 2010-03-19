package com.dutchlady {
	import com.dutchlady.common.Configuration;
	import com.dutchlady.common.GlobalVars;
	import com.dutchlady.common.Tracker;
	import com.dutchlady.components.Popup;
	import com.dutchlady.events.PageEvent;
	import com.dutchlady.pages.BasePage;
	import com.dutchlady.pages.homepage.HomePage;
	import com.dutchlady.pages.loading.BaseLoading;
	import com.dutchlady.pages.loading.Game1Loading;
	import com.dutchlady.pages.loading.NormalLoading;
	import com.dutchlady.services.AppServices;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	import gs.easing.Strong;
	import gs.TweenLite;
	import swfaddress.SWFAddress;
	import swfaddress.SWFAddressEvent;
	/**
	 * ...
	 * @author ... Mr. Coder
	 */
	public class MainTimeLine extends MovieClip {
		private const DEFAUL_CONFIG_XML_PATH: String = "xml/flashconfig.xml";
		private const BEGINNING: String = "beginning";
		private const LOADING_GAME1: String = "loading_game1";
		// DEEP LINK
		private const HOMEPAGE: String = "nong-trai";
		private const ILOVEPAGE: String = "toi-yeu";
		private const STORYPAGE: String = "chuan-muc";
		private const TOURPAGE: String = "hanh-trinh";
		private const SHAREPAGE: String = "chia-se";
		private const UPLOADPAGE: String = "upload-photo";
		private const GAME1PAGE: String = "game-nong-trai";
		private const GAME2PAGE: String = "game-nha-may";
		//
		private var xml: XML;
		private var currentPageName: String;
		private var newPageName: String;
		private var currentPageMovie: BasePage;
		private var homePageMovie: BasePage;
		private var currentPopUp: Popup;
		private var pageMovieArray: Array;			//	array contains child-pages (loader).
		
		public var pageContainerMovie: MovieClip;	//	Container of pages.
		public var cursorMovie: MovieClip;		
		public var loadingGame1Movie: Game1Loading;
		public var loadingGame2Movie: Game1Loading;
		public var normalLoading: NormalLoading;
		public var loadingMovie: BaseLoading;
		public var menuMovie: MovieClip;
		public var zoomInBoxFaceHolder: Sprite;
		
		private var siteParam: String;
		
		public function MainTimeLine() {
			this.visible = false;
			
			Security.loadPolicyFile("http://www.toiyeucogaihalan.com/crossdomain.xml");
			
			Tracker.trackLandingPage();
			
			//GlobalVars.mainTimeLine = this;
			initEvents();
		}
		
		private function initEvents():void {
			this.addEventListener(PageEvent.GO_TO_HOMEPAGE, goToPageHandler);
			this.addEventListener(PageEvent.GO_TO_ILOVEPAGE, goToPageHandler);
			this.addEventListener(PageEvent.GO_TO_STORYPAGE, goToPageHandler);
			this.addEventListener(PageEvent.GO_TO_TOURPAGE, goToPageHandler);
			this.addEventListener(PageEvent.GO_TO_SHAREPAGE, goToPageHandler);
			this.addEventListener(PageEvent.GO_TO_GETMILKPAGE, goToPageHandler);
			this.addEventListener(PageEvent.GO_TO_FACTORYPAGE, goToPageHandler);
			this.addEventListener(PageEvent.GO_TO_UPLOADPAGE, goToPageHandler);
			
			// milk box
			this.addEventListener(PageEvent.SHOW_HEART_POPUP, goToPageHandler);
			this.addEventListener(PageEvent.SHOW_SHARE_POPUP, goToPageHandler);
			this.addEventListener(PageEvent.SHOW_STORY_POPUP, goToPageHandler);
			this.addEventListener(PageEvent.SHOW_TOUR_POPUP, goToPageHandler);

			normalLoading.addEventListener(PageEvent.PAGE_LOADING_COMPLETE, normalLoadCompleteHandler);
			loadingGame1Movie.addEventListener(PageEvent.PAGE_LOADING_COMPLETE, game1LoadCompleteHandler);
			loadingGame2Movie.addEventListener(PageEvent.PAGE_LOADING_COMPLETE, game1LoadCompleteHandler);
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			SWFAddress.addEventListener(SWFAddressEvent.INIT, initSWFAddressHandler);
		}
		
		private function addedToStageHandler(event: Event): void {
			init();
			zoomInBoxFaceHolder = new Sprite();
			addChild(zoomInBoxFaceHolder);
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			menuMovie.bgMovie.width = stage.stageWidth;
			stage.stageFocusRect = false;
			cursorMovie = new MouseCursor();
			cursorMovie.mouseChildren = cursorMovie.mouseEnabled = false;
			stage.addChild(cursorMovie);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.stage.addEventListener(PageEvent.CURSOR_NORMAL, cursorEventHandler);
			this.stage.addEventListener(PageEvent.CURSOR_BUSY, cursorEventHandler);
			this.stage.addEventListener(PageEvent.CURSOR_SPAN, cursorEventHandler);
			this.stage.addEventListener(PageEvent.CURSOR_ROTATE_LEFT, cursorEventHandler);
			this.stage.addEventListener(PageEvent.CURSOR_ROTATE_RIGHT, cursorEventHandler);
			this.stage.addEventListener(PageEvent.CURSOR_NULL, cursorEventHandler);
		}
		
		private function resizeHandler(event: Event): void {
			trace("stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);  
			GlobalVars.windowsWidth = Math.min(stage.stageWidth, 1280);
			GlobalVars.windowsHeight = Math.min(stage.stageHeight, 1024);
			//if (GlobalVars.windowsHeight > GlobalVars.movieHeight)	this.y = (GlobalVars.windowsHeight - GlobalVars.movieHeight)/2;
			//else this.y = 0;			
			
			var oldX: Number;
			var oldY: Number;
			// resize menu
			menuMovie.bgMovie.width = GlobalVars.windowsWidth;
			menuMovie.y = (GlobalVars.movieHeight - GlobalVars.windowsHeight) / 2 + 20 - this.y;
			
			if (homePageMovie)		homePageMovie.resize();
			if (currentPageMovie)	currentPageMovie.resize();
			if (currentPopUp)		currentPopUp.resize();
			
			//	resize loading(s)
			loadingGame1Movie.boardMovie.y = menuMovie.y + menuMovie.height;
			loadingGame1Movie.loadingMovie.y = loadingGame1Movie.boardMovie.y + loadingGame1Movie.boardMovie.height + 20;
			loadingGame2Movie.boardMovie.y = menuMovie.y + menuMovie.height; 
			loadingGame2Movie.loadingMovie.y = loadingGame2Movie.boardMovie.y + loadingGame2Movie.boardMovie.height + 20;
			
			//TEST
			//GlobalVars.windowsWidth = GlobalVars.movieWidth;
			//GlobalVars.windowsHeight = GlobalVars.movieHeight;
		}
		
		private function cursorEventHandler(event: PageEvent): void {
			cursorMovie.gotoAndStop(event.type);
		}
		
		private function enterFrameHandler(event: Event): void {
			cursorMovie.x = this.mouseX;
			cursorMovie.y = this.mouseY;
			this.setChildIndex(menuMovie, this.numChildren - 1);
			this.stage.setChildIndex(cursorMovie, this.stage.numChildren - 1);
			Mouse.hide();
		}
		
		private function initSWFAddressHandler(event: SWFAddressEvent): void {
			
		}
		
		private function addressChangeHandler(event: SWFAddressEvent): void {
			goToDeepLink(event.value.split("/")[1]);
		}
		
		private function goToDeepLink(value: String) : void {
			trace( "value : " + value );
			switch (value) {
				case HOMEPAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_HOMEPAGE));
				break;
				case ILOVEPAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_ILOVEPAGE));
				break;
				case STORYPAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_STORYPAGE));
				break;
				case TOURPAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_TOURPAGE));
				break;
				case SHAREPAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_SHAREPAGE));
				break;
				case GAME1PAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_GETMILKPAGE));
				break;
				case GAME2PAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_FACTORYPAGE));
				break;
				case UPLOADPAGE:
					this.dispatchEvent(new PageEvent(PageEvent.GO_TO_UPLOADPAGE));
				break;
			}
		}
		
		private function normalLoadCompleteHandler(event: PageEvent): void {
			hideMovieClip(normalLoading);
			setTimeout(function() {if (currentPageMovie) currentPageMovie.startBeginPage(); }, 200);
		}
		
		private function game1LoadCompleteHandler(event: PageEvent): void {
			hideMovieClip(loadingMovie);
			setTimeout(function() {if (currentPageMovie) currentPageMovie.startBeginPage(); }, 200);
			trace( "game1LoadCompleteHandler : " + currentPageMovie );
			homePageMovie.x = -homePageMovie.width;
		}
		
		private function updateDonate(functionName: String):void {
			var service: AppServices = new AppServices(Configuration.instance.updateDonateServiceUrl);
			service.updateDonate(functionName);
			
			Tracker.trackUpdateDonate();
		}
		
		private function showUploadedImage():void {
			var bitmapData: BitmapData = GlobalVars.capturedImage;
			
			GlobalVars.capturedImage = null;
			
			//bitmapData = new BitmapData(495, 570, true, 0xFFFFFF);
			//bitmapData.draw(this);
			if (!bitmapData) return;
			
			var bitmap: Bitmap = new Bitmap(bitmapData);
			bitmap.x = GlobalVars.windowsWidth / 2 - bitmap.width / 2 + 50;
			bitmap.y = GlobalVars.windowsHeight / 2 - bitmap.height / 2 + 50;
			this.addChild(bitmap);
			
			TweenLite.to(bitmap, 2.5, { scaleX: 0.05, scaleY: 0.05, onUpdate: showUploadedImageUpdateHanlder, onUpdateParams:[bitmap], onComplete: showUploadedImageCompleteHanlder, onCompleteParams: [bitmap] } );
		}
		
		private function showUploadedImageUpdateHanlder(bitmap: Bitmap):void {
			bitmap.x = GlobalVars.windowsWidth / 2 - bitmap.width / 2 + 50;
			bitmap.y = GlobalVars.windowsHeight / 2 - bitmap.height / 2 + 50;
		}
		
		private function showUploadedImageCompleteHanlder(bitmap: Bitmap):void {
			this.removeChild(bitmap);
		}
		
		private function goToPageHandler(event: PageEvent): void {
			if (currentPopUp)	currentPopUp.zoomOutButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			if (loadingMovie)	loadingMovie.visible = false;
			loadingMovie = normalLoading;
			homePageMovie.mouseCheckingMode = false;
			homePageMovie.x = 0;
			switch (event.type) {
				case PageEvent.GO_TO_HOMEPAGE:
					if (currentPageMovie) {
						if (currentPageMovie != homePageMovie) {
							currentPageMovie.startEndPage();
							pageContainerMovie.removeChild(currentPageMovie);
						}
					}
					currentPageMovie = homePageMovie;
					trace( "GO_TO_HOMEPAGE : " + currentPageMovie );
					pageContainerMovie.setChildIndex(homePageMovie, pageContainerMovie.numChildren - 1);
					homePageMovie.visible = true;
					homePageMovie.mouseCheckingMode = true;
					//selectedMenuItem(menuMovie.farmMovie);
					break;
				///////////////////////////////// POP UP ////////////////////////////
				case PageEvent.GO_TO_ILOVEPAGE:
				trace( "PageEvent.GO_TO_ILOVEPAGE: : " + PageEvent.GO_TO_ILOVEPAGE );
					HomePage(homePageMovie).milkBox.navigateToHeartFace();
					showUploadedImage();
					//break;
				case PageEvent.SHOW_HEART_POPUP:
					SWFAddress.setValue(HOMEPAGE);
					setTimeout(loadPopUp, 1000, "iLove");
					// Update donate
					updateDonate("I-Love-Dutch-Lady");
					break;
				
				case PageEvent.GO_TO_STORYPAGE:
				trace( "PageEvent.GO_TO_STORYPAGE : " + PageEvent.GO_TO_STORYPAGE );
					HomePage(homePageMovie).milkBox.navigateToStoryFace();
					//break;
				case PageEvent.SHOW_STORY_POPUP:
					SWFAddress.setValue(HOMEPAGE);
					setTimeout(loadPopUp,1000,"story");
					break;
				
				case PageEvent.GO_TO_TOURPAGE:
				trace( "PageEvent.GO_TO_TOURPAGE : " + PageEvent.GO_TO_TOURPAGE );
					HomePage(homePageMovie).milkBox.navigateToTourFace();
					//break;
				case PageEvent.SHOW_TOUR_POPUP:
					SWFAddress.setValue(HOMEPAGE);
					setTimeout(loadPopUp,1000,"tour");
					break;
				
				case PageEvent.GO_TO_SHAREPAGE:
				trace( "PageEvent.GO_TO_SHAREPAGE : " + PageEvent.GO_TO_SHAREPAGE );
					HomePage(homePageMovie).milkBox.navigateToShareFace();
					//break;
				case PageEvent.SHOW_SHARE_POPUP:
					SWFAddress.setValue(HOMEPAGE);
					setTimeout(loadPopUp,1000,"share");
					break;
				//////////////////////////////////////////////////////////////////////
				case PageEvent.GO_TO_GETMILKPAGE:
					Tracker.trackPlayGame();
				
					this.setChildIndex(loadingGame1Movie, this.numChildren - 2);
					loadingMovie = loadingGame1Movie;
					loadPage("getMilk");
					//selectedMenuItem();
					break;
				case PageEvent.GO_TO_FACTORYPAGE:
					Tracker.trackPlayGame();
				
					this.setChildIndex(loadingGame2Movie, this.numChildren - 2);
					loadingMovie = loadingGame2Movie;
					loadPage("factory");
					//selectedMenuItem();
					break;
				case PageEvent.GO_TO_UPLOADPAGE:
					Tracker.trackGotoUploadPage();
					loadPage("upload");
					//selectedMenuItem(menuMovie.uploadMovie);
					break;
				default:
					break;
			}
			if (event.type == PageEvent.GO_TO_GETMILKPAGE ||
				event.type == PageEvent.GO_TO_FACTORYPAGE ||
				event.type == PageEvent.GO_TO_UPLOADPAGE)		activeLoading(loadingMovie);
		}
		
		private function createMenu(): void {
			menuMovie.visible = true;
			menuMovie.uploadMovie.visible = false;
			menuMovie.logoMovie.visible = false;
			
			menuMovie.logoMovie.addEventListener(MouseEvent.ROLL_OVER, menuButtonRollHandler);
			menuMovie.logoMovie.addEventListener(MouseEvent.ROLL_OUT, menuButtonRollHandler);
			menuMovie.logoMovie.addEventListener(MouseEvent.CLICK, farmButtonClickHandler);
			menuMovie.farmMovie.addEventListener(MouseEvent.ROLL_OVER, menuButtonRollHandler);
			menuMovie.farmMovie.addEventListener(MouseEvent.ROLL_OUT, menuButtonRollHandler);
			menuMovie.farmMovie.addEventListener(MouseEvent.CLICK, farmButtonClickHandler);
			
			menuMovie.iLoveMovie.addEventListener(MouseEvent.ROLL_OVER, menuButtonRollHandler);
			menuMovie.iLoveMovie.addEventListener(MouseEvent.ROLL_OUT, menuButtonRollHandler);
			menuMovie.iLoveMovie.addEventListener(MouseEvent.CLICK, iLoveButtonClickHandler);
			
			menuMovie.storyMovie.addEventListener(MouseEvent.ROLL_OVER, menuButtonRollHandler);
			menuMovie.storyMovie.addEventListener(MouseEvent.ROLL_OUT, menuButtonRollHandler);
			menuMovie.storyMovie.addEventListener(MouseEvent.CLICK, storyButtonClickHandler);
			
			menuMovie.tourMovie.addEventListener(MouseEvent.ROLL_OVER, menuButtonRollHandler);
			menuMovie.tourMovie.addEventListener(MouseEvent.ROLL_OUT, menuButtonRollHandler);
			menuMovie.tourMovie.addEventListener(MouseEvent.CLICK, tourButtonClickHandler);
			
			menuMovie.shareMovie.addEventListener(MouseEvent.ROLL_OVER, menuButtonRollHandler);
			menuMovie.shareMovie.addEventListener(MouseEvent.ROLL_OUT, menuButtonRollHandler);
			menuMovie.shareMovie.addEventListener(MouseEvent.CLICK, shareButtonClickHandler);
			
			menuMovie.uploadMovie.addEventListener(MouseEvent.ROLL_OVER, menuButtonRollHandler);
			menuMovie.uploadMovie.addEventListener(MouseEvent.ROLL_OUT, menuButtonRollHandler);
			menuMovie.uploadMovie.addEventListener(MouseEvent.CLICK, uploadButtonClickHandler);
		}
		
		private function menuButtonRollHandler(event: MouseEvent): void {
			event.currentTarget.gotoAndStop((event.type == MouseEvent.ROLL_OVER) ? 2 : 1);
		}
		
		private function uploadButtonClickHandler(event: MouseEvent): void {
			//this.dispatchEvent(new PageEvent(PageEvent.GO_TO_UPLOADPAGE));
			SWFAddress.setValue(UPLOADPAGE);
		}
		
		private function farmButtonClickHandler(event: MouseEvent): void {
			//this.dispatchEvent(new PageEvent(PageEvent.GO_TO_HOMEPAGE));
			if (currentPopUp)	currentPopUp.zoomOutButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			SWFAddress.setValue(HOMEPAGE);
		}
		
		private function iLoveButtonClickHandler(event: MouseEvent): void {
			this.dispatchEvent(new PageEvent(PageEvent.GO_TO_ILOVEPAGE));
			//SWFAddress.setValue(ILOVEPAGE);
		}
		
		private function storyButtonClickHandler(event: MouseEvent): void {
			this.dispatchEvent(new PageEvent(PageEvent.GO_TO_STORYPAGE));
			//SWFAddress.setValue(STORYPAGE);
		}
		
		private function tourButtonClickHandler(event: MouseEvent): void {
			this.dispatchEvent(new PageEvent(PageEvent.GO_TO_TOURPAGE));
			//SWFAddress.setValue(TOURPAGE);
		}
		
		private function shareButtonClickHandler(event: MouseEvent): void {
			this.dispatchEvent(new PageEvent(PageEvent.GO_TO_SHAREPAGE));
			//SWFAddress.setValue(SHAREPAGE);
		}
		
		private function init():void {
			this.mouseEnabled = this.mouseChildren = false;
			Mouse.hide();
			menuMovie.visible = false;
			pageMovieArray = new Array();
			
			activeLoading();
			
			GlobalVars.windowsWidth = GlobalVars.movieWidth;
			GlobalVars.windowsHeight = GlobalVars.movieHeight;
			
			// Use flashVars: xmlPath = "......"
			// If not exist, use default flashconfig.xml
			var url: String = String(this.loaderInfo.parameters["xmlPath"]);
			if (!url || url == "undefined")	url = DEFAUL_CONFIG_XML_PATH;
			
			loadXML(url);
			
			//selectedMenuItem(menuMovie.farmMovie);			
		}
		
		private function loadXML(url: String):void {
			trace( "url : " + url );
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadXMLCompleteHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(new URLRequest(url));
		}
		
		private function loadXMLCompleteHandler(event: Event): void {
			try {
				xml = new XML (event.currentTarget.data);
			} catch (e: Error) {
				trace("Invalid XML data:\n" + event.currentTarget.data);
			}
			if (xml) {
				Configuration.instance.configXml = xml;
				loadHomePage();
			}
		}
		
		private function loadPage(name: String):void {
			newPageName = name;
			trace( "newPageName : " + newPageName );			
			//if (pageMovieArray[newPageName]) {	
				//pageMovieArray[currentPageName].startEndPage();
			//}
			//else {
				var loader: Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgessHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				//loader.name = index;
				loader.load(new URLRequest(xml.pages.page.(@name == name).toString()));
				trace( "loader.loaderInfo.url : " + xml.pages.page.(@name == name).toString() );
				//if (currentPageMovie)	currentPageMovie.visible = false;
			//}
		}
		
		private function loadPopUp(name: String):void {
			TweenLite.to(homePageMovie, 1.5, { scaleX: 4, scaleY: 4,
											x: (GlobalVars.windowsWidth - homePageMovie.pageWidth*3 - 200) / 2 - 680,
											y: (GlobalVars.windowsHeight - homePageMovie.pageHeight*3 + 300) / 2 - 200,
											ease: Strong.easeOut, onUpdate: updateHandler, onComplete: function() {
					var loader: Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, popupCompleteHandler);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgessHandler);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					loader.load(new URLRequest(xml.pages.page.(@name == name).toString()));
					homePageMovie.mouseCheckingMode = false;
					activeLoading(loadingMovie);
				} } );
		}
		
		private function updateHandler():void {
			//	...
		}
		
		private function popupCompleteHandler(event: Event): void {
			var popup: Popup = new Popup(event.currentTarget.loader.content);
			pageContainerMovie.addChild(popup);
			popup.addEventListener(PageEvent.POPUP_CLOSE, popupCloseHandler);
			popup.resize();
			currentPopUp = popup;
			this.stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function popupCloseHandler(event: PageEvent): void {
			pageContainerMovie.removeChild(event.currentTarget as Popup);
			currentPopUp = null;
			currentPageMovie = homePageMovie;
			
			if (SWFAddress.getValue().split("/")[1] == HOMEPAGE) {
				pageContainerMovie.setChildIndex(homePageMovie, pageContainerMovie.numChildren - 1);
				homePageMovie.scaleX = homePageMovie.scaleY = 4;
				homePageMovie.x = (GlobalVars.windowsWidth - homePageMovie.pageWidth * 3 - 200) / 2 - 680;
				homePageMovie.y = (GlobalVars.windowsHeight - homePageMovie.pageHeight*3 + 300) / 2 - 200,
				TweenLite.to(homePageMovie, 1.5, { scaleX: 1, scaleY: 1, x: 0, y:0, alpha:1, ease: Strong.easeOut } );
				homePageMovie.mouseCheckingMode = true;	
			}
			else {
				homePageMovie.scaleX = homePageMovie.scaleY = 1;
				//homePageMovie.x = 0;
				homePageMovie.y = 0;
				homePageMovie.x = -homePageMovie.width;
				homePageMovie.mouseCheckingMode = false;	
			}
			homePageMovie.alpha = 1;
			homePageMovie.visible = true;
		}
		
		public function loadHomePage(): void {
			loadingMovie = normalLoading;
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, homepageCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgessHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest(xml.pages.page.(@name == "farm").toString()));
		}
		
		private function homepageCompleteHandler(event: Event): void {
			homePageMovie = event.currentTarget.loader.content as BasePage;
			homePageMovie.addEventListener(Event.COMPLETE, homepageEventHandler);
			homePageMovie.addEventListener(PageEvent.STAR_BEGIN_PAGE, pageEventHandler);
			homePageMovie.addEventListener(PageEvent.COMPLETE_BEGIN_PAGE, pageEventHandler);
			homePageMovie.addEventListener(PageEvent.START_END_PAGE, pageEventHandler);
			homePageMovie.addEventListener(PageEvent.COMPLETE_END_PAGE, pageEventHandler);
			
			trace( "homePageMovie : " + homePageMovie );
			pageMovieArray["farm"] = homePageMovie;
			pageContainerMovie.addChild(homePageMovie);
			homePageMovie.visible = true;
			currentPageMovie = homePageMovie;
			createMenu();
			this.stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function homepageEventHandler(event: Event): void {
			this.visible = true;
			homePageMovie.removeEventListener(Event.COMPLETE, homepageEventHandler);
			this.mouseEnabled = this.mouseChildren = true;
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, addressChangeHandler);
		}
		
		private function loaderProgessHandler(event: ProgressEvent): void {			
			var percent: int = Math.round(event.bytesLoaded * 100 / event.bytesTotal);
			//	...
			if (loadingMovie)	{
				loadingMovie.visible = true;
				this.setChildIndex(loadingMovie, this.numChildren - 2);
				loadingMovie.percent = percent;
			}
			//trace( "loadingMovie.percent : " + loadingMovie.percent );
		}
		
		private function loaderCompleteHandler(event: Event): void {
			trace( "MainTimeLine.loaderCompleteHandler >>>>>>>>>>>>>>>>>>>>>>>>>>>>> " );
			var loader: Loader = event.currentTarget.loader;			
			var page: BasePage = loader.content as BasePage;
			trace( "loader.content : " + loader.content );
			trace( "page : " + page );
			if (!page)	return;
			page.addEventListener(PageEvent.STAR_BEGIN_PAGE, pageEventHandler);
			page.addEventListener(PageEvent.COMPLETE_BEGIN_PAGE, pageEventHandler);
			page.addEventListener(PageEvent.START_END_PAGE, pageEventHandler);
			page.addEventListener(PageEvent.COMPLETE_END_PAGE, pageEventHandler);
			//pageMovieArray.push(page);
			pageMovieArray[newPageName] = page;
			trace( "loader.name : " + loader.name );
			page.resize();
			if (currentPageMovie) {
				trace( "Start end page : " + currentPageMovie );
				currentPageMovie.startEndPage();			
			}
			else {
				pageContainerMovie.addChild(page);
				//page.startBeginPage();
				currentPageName = newPageName;
				currentPageMovie = page;
				trace( "currentPageMovie NULL before: " + currentPageMovie );
			}
		}
		
		private function pageEventHandler(event: PageEvent): void {
			var page: BasePage;
			switch (event.type) {
				case PageEvent.STAR_BEGIN_PAGE:
				break;
				case PageEvent.COMPLETE_BEGIN_PAGE:
					trace("COMPLETE_BEGIN_PAGE ********************* " + currentPageMovie);
					/*if (newPageName == "farm" && siteParam != null && siteParam != "/" && siteParam != "/nong-trai/") {
						setTimeout(SWFAddress.setValue, 2000, siteParam.split("/")[1]);
						siteParam = null;
					}*/
				break;
				case PageEvent.START_END_PAGE:
				break;
				case PageEvent.COMPLETE_END_PAGE:
					if (currentPageMovie) {
						if (currentPageMovie != homePageMovie)	pageContainerMovie.removeChild(currentPageMovie);
						else homePageMovie.x = -homePageMovie.width;
					}
					page = pageMovieArray[newPageName];
					if (pageContainerMovie.contains(page)) {
						pageContainerMovie.setChildIndex(page, pageContainerMovie.numChildren - 1);
					}
					else	pageContainerMovie.addChild(page);
					if (loadingMovie == normalLoading)	page.startBeginPage();
					page.visible = true;
					currentPageName = newPageName;
					currentPageMovie = page;
					trace( "COMPLETE_END_PAGE : " + currentPageMovie );
					
				break;
			}
		}

		private function ioErrorHandler(event: IOErrorEvent): void {
			trace(event.text);
		}
		
		private function showMovieClip(movie: MovieClip): void {
			movie.alpha = 0;
			movie.visible = true;
			TweenLite.to(movie, 1, { alpha: 1, onComplete: function() { } } );
		}
		private function hideMovieClip(movie: MovieClip): void {
			movie.alpha = 1;
			TweenLite.to(movie, 1, { alpha: 0, onComplete: function() {movie.visible = false;} } );
		}
		
		private function selectedMenuItem(item: MovieClip = null): void {
			menuMovie.farmMovie.mouseChildren = menuMovie.farmMovie.mouseEnabled = true;
			menuMovie.iLoveMovie.mouseChildren = menuMovie.iLoveMovie.mouseEnabled = true;
			menuMovie.storyMovie.mouseChildren = menuMovie.storyMovie.mouseEnabled = true;
			menuMovie.tourMovie.mouseChildren = menuMovie.tourMovie.mouseEnabled = true;
			menuMovie.shareMovie.mouseChildren = menuMovie.shareMovie.mouseEnabled = true;
			menuMovie.uploadMovie.mouseChildren = menuMovie.uploadMovie.mouseEnabled = true;
			
			if (item)	item.mouseChildren = item.mouseEnabled = false;
		}
		
		private function activeLoading(loading: BaseLoading = null): void {
			normalLoading.visible = false;
			loadingGame1Movie.visible = false;
			loadingGame2Movie.visible = false;
			if (loading) {
				this.setChildIndex(menuMovie, this.numChildren - 1);
				this.setChildIndex(loading, this.numChildren - 2);
				showMovieClip(loading);
			}
		}
	}

}