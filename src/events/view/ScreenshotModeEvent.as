package events.view
{
	import d2armor.events.AEvent;
	
	public class ScreenshotModeEvent extends AEvent
	{
		public function ScreenshotModeEvent(type:String, index:int, positive:Boolean)
		{
			super(type);
			this.index = index;
			this.positive = positive;
		}
		
		
		public static const MODE_CHANGED:String = "modeChanged";
		
		
		public var index:int;
		public var positive:Boolean;
	}
}