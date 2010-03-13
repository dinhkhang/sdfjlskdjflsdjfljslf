package {
	import com.dutchlady.components.milkbox.MilkBox;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.BasicView;
	
	/**
	 * ...
	 * @author Hai Nguyen
	 */
	public class Test extends BasicView {
		
		public function Test():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			camera.z = 1000;
			
			var pointLight2: PointLight3D = new PointLight3D(true, false);  // 2nd would be true for collada
			//pointLight2.x = 200;
			pointLight2.z = 700;
			//pointLight2.yaw(180);
			
			// material
			var flatShaderMat2: MaterialObject3D = new FlatShadeMaterial(pointLight2, 0xFFFFFF);
 
			var materials2: MaterialsList = new MaterialsList ();
			materials2.addMaterial (flatShaderMat2, "all");
			

			var box2: Cube = new Cube(materials2, 400, 400, 600, 15, 15, 15, 0, Cube.BOTTOM | Cube.TOP);
			
			scene.addChild(box2);
			
			startRendering();
		}
		
		override protected function onRenderTick(event: Event = null):void {
			renderer.renderScene(scene, _camera, viewport);
		}
	}
	
}