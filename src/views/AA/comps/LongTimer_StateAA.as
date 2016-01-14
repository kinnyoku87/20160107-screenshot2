package views.AA.comps
{
	import configs.ViewConfig;
	
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Cubic;
	import d2armor.animate.easing.Quad;
	import d2armor.display.AnimeAA;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	
	import util.ResUtil;
	
	public class LongTimer_StateAA extends StateAA
	{
		public function fade() : void {
			anime_A.getAnimation().paused = true;
			
			//TweenMachine.getInstance().to(this.getFusion(), 0.3, {alpha:0.0});
		}
		
		override public function onEnter():void {
			var tween_A:ATween;
			var img_A:ImageAA;
			
			
			img_A = new ImageAA;
			img_A.textureId = ResUtil.getTemp("timeBg");
			this.getFusion().addNode(img_A);
			
			this.getFusion().x = this.getRoot().getWindow().rootWidth - img_A.sourceWidth - 30;
			this.getFusion().y = 100;
			
			_dotImgA = new ImageAA;
			_dotImgA.textureId = ResUtil.getTemp("roundIcon");
//			_roundImgA.pivotY = _roundImgA.sourceHeight / 0.5;
			this.getFusion().addNode(_dotImgA);
			_dotImgA.x = 18;
			_dotImgA.y = (img_A.sourceHeight - _dotImgA.sourceHeight) / 2;
			
			anime_A = new AnimeAA;
			anime_A.getAnimation().start("atlas/timer", "timer.second", 0);
			//anime_A.pivotY = anime_A.sourceHeight / 0.5;
			this.getFusion().addNode(anime_A);
			anime_A.x = 55;
			anime_A.y = (img_A.sourceHeight - anime_A.sourceHeight) / 2;
			
			tween_A = TweenMachine.from(img_A, ViewConfig.GOTO_MODE_DURA, {alpha:0.0 });
			tween_A.easing = Quad.easeInOut;
			
			
			this.____doBlinkRoundImg();
			
			
			
		}
		
		
		
		private var _dotImgA:ImageAA;
		private var anime_A:AnimeAA;
		
		private function ____doBlinkRoundImg() : void {
			var tween_A:ATween;
			
			tween_A = TweenMachine.to(_dotImgA, 0.5, {alpha:0.0 });
			tween_A.easing = Cubic.easeOut;
			tween_A.onComplete = function() : void {
				tween_A = TweenMachine.to(_dotImgA, 0.5, {alpha:1.0 });
				tween_A.easing = Cubic.easeOut;
				tween_A.onComplete = ____doBlinkRoundImg;
			}
		}
		
	}
}