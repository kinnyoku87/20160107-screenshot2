package views.AA
{
	import configs.ViewConfig;
	
	import d2armor.animate.DelayMachine;
	import d2armor.animate.TweenMachine;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.events.ATouchEvent;
	import d2armor.events.NTouchEvent;
	import d2armor.gesture.GestureRecognizer;
	import d2armor.gesture.LongPressGestureRecognizer;
	import d2armor.gesture.MultiPressGestureRecognizer;
	import d2armor.media.SfxManager;
	import d2armor.utils.AColor;
	
	import util.ResUtil;
	
	import views.StateInfo;

	public class Hotspot_StateAA extends StateAA {
		
		public function readyToReset() : void {
			
			_hotspotImgC.kill();
			_hotspotImgC = null;
			
			_hotspotImgB = this.doCreateBlockB();
			//_hotspotImgB.y = 80;
		}
		
		override public function onEnter() : void {
			this.doInitHotspot();
			
		}
		
		
		private var _hotspotImgB:ImageAA;
		private var _launchDelayID:int = -1;
		private var _hotspotImgC:ImageAA;
		
		
		
		private function doInitHotspot() : void {
			_hotspotImgC = this.doCreateBlockC();
			_hotspotImgC.x = (this.getRoot().getWindow().rootWidth - _hotspotImgC.sourceWidth * ViewConfig.HOTSPOT_SCALE) / 2;
			_hotspotImgC.y = this.getRoot().getWindow().rootHeight - _hotspotImgC.sourceHeight * ViewConfig.HOTSPOT_SCALE - 0;
		}
		
		private function doCreateBlockB(): ImageAA {
			var block:ImageAA;
			
			block = new ImageAA;
			block.textureId = ResUtil.getTemp("block");
			this.getFusion().addNode(block);
			block.scaleX = block.scaleY = ViewConfig.HOTSPOT_SCALE;
			block.addEventListener(NTouchEvent.CLICK, function():void{
				TweenMachine.getInstance().stopAll();
				getRoot().closeAllViews();
				getRoot().getView(StateInfo.RAW_SCREEN).activate();
				getRoot().getView("hotspot").activate()
			});
			return block;
		}
		
		private function doCreateBlockC(): ImageAA {
			var block:ImageAA;
			var reco_A:GestureRecognizer;
			
			block = new ImageAA;
			block.textureId = ResUtil.getTemp("block");
			block.color = new AColor(0xdddd33);
			this.getFusion().addNode(block);
			block.scaleX = block.scaleY = ViewConfig.HOTSPOT_SCALE;
			
			(block.recognize(MultiPressGestureRecognizer, function(e:MultiPressGestureRecognizer) : void {
				reco_A.intercept();
				//trace("double tap");
				
				doShowScreenshot2();
				(getRoot().getView(StateInfo.MODE_A).getState() as ModeA_StateAA).interrupt();
				
				SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
				
			}) as MultiPressGestureRecognizer).numPressRequired = 2;
			reco_A = block.recognize(LongPressGestureRecognizer, function(e:LongPressGestureRecognizer) : void {
				
				//trace("doShowScreenshot2 press");
				
				
				doShowScreenshot2();
				(getRoot().getView(StateInfo.MODE_A).getState() as ModeA_StateAA).complete();
				
				getRoot().getView(StateInfo.RAW_SCREEN).close();
			});
			
			return block;
		}
		
		private function doShowScreenshot2() : void {
			this.getRoot().getView(StateInfo.MODE_A).activate(null, 1);
			
			//SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
		}
		
	}
}