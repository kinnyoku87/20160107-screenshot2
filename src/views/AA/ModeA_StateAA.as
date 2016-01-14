package views.AA
{
	import configs.ViewConfig;
	
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Back;
	import d2armor.animate.easing.Cubic;
	import d2armor.animate.easing.Quad;
	import d2armor.display.AAFacade;
	import d2armor.display.FusionAA;
	import d2armor.display.ImageAA;
	import d2armor.display.Scale9ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.StateFusionAA;
	import d2armor.display.ViewportFusionAA;
	import d2armor.events.AEvent;
	import d2armor.events.NTouchEvent;
	import d2armor.media.SfxManager;
	
	import events.EventUtil;
	import events.view.GotoModeEvent;
	import events.view.ScreenshotModeEvent;
	
	import util.ResUtil;
	
	import views.StateInfo;
	import views.AA.comps.LongTimer_StateAA;
	import views.AA.comps.MicroLong_StateAA;

public class ModeA_StateAA extends StateAA {
	
	public function interrupt() : void {
		var s9img_A:Scale9ImageAA;
		
//		if(_started){
			this.doInterrupt(false);
//		}
//		else {
//			_interrupted = true;
//		}
		this.doInitAlphaMask();
		this.doIssueWhiteLight();
	}
	
	public function complete() : void {
		onCircComplete();
	}
	
	override public function onEnter() : void {
//		this.doInitAlphaMask();
		
		
		this.doInitPhoto();
		
		this.insertEventListener(EventUtil.view, ScreenshotModeEvent.MODE_CHANGED, ____onModeChanged);
		this.insertEventListener(EventUtil.view, GotoModeEvent.LONG,               ____onGotoMode);
		this.insertEventListener(EventUtil.view, GotoModeEvent.LONG_COMPLETE,      ____onGotoMode);
		this.insertEventListener(EventUtil.view, GotoModeEvent.FREE,               ____onGotoMode);
		this.insertEventListener(EventUtil.view, GotoModeEvent.REC,                ____onGotoMode);
		this.insertEventListener(EventUtil.view, GotoModeEvent.REC_COMPLETE,       ____onGotoMode);
	}
	
	override public function onExit():void {
		TweenMachine.getInstance().stopAll();
	}
	
	
	
	private var _vpFN:ViewportFusionAA;
	private var _photoImg:ImageAA;
	
	private var _maskBg:ImageAA;
	private var _interrupted:Boolean;
	private var _started:Boolean;
	private var _alphaMask:ImageAA;
	
	private var _bottomMaskImgA:ImageAA;
	
	
	
	
	private function doInitAlphaMask() : void {
		var tween_A:ATween;
		
		_alphaMask = new ImageAA;
		_alphaMask.alpha = ViewConfig.MASK_ALPHA;
		_alphaMask.textureId = ResUtil.getTemp("alpha_mask");
		this.getFusion().addNodeAt(_alphaMask, 0);
		
		tween_A = TweenMachine.from(_alphaMask, ViewConfig.LAUNCH_DURATION, {alpha:0.0});
		tween_A.onComplete = function() : void {
			TweenMachine.to(_alphaMask, ViewConfig.LAUNCH_DURATION / 2, {alpha:0.0 }, ViewConfig.DELAY_INTERRUPT);
		}
	}
	
	private function doInitPhoto() : void {
		var tween_A:ATween;
		
		_vpFN = new ViewportFusionAA;
		this.getFusion().addNode(_vpFN);
		
		_photoImg = new ImageAA;
		_photoImg.textureId = ResUtil.getTemp("bg1");
		_photoImg.pivotX = _photoImg.sourceWidth / 2;
		_photoImg.pivotY = _photoImg.sourceHeight / 2;
		_vpFN.addNode(_photoImg);
		_photoImg.x = (this.getRoot().getWindow().rootWidth) / 2;
		_photoImg.y = (this.getRoot().getWindow().rootHeight) / 2;
		
		tween_A = TweenMachine.to(_photoImg, ViewConfig.LAUNCH_DURATION, {scaleX:ViewConfig.SCREENSHOT_SCALE, scaleY:ViewConfig.SCREENSHOT_SCALE});
		tween_A.onComplete = onViewStart;
		tween_A.easing = Cubic.easeInOut;
		
		
	}
	
	private function onViewStart() : void {
		if(_interrupted){
			this.doInterrupt(false);
		}
		else {
			_started = true;
			//this.doInitCircle();
		}
		
	}
	
	private function onCircComplete() : void {
		var tween_A:ATween;
		var img_A:ImageAA;
		
		
		tween_A = TweenMachine.to(_photoImg, ViewConfig.LAUNCH_DURATION, {scaleX:ViewConfig.SCREENSHOT_SCALE_2, scaleY:ViewConfig.SCREENSHOT_SCALE_2,y: _photoImg.y - 120});
		tween_A.easing = Cubic.easeInOut;
		
		this.doInitMask();
		(this.getRoot().getView("hotspot").getState() as Hotspot_StateAA).readyToReset();
		
		this.getRoot().getView(StateInfo.MODE_B).activate(null);
		
		SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
	}
	
	private function doInterrupt( reset:Boolean ) : void {
		var tweenA:ATween;
		
		
		tweenA = TweenMachine.to(_photoImg, ViewConfig.DURA_INTERRUPT, {y:this.getRoot().getWindow().rootHeight}, ViewConfig.DELAY_INTERRUPT);
		tweenA.easing = Back.easeIn;
		tweenA.onComplete = function() : void {
			
			if(reset){
				getRoot().closeAllViews();
				getRoot().getView(StateInfo.RAW_SCREEN).activate();
				getRoot().getView("hotspot").activate()
			}
			else {
				getFusion().kill();
			}
		}
		
	}
	
	private function doIssueWhiteLight() : void {
		var s9img_A:Scale9ImageAA;
		
		s9img_A = new Scale9ImageAA;
		s9img_A.textureId = ResUtil.getTemp("s9_white");
		s9img_A.width = this.getRoot().getWindow().rootWidth;
		s9img_A.height = this.getRoot().getWindow().rootHeight;
		this.getFusion().addNode(s9img_A);
		
		TweenMachine.getInstance().to(s9img_A, ViewConfig.DURA_INTERRUPT, {alpha:0.0});
	}
	
	private function doInitMask() : void {
		
		_maskBg = new ImageAA;
		_maskBg.textureId = ResUtil.getTemp("bg_dark2");
		//_maskBg.alpha = 0.2;
		this.getFusion().addNodeAt(_maskBg, 0);
		
//		_maskBg.visible = false;
		//	}
		
		//	private function doTweenMask():void{
		//		_maskBg.visible = true;
		
		//TweenMachine.from(_maskBg, 0.55, {alpha:0.0});
	}
	
	private function ____onModeChanged(e:ScreenshotModeEvent ) : void {
		var index_A:int;
		var tween_A:ATween;
		
		index_A = e.index;
		
		if(index_A == 0){
			tween_A = TweenMachine.to(_photoImg, ViewConfig.LAUNCH_DURATION, {scaleX:ViewConfig.SCREENSHOT_SCALE_3, scaleY:ViewConfig.SCREENSHOT_SCALE_3,y: this.getRoot().getWindow().rootHeight / 2  - 110});
			tween_A.easing = Quad.easeInOut;
			
			_bottomMaskImgA = new ImageAA;
			_bottomMaskImgA.textureId = ResUtil.getTemp("long_bg1");
			_vpFN.addNode(_bottomMaskImgA);
			_bottomMaskImgA.y = this.getRoot().getWindow().rootHeight - _bottomMaskImgA.sourceHeight;
			
			tween_A = TweenMachine.from(_bottomMaskImgA, ViewConfig.LAUNCH_DURATION, {y: _bottomMaskImgA.y  + 150});
		}
		else if(index_A == 1){
			//_photoImg.textureId = ResUtil.getTemp("bg1");
			tween_A = TweenMachine.to(_photoImg, ViewConfig.LAUNCH_DURATION, {scaleX:ViewConfig.SCREENSHOT_SCALE_2, scaleY:ViewConfig.SCREENSHOT_SCALE_2,y: this.getRoot().getWindow().rootHeight / 2  - 120});
			
			this.doCheckAndRemoveBottom();
			
		}
		else if(index_A == 2){
//			_photoImg.textureId = ResUtil.getTemp("bg1");
			tween_A = TweenMachine.to(_photoImg, ViewConfig.LAUNCH_DURATION, {scaleX:1, scaleY:1,y: this.getRoot().getWindow().rootHeight / 2});
			
			this.doCheckAndRemoveBottom();
		}
		tween_A.easing = Quad.easeInOut;
	}
	
	private function doCheckAndRemoveBottom() : void {
		var imgA:ImageAA;
		var tweenA:ATween;
		
		if(_bottomMaskImgA) {
			imgA = _bottomMaskImgA;
			_bottomMaskImgA = null;
			tweenA = TweenMachine.to(imgA, ViewConfig.LAUNCH_DURATION, {y: imgA.y  + 150, alpha:0.0});
			tweenA.onComplete = function() : void {
				imgA.kill();
			}
		}
	}
	
	private var s9Img_A:Scale9ImageAA;
	private var s9Img_B:Scale9ImageAA;
	private var _longMaskImgA:ImageAA;
	private var _longTips:ImageAA;
	
	private var _recState:LongTimer_StateAA;
	
	
	private function ____onGotoMode(e:GotoModeEvent) : void {
		var tween_A:ATween;
		var tween_B:ATween;
		var img_A:ImageAA;
		var fusion_A:FusionAA;
		var stateFN_A:StateFusionAA;
		
		if(e.type == GotoModeEvent.FREE) {
			tween_A = TweenMachine.to(_photoImg, ViewConfig.GOTO_MODE_DURA, {scaleX:ViewConfig.SCREENSHOT_SCALE_4, scaleY:ViewConfig.SCREENSHOT_SCALE_4,y: this.getRoot().getWindow().rootHeight / 2  - 35});
			
			fusion_A = new FusionAA;
			this.getFusion().addNode(fusion_A);
			
			img_A = new ImageAA;
			img_A.textureId = ResUtil.getTemp("freeMenu");
			fusion_A.addNode(img_A);
			fusion_A.y = this.getRoot().getWindow().rootHeight - img_A.sourceHeight;
			
			img_A = new ImageAA;
			img_A.textureId = ResUtil.getTemp("wrongIcon");
			fusion_A.addNode(img_A);
			img_A.x = 29;
			img_A.y = 66;
			img_A.addEventListener(NTouchEvent.CLICK, function(e:NTouchEvent):void{
//				doInterrupt(true);
//				doIssueWhiteLight();
//				SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
				
				TweenMachine.getInstance().stopAll();
				getRoot().closeAllViews();
				getRoot().getView(StateInfo.RAW_SCREEN).activate();
				getRoot().getView("hotspot").activate()
			});
			
			img_A = new ImageAA;
			img_A.textureId = ResUtil.getTemp("rightIcon");
			fusion_A.addNode(img_A);
			img_A.x = this.getRoot().getWindow().rootWidth - img_A.sourceWidth - 29;
			img_A.y = 66;
			img_A.addEventListener(NTouchEvent.CLICK, function(e:NTouchEvent):void{
				doInterrupt(true);
				doIssueWhiteLight();
				SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
			});
			
			tween_A = TweenMachine.from(fusion_A, ViewConfig.GOTO_MODE_DURA, {alpha:0.0, y: fusion_A.y  + 100});
			tween_A.easing = Quad.easeInOut;
		}
		
		else if(e.type == GotoModeEvent.LONG) {
			_photoImg.textureId = ResUtil.getTemp("page");
			
			tween_A = TweenMachine.to(_vpFN, ViewConfig.GOTO_MODE_DURA * 1.2, {y: _vpFN.y + 150 });
			tween_A.easing = Quad.easeOut;
			tween_A.onComplete = function():void {
				tween_A = TweenMachine.to(_photoImg, ViewConfig.LONG_BG_DURA, {y: getRoot().getWindow().rootHeight * 1.5 - _photoImg.sourceHeight - 100 });
				tween_A.onComplete = function():void {
					tween_A = TweenMachine.getInstance().to(_longMaskImgA, ViewConfig.GOTO_MODE_DURA, {alpha:0.0});
					tween_A.onComplete = ____onLongComplete;
				}
				
				
				stateFN_A = new StateFusionAA;
				getFusion().addNode(stateFN_A);
				stateFN_A.setState(MicroLong_StateAA);
				
			}
			//tween_A.easing = Quad.easeInOut;
			
			_longMaskImgA = new ImageAA;
			_longMaskImgA.textureId = ResUtil.getTemp("alpha_mask");
			this.getFusion().addNode(_longMaskImgA);
			_longMaskImgA.alpha = 0.30;
			tween_A = TweenMachine.getInstance().from(_longMaskImgA, ViewConfig.GOTO_MODE_DURA, {alpha:0.0});
			
			// tips
			_longTips = new ImageAA;
			_longTips.textureId = ResUtil.getTemp("long_tips");
			_longTips.pivotX = _longTips.sourceWidth / 2;
			this.getFusion().addNode(_longTips);
			_longTips.x = this.getRoot().getWindow().rootWidth / 2
			_longTips.y = this.getRoot().getWindow().rootHeight - _longTips.sourceHeight - 55;
			
			tween_A = TweenMachine.from(_longTips, ViewConfig.GOTO_MODE_DURA, {alpha:0.0 }, ViewConfig.GOTO_MODE_DURA);
			
			
			this.getRoot().getNode().addEventListener(NTouchEvent.RELEASE, ____onLongForRoot);
		}
		
		else if(e.type == GotoModeEvent.REC) {
//			img_A = new ImageAA;
//			img_A.textureId = ResUtil.getTemp("timeBg");
//			this.getFusion().addNode(img_A);
//			img_A.x = this.getRoot().getWindow().rootWidth - img_A.sourceWidth - 30;
//			img_A.y = 100
			
//			tween_A = TweenMachine.from(img_A, ViewConfig.GOTO_MODE_DURA, {alpha:0.0 });
//			tween_A.easing = Quad.easeInOut;
			
			stateFN_A = new StateFusionAA;
			this.getFusion().addNode(stateFN_A);
			stateFN_A.setState(LongTimer_StateAA);
			
			_recState = stateFN_A.getState() as LongTimer_StateAA;
			
			stateFN_A.addEventListener(NTouchEvent.CLICK, ____onRecComplete);
		}
		else if(e.type == GotoModeEvent.REC_COMPLETE) {
			tween_A = TweenMachine.to(_photoImg, ViewConfig.GOTO_MODE_DURA, {scaleX:ViewConfig.SCREENSHOT_SCALE_4, scaleY:ViewConfig.SCREENSHOT_SCALE_4,y: this.getRoot().getWindow().rootHeight / 2  - 35});
			tween_A.onComplete = function():void {
				doInterrupt(true);
			}
				
			this.doIssueWhiteLight();
			
			SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
		}
	}
	
	private function ____onLongForRoot(e:NTouchEvent):void {
		this.getRoot().getNode().removeEventListener(NTouchEvent.RELEASE, ____onLongForRoot);
		TweenMachine.getInstance().stopAll();
		TweenMachine.getInstance().to(_longMaskImgA, ViewConfig.GOTO_MODE_DURA, {alpha:0.0});
		____doLongComplete();
	}
	
	private function ____onLongComplete(): void {
		this.getRoot().getNode().removeEventListener(NTouchEvent.RELEASE, ____onLongForRoot);
		____doLongComplete();
	}
	
	private function ____doLongComplete() : void {
		var img_A:ImageAA;
		var fusion_A:FusionAA;
		var tween_A:ATween;
		
		tween_A = TweenMachine.to(_longTips, ViewConfig.GOTO_MODE_DURA, {alpha:0.0 } );
		
		
		fusion_A = new FusionAA;
		this.getFusion().addNode(fusion_A);
		
		img_A = new ImageAA;
		img_A.textureId = ResUtil.getTemp("long_bottom");
		fusion_A.addNode(img_A);
		img_A.y = 55;
		
		fusion_A.y = this.getRoot().getWindow().rootHeight - 191;
		
		img_A = new ImageAA;
		img_A.textureId = ResUtil.getTemp("wrongIcon");
		fusion_A.addNode(img_A);
		img_A.x = 29;
		img_A.y = 66;
		img_A.addEventListener(NTouchEvent.CLICK, function(e:NTouchEvent):void{
//			doInterrupt(true);
//			doIssueWhiteLight();
//			SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
			
			TweenMachine.getInstance().stopAll();
			getRoot().closeAllViews();
			getRoot().getView(StateInfo.RAW_SCREEN).activate();
			getRoot().getView("hotspot").activate()
		});
		
		img_A = new ImageAA;
		img_A.textureId = ResUtil.getTemp("rightIcon");
		fusion_A.addNode(img_A);
		img_A.x = this.getRoot().getWindow().rootWidth - img_A.sourceWidth - 29;
		img_A.y = 66;
		img_A.addEventListener(NTouchEvent.CLICK, function(e:NTouchEvent):void{
			doInterrupt(true);
			doIssueWhiteLight();
			SfxManager.getInstance().loadAndPlay("common/audio/4072.mp3");
		});
		
		tween_A = TweenMachine.from(fusion_A, ViewConfig.GOTO_MODE_DURA, {alpha:0.0, y: fusion_A.y  + 100});
		tween_A.easing = Quad.easeInOut;
		
	}
	
	
	private function ____onRecComplete(e:AEvent):void {
		this.getRoot().getNode().removeEventListener(NTouchEvent.RELEASE, ____onRecComplete);
		
		_recState.fade();
		
		EventUtil.view.dispatchEvent(new GotoModeEvent(GotoModeEvent.REC_COMPLETE));
	}
	
}
}
