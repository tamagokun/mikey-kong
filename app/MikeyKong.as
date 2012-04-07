package
{
	import org.flixel.*;
	[SWF(width="", height="", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class MikeyKong extends FlxGame
	{
		public function MikeyKong():void
		{
			super(320,240,PlayState,2);	//zoom x2: 640,480
			forceDebugger = true;
		}
	}
}