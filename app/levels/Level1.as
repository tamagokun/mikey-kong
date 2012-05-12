package levels
{
	import org.flixel.*;
	
	public class Level1 extends Level
	{
		public var stairs:FlxGroup;
		
		[Embed(source="../../assets/brick.png")] private var ImgBrick:Class;
		[Embed(source="../../assets/ladder.png")] private var ImgLadder:Class;
		[Embed(source="../../assets/barrel-hoarde.gif")] private var ImgBarrelHoarde:Class;
		
		public function Level1(state:FlxState):void
		{
			super(state);
			stairs = new FlxGroup();
		}
		
		override public function create():void
		{
			//bottom
			create_row(8,248,14);
			create_stairs(120,247,7);
			
			create_stairs(208,220,13,false);
			
			create_stairs(24,187,13,true);
			
			create_stairs(208,154,13,false);
			
			create_stairs(24,121,13,true);
			
			create_stairs(208,88,5,false);
			
			//top
			create_row(8,84,16);
			create_row(96,56,6);
			
			//ladders
			place_ladder(88,213,11);
			place_ladder(88,240,8);
			place_ladder(192,219,24);
			place_ladder(104,182,32);
			place_ladder(40,186,24);
			place_ladder(72,146,14);
			place_ladder(72,176,8);
			place_ladder(120,149,32);
			place_ladder(192,153,24);
			place_ladder(40,120,24);
			place_ladder(80,118,28);
			place_ladder(176,112,16);
			place_ladder(176,144,8);
			place_ladder(96,84,12);
			place_ladder(96,104,13);
			place_ladder(192,87,24);
			place_ladder(136,56,28); //winning ladder
			place_ladder(72,32,52);
			place_ladder(88,32,52);
			
			//barrel hoarde
			place_item(8,52,ImgBarrelHoarde,state);
		}
		
		override public function completed():Boolean
		{
			return (state.mikey.x <= 144 && state.mikey.x >= 130 && state.mikey.y <= 42);
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
			var y_offset:int = 0;
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
			var ladder:FlxTileblock = new FlxTileblock(X,Y,8,height);
			ladder.loadTiles(ImgLadder,8,8,0);
			ladders.add(ladder);
			ladder.frameHeight = height;
			var hit_area:FlxSprite = new FlxSprite(X,Y - 8);
			hit_area.makeGraphic(8,8,0xffffffff);
			ladder_checks.add(hit_area);
		}
	}
}