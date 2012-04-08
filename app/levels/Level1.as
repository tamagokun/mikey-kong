package levels
{
	import org.flixel.*;
	
	public class Level1 extends Level
	{
		public var stairs:FlxGroup;
		
		[Embed(source="../../assets/brick.png")] private var ImgBrick:Class;
		[Embed(source="../../assets/ladder.png")] private var ImgLadder:Class;		
		
		public function Level1():void
		{
			super();
			stairs = new FlxGroup();
		}
		
		override public function create():void
		{
			//bottom
			create_row(8,224,15);
			create_stairs(128,223,5);
			
			create_stairs(216,188,9,false,true);
			
			create_stairs(32,158,9,true,true);
			
			create_stairs(216,128,9,false,true);
			
			create_stairs(32,98,9,true,true);
			
			create_stairs(216,68,4,false);
			
			place_ladder(10,10,2);
			
			//top
			create_row(16,64,14);
			create_row(104,40,6);
		}
		
		public function create_row(X:uint,Y:uint,count:uint):void
		{
			var i:uint = 0;
			for(i; i < count; i++) place_brick(X+i*8,Y);
		}
		
		public function create_stairs(X:int,Y:int,count:int,right:Boolean=true,shorten_last:Boolean=false):void
		{
			var i:uint = 0;
			var j:uint = 0;
			var x_offset:int = 0;
			var y_offset:int = 0;
			for(i; i < count; i++)
			{
				var length:int = shorten_last && i+1==count? 2 : 3;
				for(j = 0; j < length; j++)
				{
					var brick:FlxSprite = place_item(X+x_offset,Y+y_offset,ImgBrick,stairs);
					brick.immovable = true;
					x_offset += right? brick.width : -brick.width;
				}
				y_offset -= 1;
			}
		}

		public function place_brick(X:int,Y:int):void
		{
			var brick:FlxSprite = place_item(X,Y,ImgBrick,bricks);
			brick.immovable = true;
		}
		
		public function place_ladder(X:int,Y:int,height:int):void
		{
			var ladder:FlxSprite = place_item(X,Y,ImgLadder,ladders);
			var i:uint = 0;
			for(i; i < height; i++) ladder.stamp(ladder,0,i*8);
		}
	}
}