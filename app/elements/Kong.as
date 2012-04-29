package elements
{
	import org.flixel.*;
	
	public class Kong extends FlxSprite
	{
		[Embed(source="../../assets/kong.gif")] private var ImgKong:Class;
		
		public function Kong():void
		{
			super(0,0);
			loadGraphic(ImgKong,true,true,36,52);
			_parent = parent;
		}
	}
}