package app {
	import flash.display.Stage;
	
	import d2armor.Armor;
	import d2armor.activity.AWindow;
	import d2armor.app.ILauncher;
	import d2armor.display.AAFacade;
	import d2armor.display.RootAA;
	import d2armor.events.AEvent;
	import d2armor.resource.ResMachine;
	import d2armor.resource.converters.AtlasAssetConvert;
	import d2armor.resource.converters.SwfClassAssetConverter;
	
	import views.StateInfo;
	import views.AA.Hotspot_StateAA;
	import views.AA.ModeA_StateAA;
	import views.AA.ModeB_StateAA;
	import views.AA.RawScreen_StateAA;
	import views.AA.Res_StateAA;
	import views.AA.comps.LongTimer_StateAA;
	import views.AA.comps.MicroLong_StateAA;
	

	public class Launcher160107_A implements ILauncher {
		
		private var _adapter:AWindow;
		private var _rootAA:RootAA;
		
		public function onLaunch( stage:Stage ) : void {
			//stage.quality = StageQuality.LOW;
			//stage.quality = StageQuality.MEDIUM
			//stage.quality = StageQuality.HIGH;
			
			this._adapter = Armor.createWindow(stage, false);
			
			ResMachine.activate(SwfClassAssetConverter);
			ResMachine.activate(AtlasAssetConvert);
			
			AAFacade.registerView("res",        Res_StateAA);
			AAFacade.registerView(StateInfo.RAW_SCREEN,         RawScreen_StateAA);
			AAFacade.registerView("hotspot",    Hotspot_StateAA);
			AAFacade.registerView(StateInfo.MODE_A, ModeA_StateAA);
			AAFacade.registerView(StateInfo.MODE_B, ModeB_StateAA);
			
			AAFacade.registerView("test", LongTimer_StateAA);
			
			_rootAA = AAFacade.createRoot(this._adapter, 0xFFFFFF, true);
			_rootAA.addEventListener(AEvent.COMPLETE, onStart);
		}
		
		private function onStart(e:AEvent):void {	
			_rootAA.removeEventListener(AEvent.START, onStart);
			
			_rootAA.getView("res").activate([[StateInfo.RAW_SCREEN, "hotspot"]]);
			
//			_rootAA.getView("res").activate([["bg", "modeB"]]);
			
//			_rootAA.getView("res").activate([["test"]]);
			
//			_rootAA.getNode().doubleClickEnabled = true;
//			_rootAA.getNode().addEventListener(ATouchEvent.DOUBLE_CLICK, function(e:ATouchEvent):void{
//				_rootAA.getView("screenSplit").activate();
//			});
		}
	}
}