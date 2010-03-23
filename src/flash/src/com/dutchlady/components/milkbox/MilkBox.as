package com.dutchlady.components.milkbox {
	//import com.dutchlady.common.GlobalVars;
	import com.dutchlady.events.PageEvent;
	import fl.transitions.easing.Strong;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import gs.TweenLite;
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.cameras.DebugCamera3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.shaders.FlatShader;
	import org.papervision3d.materials.shaders.ShadedMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.Viewport3D;

	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class MilkBox extends BasicView {
		public static const DELTA: Number = 1;
		public static const HEART_BOX_FACE_NAME: String = "heart";
		public static const STORY_BOX_FACE_NAME: String = "story";
		public static const SHARE_BOX_FACE_NAME: String = "share";
		public static const TOUR_BOX_FACE_NAME: String = "tour";
		
		public static const CREATION_COMPLETE: String = "creationComplete";
		
		private var box: Cube;
		private var pointLight: PointLight3D;
		
		private var isInBox: Boolean = false;
		private var isMouseDown: Boolean = false;
		private var is3DSceneDirty: Boolean = false;
		private var isAutoRotate: Boolean = false;
		private var isRotating: Boolean = false;
		private var lastMouseX: Number;
		private var offsetX: Number;
		private var timer: Timer;
		private var newBoxRotationAngle: Number = 0;
		
		//public var zoomInIcon: ZoomInIcon;
		public var leftRotationIcon: LeftRotationIcon;
		public var rightRotationIcon: RightRotationIcon;
		
		private var heartAssetLoader: Loader;
		private var shareAssetLoader: Loader;
		private var storyAssetLoader: Loader;
		private var tourAssetLoader: Loader;
		
		private var selectedBoxFaceName: String = "";
		
		public var isRollOver: Boolean = true;
		private var isMouseClick:Boolean = false;
		
		public function MilkBox() {
			super(600, 600, false, true, CameraType.TARGET);
			
			viewport.interactive = true;
			camera.z = 720;
			camera.y = -60;
			var target: DisplayObject3D = DisplayObject3D.ZERO;
			target.y = 50;
			camera.target = target;
			loadMaterial();
			timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function leftRotationIconRollHandler(event: MouseEvent): void {
			//trace( "event : " + event.target );
			var type: String = (event.type == MouseEvent.ROLL_OVER) ? PageEvent.CURSOR_ROTATE_LEFT : PageEvent.CURSOR_NORMAL;
			this.dispatchEvent(new PageEvent(type, true));
		}
		
		private function rightRotationIconRollHandler(event: MouseEvent): void {
			//trace( "event : " + event.target );
			var type: String = (event.type == MouseEvent.ROLL_OVER) ? PageEvent.CURSOR_ROTATE_RIGHT : PageEvent.CURSOR_NORMAL;
			this.dispatchEvent(new PageEvent(type, true));
		}
		
		private function rightRotationIconClickHandler(event: MouseEvent): void {
			//trace( "event : " + event.target );
			selectedBoxFaceName = "";
			newBoxRotationAngle -= 90;
		}
		
		private function leftRotationIconClickHandler(event: MouseEvent): void {
			//trace( "event : " + event.target );
			selectedBoxFaceName = "";
			newBoxRotationAngle += 90;
		}
		
		private function timerHandler(event: TimerEvent): void {
			timer.reset();
			isAutoRotate = true;
		}
		
		private function loadMaterial():void {
			//trace("loadMaterial");
			heartAssetLoader = new Loader();
			heartAssetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, storyAssetLoadCompleteHandler);
			//heartAssetLoader.load(new URLRequest("images/heart.jpg"));
			heartAssetLoader.load(new URLRequest("iLove.swf"));
		}
		
		private function heartAssetLoadCompleteHandler(event: Event): void {
			trace("heartAssetLoadCompleteHandler");
			shareAssetLoader = new Loader();
			shareAssetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, tourAssetLoadCompleteHandler);
			shareAssetLoader.load(new URLRequest("images/share.jpg"));
		}
		
		private function shareAssetLoadCompleteHandler(event: Event): void {
			trace("shareAssetLoadCompleteHandler");
			storyAssetLoader = new Loader();
			storyAssetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, heartAssetLoadCompleteHandler);
			storyAssetLoader.load(new URLRequest("images/standard.jpg"));
		}
		
		private function storyAssetLoadCompleteHandler(event: Event): void {
			trace("storyAssetLoadCompleteHandler");
			tourAssetLoader = new Loader();
			tourAssetLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, shareAssetLoadCompleteHandler);
			//tourAssetLoader.load(new URLRequest("box04.swf"));
			tourAssetLoader.load(new URLRequest("images/tour.jpg"));
		}
		
		private function tourAssetLoadCompleteHandler(event: Event): void {
			trace("tourAssetLoadCompleteHandler");
			init3DWorld();
		}
		
		private function createBoxFaceMatetial(content: DisplayObject, materialName: String, light: PointLight3D, animated: Boolean = false):MaterialObject3D {
			var material: MovieMaterial = new MovieMaterial(content, false, animated);
			material.interactive = true;
			material.oneSide = true;
			//material.smooth = true;
			material.name = materialName;
			material.bitmap.applyFilter(material.bitmap, material.bitmap.rect, new Point(0, 0), new BlurFilter(4, 4, BitmapFilterQuality.LOW));
			
			return material;
			
			//var flatShader: FlatShader = new FlatShader(light, 0xFFFFFF, 0x999999);
			//var flatShadedMaterial: ShadedMaterial = new ShadedMaterial(material, flatShader);
			//
			//flatShadedMaterial.interactive = true;
			//flatShadedMaterial.oneSide = true;
			//flatShadedMaterial.name = materialName;
			//return flatShadedMaterial;
		}
		
		private function init3DWorld(): void {
			pointLight = new PointLight3D(true, false);
			pointLight.z = 3000;
			//scene.addChild(pointLight);
			
			var heartMaterial: MaterialObject3D = createBoxFaceMatetial(heartAssetLoader.contentLoaderInfo.content, "heart", pointLight, true);
			var shareMaterial: MaterialObject3D = createBoxFaceMatetial(shareAssetLoader.contentLoaderInfo.content, "share", pointLight);
			var storyMaterial: MaterialObject3D = createBoxFaceMatetial(storyAssetLoader.contentLoaderInfo.content, "story", pointLight);
			var tourMaterial: MaterialObject3D = createBoxFaceMatetial(tourAssetLoader.contentLoaderInfo.content, "tour", pointLight);
			
			var materials: MaterialsList = new MaterialsList(
			{
				front: heartMaterial,
				back: tourMaterial,
				right: storyMaterial,
				left: shareMaterial
			} );
			
			box = new Cube(materials, 400, 250, 600, 15, 15, 15, 0, Cube.BOTTOM | Cube.TOP);
			box.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, boxClickHandler);
			box.rotationY = -25;
			scene.addChild(box);
			
			is3DSceneDirty = true;
			
			newBoxRotationAngle = box.rotationY;
			startRendering();
			dispatchEvent(new Event(CREATION_COMPLETE));
			
			this.mouseEnabled = true;
			this.useHandCursor = true;
			//this.addEventListener(MouseEvent.MOUSE_DOWN, boxMouseDownHandler);
			//this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			//this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			//////////////////////////////////////
			rightRotationIcon = new RightRotationIcon();
			rightRotationIcon.addEventListener(MouseEvent.ROLL_OVER, rightRotationIconRollHandler);
			rightRotationIcon.addEventListener(MouseEvent.ROLL_OUT, rightRotationIconRollHandler);
			rightRotationIcon.addEventListener(MouseEvent.CLICK, rightRotationIconClickHandler);
			addChild(rightRotationIcon);
			rightRotationIcon.x = 450;
			rightRotationIcon.y = 300;
			rightRotationIcon.alpha = 0;
			
			leftRotationIcon = new LeftRotationIcon();
			leftRotationIcon.addEventListener(MouseEvent.ROLL_OVER, leftRotationIconRollHandler);
			leftRotationIcon.addEventListener(MouseEvent.MOUSE_OUT, leftRotationIconRollHandler);
			leftRotationIcon.addEventListener(MouseEvent.CLICK, leftRotationIconClickHandler);
			addChild(leftRotationIcon);
			leftRotationIcon.x = 120;
			leftRotationIcon.y = 300;
			leftRotationIcon.alpha = 0;
		}
		
		private function boxClickHandler(event: InteractiveScene3DEvent): void {
			//trace("boxClickHandler");
			isMouseClick = true;
			selectedBoxFaceName = event.face3d.material.name;
			switch (event.face3d.material.name) {
				case HEART_BOX_FACE_NAME:
					navigateToHeartFace();
					//GlobalVars.mainTimeLine.dispatchEvent(new PageEvent(PageEvent.SHOW_HEART_POPUP));
					break;
				case STORY_BOX_FACE_NAME:
					navigateToStoryFace();
					//GlobalVars.mainTimeLine.dispatchEvent(new PageEvent(PageEvent.SHOW_STORY_POPUP));
					break;
				case SHARE_BOX_FACE_NAME:
					navigateToShareFace();
					//GlobalVars.mainTimeLine.dispatchEvent(new PageEvent(PageEvent.SHOW_SHARE_POPUP));
					break;
				case TOUR_BOX_FACE_NAME:
					navigateToTourFace();
					//GlobalVars.mainTimeLine.dispatchEvent(new PageEvent(PageEvent.SHOW_TOUR_POPUP));
					break;
				default:
					break;
			}
		}
		
		private function zoomInBoxFace(material: MaterialObject3D):void {
			var bitmapData: BitmapData = material.bitmap.clone();
			
			
		}
		
		//private function rollOutHandler(event: MouseEvent): void {
			//hideCustomCursor();
			//isInBox = false;
		//}
		//
		//private function rollOverHandler(event: MouseEvent): void {
			//showCustomCursor();
			//isInBox = true;
		//}
		
		private function boxMouseDownHandler(event: MouseEvent): void {
			lastMouseX =  this.mouseX;
			isMouseDown = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}
		
		private function stageMouseUpHandler(event: MouseEvent): void {
			isMouseDown = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
		}
		
		private function checkMouseInBox():Boolean {
			if (100 <= this.mouseX && this.mouseX <= 500 &&
				110 <= this.mouseY && this.mouseY <= 538) return true;
				
			return false;
		}
		
		override protected function onRenderTick(event: Event = null):void {
			/*if (isMouseDown) {
				offsetX = this.mouseX - lastMouseX;
				box.rotationY -= offsetX / 4;
				
				lastMouseX = this.mouseX;
			}*/
			//box.rotationY--;
			if (!isRollOver)	return;
			if (checkMouseInBox()) {
				if (!isInBox) {
					isInBox = true;
					if (this.mouseX < (this.width / 2)) newBoxRotationAngle -= 10;
					else newBoxRotationAngle += 10;
				}
				//newBoxRotationAngle += (this.mouseX - (this.width / 2)) / 50;
				//showCustomCursor();
				this.dispatchEvent(new PageEvent(PageEvent.CURSOR_ZOOM, true));
				var point: Point = localToGlobal(new Point(this.mouseX, this.mouseY));
				if (leftRotationIcon.hitTestPoint(point.x, point.y) || rightRotationIcon.hitTestPoint(point.x, point.y)) {
					//Mouse.show();
					//zoomInIcon.visible = false;
				}
				
				isAutoRotate = false;
				timer.reset();
			} else {
				isInBox = false;
				//hideCustomCursor();
				this.dispatchEvent(new PageEvent(PageEvent.CURSOR_NORMAL, true));
				if (isAutoRotate) {
					newBoxRotationAngle -= 0.2;
				} timer.start();
			}
			
			//newBoxRotationAngle %= 360;
			isRotating = Math.abs(newBoxRotationAngle - box.rotationY) > DELTA;
			if (!isRotating) {
				rotateCompleteHandler();
			}
			if (isRotating) {
				box.rotationY += (newBoxRotationAngle - box.rotationY) / 10;
				is3DSceneDirty = true;
			}
			
			if (is3DSceneDirty) {
				renderer.renderScene(scene, _camera, viewport);
				is3DSceneDirty = false;
			}
			
			//alignCustomCursor();
		}
		
		private function alignCustomCursor():void {
			//zoomInIcon.x = this.mouseX - zoomInIcon.width / 2;
			//zoomInIcon.y = this.mouseY - zoomInIcon.height / 2;
			//zoomInIcon.visible = false;
			
			leftRotationIcon.x = 120;
			leftRotationIcon.y = 300;
			this.setChildIndex(leftRotationIcon, this.numChildren - 1);
			//leftRotationIcon.alpha = 0;
			
			rightRotationIcon.x = 450;
			rightRotationIcon.y = 300;
			this.setChildIndex(rightRotationIcon, this.numChildren - 1);
			//rightRotationIcon.alpha = 0;
		}
		
		private function showCustomCursor():void {
			//Mouse.hide();
			
			//zoomInIcon.visible = true;
			//leftRotationIcon.visible = true;
			//rightRotationIcon.visible = true;
			//alignCustomCursor();
		}
		
		private function hideCustomCursor():void {
			//leftRotationIcon.visible = false;
			//rightRotationIcon.visible = false;
			//zoomInIcon.visible = false;
			//Mouse.show();
		}
		
		public function forceBoxToReachToTheEnd():void {
			newBoxRotationAngle %= 360;
			if (newBoxRotationAngle > 0) newBoxRotationAngle = newBoxRotationAngle - 360;
			box.rotationY = newBoxRotationAngle;
		}
		
		public function navigateToHeartFace():void {
			forceBoxToReachToTheEnd();
			newBoxRotationAngle = 0;
		}
		
		public function navigateToStoryFace():void {
			forceBoxToReachToTheEnd();
			newBoxRotationAngle = 0 - 90;
		}
		
		public function navigateToTourFace():void {
			forceBoxToReachToTheEnd();
			newBoxRotationAngle = 0 - 90 - 90;
		}
		
		public function navigateToShareFace():void {
			forceBoxToReachToTheEnd();
			newBoxRotationAngle = 0 - 90 - 90 - 90;
		}
		
		public function freeze():void {
			timer.reset();
			isAutoRotate = false;
		}
		
		public function unfreeze():void {
			timer.start();
		}
		
		private function rotateCompleteHandler():void {
			if (isMouseClick) {
				switch (selectedBoxFaceName) {
					case HEART_BOX_FACE_NAME:
						this.dispatchEvent(new PageEvent(PageEvent.SHOW_HEART_POPUP, true));
						break;
					case STORY_BOX_FACE_NAME:
						this.dispatchEvent(new PageEvent(PageEvent.SHOW_STORY_POPUP, true));
						break;
					case SHARE_BOX_FACE_NAME:
						this.dispatchEvent(new PageEvent(PageEvent.SHOW_SHARE_POPUP, true));
						break;
					case TOUR_BOX_FACE_NAME:
						this.dispatchEvent(new PageEvent(PageEvent.SHOW_TOUR_POPUP, true));
						break;
					default:
						break;
				}
			}
			selectedBoxFaceName = "";
			isMouseClick = false;
		}
	}

}