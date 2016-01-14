package views.AA {
	import views.AA.comps.Circle_StateAA;
	
	import configs.ViewConfig;
	
	import d2armor.Armor;
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.animate.easing.Cubic;
	import d2armor.animate.easing.Quad;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.StateFusionAA;
	import d2armor.media.SfxManager;
	
	import util.ResUtil;

public class Screenshot_StateAA extends StateAA {
	
	public function interrupt() : void {
		if(_started){
			this.doInterrupt();
		}
		else {
			_interrupted = true;
		}
		
	}
	
	override public function onEnter() : void {
		this.doInitAlphaMask();
		this.doInitPhoto();
		this.doInitCircle();
		
		
	}
	
	override public function onExit():void {
		TweenMachine.getInstance().stopAll();
	}
	
	
	private var _photoImg:ImageAA;
	private var _circleState:Circle_StateAA;
	
	private var _maskBg:ImageAA;
	private var _interrupted:Boolean;
	private var _started:Boolean;
	private var _alphaMask:ImageAA;
	
	
	private function doInitAlphaMask() : void {
		
		
		_alphaMask = new ImageAA;
		_alphaMask.alpha = ViewConfig.MASK_ALPHA;
		_alphaMask.textureId = ResUtil.getTemp("alpha_mask");
		this.getFusion().addNode(_alphaMask);
		
		TweenMachine.from(_alphaMask, ViewConfig.LAUNCH_DURATION, {alpha:0.0});
	}
	
	private function doInitPhoto() : void {
		var tween_A:ATween;
		
		_photoImg = new ImageAA;
		_photoImg.textureId = ResUtil.getTemp("screens2");
		_photoImg.pivotX = _photoImg.sourceWidth / 2;
		_photoImg.pivotY = _photoImg.sourceHeight / 2;
		this.getFusion().addNode(_photoImg);
		_photoImg.x = (this.getRoot().getWindow().rootWidth) / 2;
		_photoImg.y = (this.getRoot().getWindow().rootHeight) / 2;
		
		tween_A = TweenMachine.to(_photoImg, ViewConfig.LAUNCH_DURATION, {scaleX:ViewConfig.SCREENSHOT_SCALE, scaleY:ViewConfig.SCREENSHOT_SCALE});
		tween_A.onComplete = onViewStart;
		tween_A.easing = Cubic.easeInOut;
	}
	
	private function doInitCircle() : void {
		var stateFN:StateFusionAA;
		
		stateFN = new StateFusionAA;
		stateFN.x = this.getRoot().getWindow().rootWidth / 2;
		stateFN.y = this.getRoot().getWindow().rootHeight / 2;
		
		stateFN.setState(Circle_StateAA);
		_circleState = stateFN.getState() as Circle_StateAA;
		this.getFusion().addNode(stateFN);
		
		_circleState.start(onCircComplete);
	}
	
	private function onViewStart() : void {
		if(_interrupted){
			this.doInterrupt();
		}
		else {
			_started = true;
			//this.doInitCircle();
		}
		
	}
	
	private function onCircComplete() : void {
		var tween_A:ATween;
		
		_circleState.getFusion().kill();
		_photoImg.textureId = ResUtil.getTemp("screens1");
		tween_A = TweenMachine.to(_photoImg, ViewConfig.LAUNCH_DURATION, {scaleX:ViewConfig.SCREENSHOT_SCALE_2, scaleY:ViewConfig.SCREENSHOT_SCALE_2});
		tween_A.easing = Cubic.easeInOut;
		this.doInitMask();
		this.doInitPanel();
		(this.getRoot().getView("hotspot").getState() as Hotspot_StateAA).readyToReset();
		
		SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
	}
	
	private function doInterrupt() : void {
		var tweenA:ATween;
		
		Armor.getLog().simplify("interrupt");
		
		if(_circleState){
			_circleState.getFusion().kill();
		}
		
		TweenMachine.to(_alphaMask, ViewConfig.DURA_INTERRUPT, {alpha:0.0 }, ViewConfig.DELAY_INTERRUPT);
		tweenA = TweenMachine.to(_photoImg, ViewConfig.DURA_INTERRUPT, {y:_photoImg.y - 500, alpha:0.0}, ViewConfig.DELAY_INTERRUPT);
		tweenA.easing = Back.easeIn;
		tweenA.onComplete = function() : void {
			getFusion().kill();
		}
	}
	
	private function doInitMask() : void {
		
		_maskBg = new ImageAA;
		_maskBg.textureId = ResUtil.getTemp("vagueBg");
		this.getFusion().addNodeAt(_maskBg, 0);
		//_maskBg.visible = false;
//	}
	
//	private function doTweenMask():void{
//		_maskBg.visible = true;
		
		TweenMachine.from(_maskBg, 0.55, {alpha:0.0});
	}
	
	private function doInitPanel(): void{
		var imgA:ImageAA;
		
		imgA = new ImageAA;
		imgA.textureId = ResUtil.getTemp("barA");
		this.getFusion().addNode(imgA);
		imgA.y = 10;
		
		imgA = new ImageAA;
		imgA.textureId = ResUtil.getTemp("barB");
		this.getFusion().addNode(imgA);
		imgA.x = this.getRoot().getWindow().rootWidth - imgA.sourceWidth;
		imgA.y = this.getRoot().getWindow().rootHeight / 2 - 100;
		
		imgA = new ImageAA;
		imgA.textureId = ResUtil.getTemp("barC");
		this.getFusion().addNode(imgA);
		imgA.y = this.getRoot().getWindow().rootHeight - imgA.sourceHeight - 10;
	}
	
}
}