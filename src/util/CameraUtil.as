package util
{
	import flash.display3D.Context3D;
	import flash.media.Camera;
	
	import d2armor.Armor;
	import d2armor.activity.AWindow;
	import d2armor.display.AAFacade;
	import d2armor.display.ImageAA;
	import d2armor.display.textures.VideoTextureAA;

	public class CameraUtil
	{
	
		public static var camera_A:Camera;
		public static var videoTEX:VideoTextureAA;
		
		public static function readyVideoTexture( adapter:AWindow, onComplete:Function ) : void {
			
			Armor.getLog().simplify("supportsVideoTexture: " + Context3D.supportsVideoTexture);	
			Armor.getLog().simplify("supportsCamera: " + Camera.isSupported);	
			
			if (Camera.isSupported && Context3D.supportsVideoTexture) {
					
				camera_A = Camera.getCamera();
				
				if(camera_A){
					
					Armor.getLog().simplify("{0} | {1}", camera_A.width, camera_A.height);
					
					
					
					//					camera_A.setMode(1080, 1920, 15);
					//					camera_A.setMode(this.getRoot().getAdapter().rootWidth, this.getRoot().getAdapter().rootHeight, 15);
					camera_A.setMode(adapter.rootHeight, adapter.rootWidth, 30);
					
					Armor.getLog().simplify("{0} | {1}", adapter.rootHeight, adapter.rootWidth);
					
					Armor.getLog().simplify("{0} | {1}", camera_A.height, camera_A.width );
					
					camera_A.setQuality(0, 80);
					
					videoTEX = new VideoTextureAA(camera_A, function():void{
						AAFacade.registerAsset("videoA", videoTEX, "videoA");
						
						onComplete();
					});
				}
				else {
					onComplete();
				}
					
			}
			else {
				onComplete();
			}
		}
	}
}