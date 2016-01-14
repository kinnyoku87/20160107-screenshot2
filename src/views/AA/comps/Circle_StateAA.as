package views.AA.comps
{
	import d2armor.Armor;
	import d2armor.display.AnimeAA;
	import d2armor.display.ImageAA;
	import d2armor.display.StateAA;
	
	import util.ResUtil;
	
public class Circle_StateAA extends StateAA
{
	
	public function start( onComplete:Function ) : void {
		_anime.getAnimation().timeScale = 4.0;
		_anime.getAnimation().start("atlas/circle", "circle.progress", 1, onComplete);
		
	}
	
	
	override public function onEnter() : void 
	{
		var imgA:ImageAA;
		
		imgA = new ImageAA;
		imgA.textureId = ResUtil.getTemp("loading");
		imgA.pivotX = imgA.sourceWidth / 2;
		imgA.pivotY = imgA.sourceHeight / 2;
		this.getFusion().addNode(imgA);
		
		_anime = new AnimeAA;
		this.getFusion().addNode(_anime);
		_anime.textureId = "atlas/circle1";
		_anime.pivotX = _anime.sourceWidth / 2;
		_anime.pivotY = _anime.sourceHeight / 2;
		
		imgA = new ImageAA;
		imgA.textureId = ResUtil.getTemp("pen");
		imgA.pivotX = imgA.sourceWidth / 2;
		imgA.pivotY = imgA.sourceHeight / 2;
		this.getFusion().addNode(imgA);
	}
	
	
	private var _anime:AnimeAA;
}
}