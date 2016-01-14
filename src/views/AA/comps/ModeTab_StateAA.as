package views.AA.comps {
	import configs.ViewConfig;
	
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Cubic;
	import d2armor.animate.easing.Quad;
	import d2armor.display.FusionAA;
	import d2armor.display.ImageAA;
	import d2armor.display.RadioAA;
	import d2armor.display.StateAA;
	import d2armor.events.AEvent;
	import d2armor.events.ATouchEvent;
	import d2armor.events.NTouchEvent;
	import d2armor.gesture.LongPressGestureRecognizer;
	import d2armor.ui.RadioGroup;
	import d2armor.utils.AMath;
	
	import events.EventUtil;
	import events.view.GotoModeEvent;
	import events.view.ScreenshotModeEvent;
	
	import util.ResUtil;
	
public class ModeTab_StateAA extends StateAA {
	
	public function get selectedIndex() : int {
		return m_selectedIndex;
	}
	
	public function set selectedIndex( v:int ) : void {
		var oldV:int;
		
		v = AMath.clamp(v, 0, NUM_TAB - 1);
		//trace(v);
		if(m_selectedIndex != v) {
			oldV = m_selectedIndex;
			m_selectedIndex = v;
			
			EventUtil.view.dispatchEvent(new ScreenshotModeEvent(ScreenshotModeEvent.MODE_CHANGED, m_selectedIndex, oldV < v));
		}
	}
	
	public function updateMode(positive:Boolean) : void {
		this.doUpdateMode(positive);
		
	}
	
	
	override public function onEnter():void {
		var radio_A:RadioAA;
		var i:int;
		
		m_iconFN = new CFusionAA;
		this.getFusion().addNode(m_iconFN);
		
		m_tabFusion = new FusionAA;
		this.getFusion().addNode(m_tabFusion);
		
		m_radioGroupA = new RadioGroup;
		
		while(i < NUM_TAB) {
			radio_A = new RadioAA;
			radio_A.skinId = "tab" + i;
			m_tabFusion.addNode(radio_A);
			radio_A.pivotX = radio_A.getBackground().sourceWidth / 2;
			radio_A.pivotY = radio_A.getBackground().sourceHeight / 2;
			radio_A.x = GAP_W * i++;
			radio_A.group = m_radioGroupA;
			
		}
		m_selectedIndex = m_radioGroupA.selectedIndex = INIT_INDEX;
		m_tabFusion.x = -INIT_INDEX * GAP_W;
		
		this.doShowFree(true);
		
		m_radioGroupA.addEventListener(AEvent.CHANGE, ____onRadioChanged);
		
	}
	
	override public function onExit():void {
		//this.getRoot().getNode().removeAllListeners();
		m_radioGroupA.removeEventListener(AEvent.CHANGE, ____onRadioChanged);
	}
	
	
	
	private static const GAP_W:Number = 200;
	private static const NUM_TAB:int = 3;
	private static const INIT_INDEX:int = 1;
	private static const ICON_OFFSET_Y:Number = -155;
	private static const ICON_TWEEN_OFFSET_X:Number = 330;
	private static const FREE_GAP_X:Number = 180;
	
	private var m_selectedIndex:int;
	private var m_radioGroupA:RadioGroup;
	private var m_tabFusion:FusionAA;
	private var m_iconFN:FusionAA;
	
	
	
	private function ____onRadioChanged(e:AEvent):void {
		//trace(m_radioGroupA.selectedIndex);
		this.selectedIndex = m_radioGroupA.selectedIndex;
	}
	
	private function doUpdateMode(positive:Boolean): void{
		var tween_A:ATween;
		var index_A:int;
		var initX:Number;
		var oldIconFN:FusionAA;
		
		//TweenMachine.getInstance().stopAll();
		
		tween_A = TweenMachine.getInstance().to(m_tabFusion, ViewConfig.TAB_DURA, {x:-m_selectedIndex * GAP_W});
		tween_A.easing = Quad.easeOut;
		
		index_A = m_radioGroupA.selectedIndex = this.selectedIndex;
		
//		m_iconFN.killAllNodes();
		
		oldIconFN = m_iconFN;
		initX = positive ? -ICON_TWEEN_OFFSET_X : ICON_TWEEN_OFFSET_X;
		tween_A = TweenMachine.getInstance().to(oldIconFN, ViewConfig.TAB_DURA * 0.8, {x:initX, alpha:0.0});
		tween_A.easing = Quad.easeOut;
		tween_A.onComplete = function() : void {
			oldIconFN.kill();
		}
		m_iconFN = new CFusionAA;
		this.getFusion().addNodeAt(m_iconFN, 0);
		
		if(index_A == 0){
			this.doShowLong(positive);
		}
		else if(index_A == 1){
			this.doShowFree(positive);
		}
		else if(index_A == 2){
			this.doShowREC(positive);
		}
	}
	
	private function doShowLong(positive:Boolean) : void {
		var img_A:ImageAA;
		var initX:Number;
		var tween_A:ATween;
		var reco_A:LongPressGestureRecognizer;
		
		img_A = new ImageAA;
		img_A.textureId = "temp/bg3.png";
		m_iconFN.addNode(img_A);
		img_A.x = -this.getRoot().getWindow().rootWidth / 2;
		img_A.y = -275;
		//TweenMachine.getInstance().from(img_A, ViewConfig.TAB_DURA, { alpha:0.05}).easing = Quad.easeOut;
		
		img_A = new ImageAA;
		img_A.textureId = ResUtil.getTemp("modeA_btnLong");
		img_A.pivotX = img_A.sourceWidth / 2;
		img_A.pivotY = img_A.sourceHeight / 2;
		m_iconFN.addNode(img_A);
		img_A.y = ICON_OFFSET_Y;
		
		initX = positive ? ICON_TWEEN_OFFSET_X : -ICON_TWEEN_OFFSET_X;
		tween_A = TweenMachine.getInstance().from(img_A, ViewConfig.TAB_DURA, {x:initX, alpha:0.05});
		tween_A.easing = Quad.easeOut;
		
		//img_A.addEventListener(NTouchEvent.CLICK, ____onGotoLongMode);
		
//		reco_A = img_A.recognize(LongPressGestureRecognizer, ____onGotoLongMode) as LongPressGestureRecognizer;
//		reco_A.setDelay(0.2);
		img_A.addEventListener(NTouchEvent.CLICK, ____onGotoLongMode);
	}
	
	private function ____onGotoLongMode(e:NTouchEvent) : void {
		//this.getFusion().touchable = false;
		
		EventUtil.view.dispatchEvent(new GotoModeEvent(GotoModeEvent.LONG));
		
//		e.touch.addEventListener(AEvent.COMPLETE, ____onLongComplete);
		
		
	}
	
	private function doShowFree(positive:Boolean) : void {
		var i:int;
		var l:int;
		var startX:Number;
		var img_A:ImageAA;
		var initX:Number;
		var tween_A:ATween;
		var fusion_A:FusionAA;
		
		fusion_A = new FusionAA;
		m_iconFN.addNode(fusion_A);
		
		l = 4;
		startX = (this.getRoot().getWindow().rootWidth - FREE_GAP_X * 3) / 2;
		while(i < l) {
			img_A = new ImageAA;
			img_A.textureId = ResUtil.getTemp("free" + (i+1));
			img_A.pivotX = img_A.sourceWidth / 2;
			img_A.pivotY = img_A.sourceHeight / 2;
			img_A.scaleX = img_A.scaleY = 1.2;
			fusion_A.addNode(img_A);
			img_A.x = -this.getRoot().getWindow().rootWidth/2 + startX + FREE_GAP_X * i++;
			img_A.y = -165;
			
			img_A.addEventListener(NTouchEvent.CLICK, ____onGotoFreeMode);
		}
		i = 0;
		l = 3;
		startX = (this.getRoot().getWindow().rootWidth - FREE_GAP_X * 2) / 2;
		while(i < l) {
			img_A = new ImageAA;
			img_A.textureId = ResUtil.getTemp("free0");
			img_A.pivotX = img_A.sourceWidth / 2;
			img_A.pivotY = img_A.sourceHeight / 2;
			img_A.scaleX = img_A.scaleY = 1.2;
			fusion_A.addNode(img_A);
			img_A.x = -this.getRoot().getWindow().rootWidth/2 + startX + FREE_GAP_X * i++;
			img_A.y = -165;
		}
		
		initX = positive ? ICON_TWEEN_OFFSET_X : -ICON_TWEEN_OFFSET_X;
		tween_A = TweenMachine.getInstance().from(fusion_A, ViewConfig.TAB_DURA, {x:initX, alpha:0.05});
		tween_A.easing = Quad.easeOut;
	}
	
	private function ____onGotoFreeMode(e:NTouchEvent) : void {
		EventUtil.view.dispatchEvent(new GotoModeEvent(GotoModeEvent.FREE));
	}
	
	private function doShowREC(positive:Boolean) : void {
		var initX:Number;
		var tween_A:ATween;
		var img_A:ImageAA;
		
		img_A = new ImageAA;
		img_A.textureId = "temp/bg3.png";
		m_iconFN.addNode(img_A);
		img_A.x = -this.getRoot().getWindow().rootWidth / 2;
		img_A.y = -275;
		//TweenMachine.getInstance().from(img_A, ViewConfig.TAB_DURA, { alpha:0.05}).easing = Quad.easeOut;
		
		img_A = new ImageAA;
		img_A.textureId = ResUtil.getTemp("modeC_btnRec");
		img_A.pivotX = img_A.sourceWidth / 2;
		img_A.pivotY = img_A.sourceHeight / 2;
		m_iconFN.addNode(img_A);
		img_A.y = ICON_OFFSET_Y;
		
		
		initX = positive ? ICON_TWEEN_OFFSET_X : -ICON_TWEEN_OFFSET_X;
		tween_A = TweenMachine.getInstance().from(img_A, ViewConfig.TAB_DURA, {x:initX, alpha:0.05});
		tween_A.easing = Quad.easeOut;
		
		img_A.addEventListener(NTouchEvent.CLICK, ____onGotoRecMode);
	}
	
	private function ____onGotoRecMode(e:NTouchEvent) : void {
		//this.getFusion().touchable = false;
		
		EventUtil.view.dispatchEvent(new GotoModeEvent(GotoModeEvent.REC));
		
//		e.touch.addEventListener(AEvent.COMPLETE, ____onRecComplete);
		
		//this.getRoot().getNode().addEventListener(NTouchEvent.RELEASE, ____onRecComplete);
	}
	
	private function ____onRecComplete(e:AEvent):void {
		this.getRoot().getNode().removeEventListener(NTouchEvent.RELEASE, ____onRecComplete);
		
		EventUtil.view.dispatchEvent(new GotoModeEvent(GotoModeEvent.REC_COMPLETE));
	}
	
	
}
}