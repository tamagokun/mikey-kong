package
{
	import org.flixel.*;
	import elements.*;

	public class IntroState extends FlxState
	{
		public var stairs:FlxGroup;
		public var bricks:FlxGroup;
		public var ladders:FlxGroup;
		
		[Embed(source="../assets/brick.png")] private var ImgBrick:Class;
		[Embed(source="../assets/ladder.gif")] private var ImgLadder:Class;
		
		override public function create():void
		{	
			stairs = new FlxGroup();
			add(stairs);
			
			ladders = new FlxGroup();
			add(ladders);
			
			bricks = new FlxGroup();
			add(bricks);
			
			//bottom
			create_row(8,240,14);	//248
			create_stairs(120,247,7);
			
			create_stairs(208,220,13,false);
			
			create_stairs(24,187,13,true);
			
			create_stairs(208,154,13,false);
			
			create_stairs(24,121,13,true);
			
			create_stairs(208,89,5,false);
			
			//top
			create_row(8,84,16);
			create_row(96,56,6);
			
			//ladders
			place_ladder(72,32,52);
			place_ladder(88,32,52);
			
			place_ladder(136,56,28); //winning ladder
			
			place_ladder(120,92,148);
			place_ladder(136,92,148);
		}
		
		public function create_row(X:uint,Y:uint,count:uint):void
		{
			var i:uint = 0;
			for(i; i < count; i++) place_brick(X+i*8,Y);
		}
		
		public function create_stairs(X:int,Y:int,count:int,right:Boolean=true):void
		{
			var i:uint = 0;
			var j:uint = 0;
			var x_offset:int = 0;
			var y_offset:int = -count;
			for(i; i < count; i++)
			{
				var length:int = 2;
				for(j = 0; j < length; j++)
				{
					var brick:FlxSprite = place_item(X+x_offset,Y+y_offset,ImgBrick,stairs);
					brick.immovable = true;
					brick.allowCollisions = FlxObject.UP;
					x_offset += right? brick.width : -brick.width;
				}
			}
		}
		
		public function place_ladder(X:int,Y:int,height:int):void
		{
			var ladder:FlxTileblock = new FlxTileblock(X,Y,8,height);
			ladder.loadTiles(ImgLadder,8,4,0);
			ladders.add(ladder);
			ladder.frameHeight = height;
		}
		
		public function place_brick(X:int,Y:int):void
		{
			var brick:FlxSprite = place_item(X,Y,ImgBrick,bricks);
			brick.immovable = true;
		}
		
		protected function place_item(X:int,Y:int,Graphic:Class,Group:FlxGroup):FlxSprite
		{
			var item:FlxSprite = new FlxSprite(X,Y,Graphic);
			Group.add(item);
			return item;
		}
	}
}