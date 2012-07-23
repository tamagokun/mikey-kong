package
{
	import flash.events.Event;
	import org.flixel.*;
	[SWF(width="512", height="528", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class MikeyKong extends FlxGame
	{
		public function MikeyKong():void
		{
			super(256,264,MainState,2);
			forceDebugger = true;
		}
	}
}
