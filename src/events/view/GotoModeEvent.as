package events.view
{
	import d2armor.events.AEvent;
	
	public class GotoModeEvent extends AEvent
	{
		public function GotoModeEvent(type:String)
		{
			super(type);
		}
		
		
		public static const LONG:String = "long";
		public static const LONG_COMPLETE:String = "longComplete";
		
		public static const FREE:String = "free";
		
		public static const REC:String = "rec";
		public static const REC_COMPLETE:String = "recComplete";
	}
}