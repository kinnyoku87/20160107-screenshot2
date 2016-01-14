package views.AA.comps
{
	import configs.ViewConfig;
	
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.display.ImageAA;
	import d2armor.display.Scale9ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.ViewportFusionAA;
	
	import util.ResUtil;
	
	public class MicroLong_StateAA extends StateAA
	{
		public function MicroLong_StateAA()
		{
			super();
		}
		
		
		override public function onEnter():void {
			var tween_A:ATween;
			
			_vpA = new ViewportFusionAA;
			this.getFusion().addNode(_vpA);
			
			_bgA = new Scale9ImageAA;
			_bgA.textureId = ResUtil.getTemp("phoneBg");
			this.getFusion().addNode(_bgA);
			
			_vpA.viewportEnabled = true;
			_vpA.x = 3;
			_vpA.y = 3;
			_vpA.viewportWidth = _bgA.sourceWidth - 6;
			_vpA.viewportHeight = _bgA.sourceHeight - 6;
			
			this.getFusion().x = this.getRoot().getWindow().rootWidth - _bgA.width;
			this.getFusion().y = 700;;
				
			
			_microImgA = new ImageAA;
			_microImgA.x = 10;
			_microImgA.y = 55;
			_microImgA.textureId = ResUtil.getTemp("smallPage");
			_vpA.addNode(_microImgA);
			
			tween_A = TweenMachine.getInstance().to(_bgA, ViewConfig.LONG_BG_DURA, {y:_bgA.y - SCROLL_HEIGHT, height:_bgA.height + SCROLL_HEIGHT});
			tween_A = TweenMachine.getInstance().to(_vpA, ViewConfig.LONG_BG_DURA, {y:_vpA.y - SCROLL_HEIGHT, viewportHeight: _vpA.viewportHeight + SCROLL_HEIGHT});
		}
		
		
		private static const SCROLL_HEIGHT:Number = 160;
		
		private var _vpA:ViewportFusionAA;
		private var _bgA:Scale9ImageAA;
		private var _microImgA:ImageAA;
		
		
	}
}