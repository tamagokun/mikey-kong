package
{
	import org.flixel.*;
	[SWF(width="512", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class MikeyKong extends FlxGame
	{
		public function MikeyKong():void
		{
			super(256,240,PlayState,2);
			forceDebugger = true;
		}
	}
}