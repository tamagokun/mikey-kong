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
			
		override public function update():void
		{
			acceleration.x = 0;
			if(FlxG.keys.LEFT && !climbing)
				acceleration.x = -maxVelocity.x*4;
			if(FlxG.keys.RIGHT && !climbing)
				acceleration.x = maxVelocity.x*4;
			if(FlxG.keys.justPressed("SPACE") && isTouching(FlxObject.FLOOR))
				velocity.y = -maxVelocity.y/2;
			
			if(FlxG.keys.UP && climbing) velocity.y = -16;
			else if(FlxG.keys.DOWN && climbing) velocity.y = 16;
			else if(climbing) velocity.y = 0;
			
			if(FlxG.overlap(_parent.level.ladders, this, handle_ladders))
			{
				if(ladder)
				{
					if(climbing && isTouching(FlxObject.FLOOR))
					{
						climbing = false;
						solid = true;
					}
					if(FlxG.keys.UP) climbing = true;
				}
			}else
			{
				ladder = false;
				climbing = false;
				solid = true;
			}
			
			if(!ladder) climbing = false;
			if(climbing) {
				acceleration.y = 0;
			}else
			{
				acceleration.y = 420;
				solid = true;
			}
			super.update();
		}
		
		public function handle_ladders(Ladder:FlxSprite, Mikey:FlxSprite):void
		{
			if(x + (width*.5) > Ladder.x && x + (width*.5) < Ladder.x + Ladder.width)
				ladder = true;
			
			if(FlxG.keys.UP && climbing)
			{
				allowCollisions = FlxObject.DOWN;
			}
			if(climbing) x = Ladder.x - 2;
		}
	}
}