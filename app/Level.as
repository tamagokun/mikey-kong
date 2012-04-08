package
{
	import org.flixel.*;
	
	public class Level
	{
		public var bricks:FlxGroup;
		public var ladders:FlxGroup;
		
		public function Level():void {
			bricks = new FlxGroup();
			ladders = new FlxGroup();
		}
		
		public function create():void
		{
			
		}
		
		public function place_item(X:int,Y:int,Graphic:Class,Group:FlxGroup):FlxSprite
		{
			var item:FlxSprite = new FlxSprite(X,Y,Graphic);
			Group.add(item);
			return item;
		}
	}
}