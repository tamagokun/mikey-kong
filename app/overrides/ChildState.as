package overrides
{
	import org.flixel.FlxState;

	public class ChildState extends FlxState
	{
		protected var main:MainState;

		public function set parent(main:MainState):void
		{
			this.main = main;
		}
	}
}
