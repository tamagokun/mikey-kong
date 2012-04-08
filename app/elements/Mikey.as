package elements
{
	import org.flixel.*;
	
	public class Mikey extends FlxSprite
	{
		public var ladder:Boolean = false;
		public var climbing:Boolean = false;
		
		private var _parent:PlayState;
		
		[Embed(source="../../assets/mikey.png")] private var ImgMikey:Class;
		
		public function Mikey(parent:PlayState):void
		{
			super(0,0,ImgMikey);
			_parent = parent;
			
			x = 50;
			
			var run_speed:uint = 80;
			drag.x = run_speed * 8;
			acceleration.y = 420;
			maxVelocity.x = run_speed;
			maxVelocity.y = 200;
		}
		
		public function handle_brick(Brick:FlxSprite):void
		{
			/*Brick.allowCollisions = FlxObject.ANY;
			if(climbing)
				Brick.allowCollisions = FlxObject.NONE;
			else FlxObject.separate(Brick,this);
			*/
		}
		
		override public function update():void
		{
			acceleration.x = 0;
			if(FlxG.keys.LEFT && !climbing)
				acceleration.x = -maxVelocity.x*4;
			if(FlxG.keys.RIGHT && !climbing)
				acceleration.x = maxVelocity.x*4;
			if(FlxG.keys.justPressed("SPACE") && isTouching(FlxObject.FLOOR))
				velocity.y = -maxVelocity.y/2;
			
			ladder = FlxG.overlap(_parent.level.ladders, this);
			
			if(FlxG.keys.UP)
			{
				if(ladder)
				{
					climbing = true;
				}
			}
			if(FlxG.keys.DOWN)
			{
				if(ladder)
				{
					climbing = true;
				}
			}
			
			if(FlxG.keys.UP && climbing)
			{
				velocity.y = -16;
			}
			else if(FlxG.keys.DOWN && climbing)
			{
				velocity.y = 16;
			}
			else if(climbing) velocity.y = 0;
			
			if(!ladder)
			{
				climbing = false;
				
			}
			
			/*if(FlxG.overlap(_parent.level.ladders, this))
			{
				ladder = true;
				if(FlxG.keys.UP || FlxG.keys.DOWN)
				{
					mikey.climbing = true;
					//if(mikey.y + mikey.height > Ladder.y && mikey.y + mikey.height <= Ladder.y + Ladder.height)
					//	Mikey(mikey).climbing = true;
				}
				if(y + height <= Ladder.y) mikey.climbing = false;
				if(y + height >= Ladder.y + Ladder.height) mikey.climbing = false;
				if(FlxG.keys.UP && climbing)
				{
					velocity.y = -16;
				}
				else if(FlxG.keys.DOWN && climbing)
				{
					velocity.y = 16;
				}
				else if(climbing) velocity.y = 0;
			}else
			{
				mikey.ladder = false;
				mikey.climbing = false;
			}*/
			
			if(climbing) {
				acceleration.y = 0;
			}else
			{
				acceleration.y = 420;
				solid = true;
			}
			
			/*if(ladder)
			{
				if(y + height <= ladder.y) climbing = false;
				if(y + height >= ladder.y + ladder.height) climbing = false;
			}*/
			
			super.update();
			
			
		}
	}
}