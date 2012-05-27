package
{
	import org.flixel.*;
	import elements.*;

	public class IntroState extends FlxState
	{
		public var stairs:FlxGroup;
		public var bricks:FlxGroup;
		public var ladders:FlxGroup;
		public var kong:Kong;
		
		private var ladder_1:FlxTileblock;
		private var ladder_2:FlxTileblock;

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
			
			ladder_1 = place_ladder(119,92,148);
			ladder_2 = place_ladder(136,92,148);
			
			kong = new Kong();
			add(kong);
			kong.y = 200;
			kong.x = 108;
			kong.velocity.y = -32;
			kong.play("climb");
		}
		
		override public function update():void
		{
			super.update();

			if(kong.bouncing)
			{
				if(kong.y > 49)
				{
					kong.y = 49;
					kong.velocity.x = 0;
					kong.velocity.y = 0;
					if(kong.x > 39) dk_bounce(45,75);
				}
			}
			
			if(kong.y <= 84 && kong.acceleration.y == 0 && !kong.bouncing)
			{
				kong.velocity.y = 0;
				kong.acceleration.x = 0;
				kong.acceleration.y = 350;
				kong.maxVelocity.y = 150;
				kong.velocity.y = -kong.maxVelocity.y;
				ladders.remove(ladder_1);
				ladders.remove(ladder_2);
			}
			
			if(kong.y > 49 && !kong.bouncing && kong.velocity.y > 0)
			{
				kong.play("standing");
				//place manda on da bricks
				dk_bounce(45,100);
			}
			
			if(ladder_1 && ladder_1.height > 32)
			{
				if(ladder_1.y + ladder_1.height > kong.y + kong.height + 20 && !kong.bouncing)
				{
					ladder_1.height = Math.max(0,ladder_1.height - 8);
					ladder_2.height = Math.max(0,ladder_2.height - 8);
					ladder_1.loadTiles(ImgLadder,8,4,0);
					ladder_2.loadTiles(ImgLadder,8,4,0);
				}
			}

		}
		
		public function dk_bounce(X:int,Y:int):void
		{
			kong.bouncing = true;
			kong.acceleration.x = 0;
			kong.acceleration.y = 350;
			kong.maxVelocity.x = X;
			kong.maxVelocity.y = Y;
			kong.velocity.x = -kong.maxVelocity.x;
			kong.velocity.y = -kong.maxVelocity.y;
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
		
		public function place_ladder(X:int,Y:int,height:int):FlxTileblock
		{
			var ladder:FlxTileblock = new FlxTileblock(X,Y,8,height);
			ladder.loadTiles(ImgLadder,8,4,0);
			ladders.add(ladder);
			return ladder;
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
