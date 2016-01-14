package views.AA {
	import d2armor.display.StateAA;
	import d2armor.events.AEvent;
	import d2armor.resource.FilesBundle;
	import d2armor.resource.ResMachine;
	import d2armor.resource.handlers.AtlasAA_BundleHandler;
	import d2armor.resource.handlers.FrameClip_BundleHandler;
	import d2armor.resource.handlers.TextureAA_BundleHandler;
	import d2armor.ui.skins.SkinManager;
	import d2armor.ui.skins.ToggleSkin;
	
public class Res_StateAA extends StateAA {
	
	override public function onEnter() : void {
		var AY:Vector.<String>;
		
		this.resA = new ResMachine("common/");
		
		AY = new <String> ["data/frameClip_A.xml"];
		this.resA.addBundle(new FilesBundle(AY), new FrameClip_BundleHandler);
		
		AY = new <String>["atlas/timer.atlas"];
		this.resA.addBundle(new FilesBundle(AY), new AtlasAA_BundleHandler(1.0, false, false, "atlas"));
		
		AY = new <String>
			[
				"temp/alpha_mask.png",
				"temp/bg_dark2.png",
				"temp/bg1.png", 
				"temp/bg2.png",
				"temp/bg3.png",
				"temp/block.png",
				"temp/modeA_btnLong.png",
				"temp/modeC_btnRec.png",
				"temp/tab0.png",
				"temp/tabA0.png",
				"temp/tab1.png",
				"temp/tabA1.png",
				"temp/tab2.png",
				"temp/tabA2.png",
				
				"temp/free0.png",
				"temp/free1.png",
				"temp/free2.png",
				"temp/free3.png",
				"temp/free4.png",
				
				"temp/freeMenu.png",
				"temp/page.png",
				"temp/long_tips.png",
				"temp/s9_dark.png",
				"temp/s9_white.png",
				"temp/long_bg1.png",
				
				"temp/rightIcon.png",
				"temp/wrongIcon.png",
				"temp/phoneBg.png",
				"temp/smallPage.png",
				"temp/long_bottom.png",
				"temp/roundIcon.png",
				
				"temp/timeBg.png"
			]
		this.resA.addBundle(new FilesBundle(AY), new TextureAA_BundleHandler(1.0, false, false));
		
		AY = new <String>
			[
				"temp/tab0.png",
				"temp/tabA0.png",
			];
		SkinManager.registerSkin("tab0", new ToggleSkin(AY, 0, 0, 0, 0, 1, 1, 1, 1));
		
		AY = new <String>
			[
				"temp/tab1.png",
				"temp/tabA1.png",
			];
		SkinManager.registerSkin("tab1", new ToggleSkin(AY, 0, 0, 0, 0, 1, 1, 1, 1));
		
		AY = new <String>
			[
				"temp/tab2.png",
				"temp/tabA2.png",
			];
		SkinManager.registerSkin("tab2", new ToggleSkin(AY, 0, 0, 0, 0, 1, 1, 1, 1));
		
		
		this.resA.addEventListener(AEvent.COMPLETE, onComplete);
	}
	
	public var resA:ResMachine;
	
	private function onComplete(e:AEvent):void {
		var AY:Array;
		var i:int;
		var l:int;
		
		this.resA.removeAllListeners();
		this.getFusion().kill();
		
		AY = this.getArg(0);
		l = AY.length;
		while (i < l) {
			this.getRoot().getView(AY[i++]).activate();
		}
	}
}
}