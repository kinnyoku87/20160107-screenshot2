package views.AA {
	import d2armor.Armor;
	import d2armor.animate.TweenMachine;
	import d2armor.display.AAFacade;
	import d2armor.display.AnimeAA;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	import d2armor.display.textures.TextureAA;
	import d2armor.events.ATouchEvent;
	
	import util.ResUtil;
	
public class RawScreen_StateAA extends StateAA {
	
	override public function onEnter() : void {
		this.doInitBg();
	}
	
	
	private function doInitBg() : void {
		
		
		_screenImg = new ImageAA;
		_screenImg.textureId = ResUtil.getTemp("bg1");
		this.getFusion().addNode(_screenImg);
		
	}
	
	
	
	private var _screenImg:ImageAA;
	
	
}
}