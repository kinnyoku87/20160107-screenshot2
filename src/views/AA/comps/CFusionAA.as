package views.AA.comps
{
	import d2armor.display.FusionAA;
	import d2armor.utils.inside.armor_internal;
	
	use namespace armor_internal;
	
	public class CFusionAA extends FusionAA
	{
		public function CFusionAA()
		{
			super();
		}
		
		
		override armor_internal function doRender() : void {
			//trace("A");
			
			super.doRender();
			
			
		}
	}
}