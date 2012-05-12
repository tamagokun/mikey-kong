package
{
	import org.flixel.*;
	
	public class Level
	{
		public var bricks:FlxGroup;
		public var ladders:FlxGroup;
		public var ladder_checks:FlxGroup;
		public var bgm:FlxSound;
		
		protected var state:PlayState;
		
		public function Level(state:FlxState):void {
			this.state = PlayState(state);
			bricks = new FlxGroup();
			ladders = new FlxGroup();
			ladder_checks = new FlxGroup();
		}
		
		public function create():void
		{
			
		}
		
		public function completed():Boolean
		{
			return false;
		}
		
		protected function place_item(X:int,Y:int,Graphic:Class,Group:FlxGroup):FlxSprite
		{
			var item:FlxSprite = new FlxSprite(X,Y,Graphic);
			Group.add(item);
			return item;
		}
	}
}