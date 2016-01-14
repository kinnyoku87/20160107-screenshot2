package views.AA
{
	import configs.ViewConfig;
	
	import d2armor.animate.TweenMachine;
	import d2armor.animate.core.ATween;
	import d2armor.animate.easing.Quad;
	import d2armor.display.FusionAA;
	import d2armor.display.StateAA;
	import d2armor.display.StateFusionAA;
	import d2armor.enum.EDirection;
	import d2armor.gesture.SwipeGestureRecognizer;
	
	import events.EventUtil;
	import events.view.GotoModeEvent;
	import events.view.ScreenshotModeEvent;
	
	import views.AA.comps.ModeTab_StateAA;
	
	public class ModeB_StateAA extends StateAA {
		
		override public function onEnter():void {
			var stateFN:StateFusionAA;
			
//			_bottomFN = new FusionAA;
//			this.getFusion().addNode(_bottomFN);
			
			stateFN = new StateFusionAA;
			this.getFusion().addNode(stateFN);
			stateFN.setState(ModeTab_StateAA);
			_tabState = stateFN.getState() as ModeTab_StateAA;
			
			stateFN.x = this.getRoot().getWindow().rootWidth / 2;
			stateFN.y = this.getRoot().getWindow().rootHeight - 70;
			
			_rocoA = this.getRoot().getNode().recognize(SwipeGestureRecognizer, ____onSwipe) as SwipeGestureRecognizer;
			SwipeGestureRecognizer.setDistance(80);
			
			this.insertEventListener(EventUtil.view, ScreenshotModeEvent.MODE_CHANGED, ____onModeChanged);
			this.insertEventListener(EventUtil.view, GotoModeEvent.LONG,               ____onGotoMode);
			this.insertEventListener(EventUtil.view, GotoModeEvent.FREE,               ____onGotoMode);
			this.insertEventListener(EventUtil.view, GotoModeEvent.REC,                ____onGotoMode);
		}
		
		override public function onExit():void {
			this.getRoot().getNode().unrecognize(_rocoA);
		}
		
		
		
		private var _tabState:ModeTab_StateAA;
		private var _rocoA:SwipeGestureRecognizer;
		
		
		
		private function ____onSwipe(e:SwipeGestureRecognizer):void{
			if(e.getDirection() == EDirection.LEFT) {
				_tabState.selectedIndex++;
			}
			else if(e.getDirection() == EDirection.RIGHT) {
				_tabState.selectedIndex--;
			}
		}
		
		private function ____onModeChanged(e:ScreenshotModeEvent ) : void {
			var index_A:int;
			
			index_A = e.index;
			_tabState.updateMode(e.positive);
			//trace(e.positive);
			
//			if(index_A == 0){
//				
//			}
//			else if(index_A == 1){
//				
//			}
//			else if(index_A == 2){
//				
//			}
		}
		
		private function ____onGotoMode(e:GotoModeEvent) : void {
			var tween_A:ATween;
			
			this.getRoot().getNode().unrecognize(_rocoA);
			//if(e.type == GotoModeEvent.FREE) {
				tween_A = TweenMachine.to(this.getFusion(), ViewConfig.GOTO_MODE_DURA, { alpha:0.0, y:300 });
			//}
			if(tween_A) {
				tween_A.onComplete = function() : void {
					getFusion().kill();
				}
				tween_A.easing = Quad.easeInOut;
			}
			
		}
		
	}
}