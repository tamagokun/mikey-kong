package elements
{
	import org.flixel.*;
	
	public class Mikey extends FlxSprite
	{
		public var on_ladder:Boolean = false;
		public var climbing:Boolean = false;
		
		[Embed(source="../../assets/mikey.png")] private var ImgMikey:Class;
		
		public function Mikey():void
		{
			super(0,0,ImgMikey);
			
			x = 50;
			
			var run_speed:uint = 80;
			drag.x = run_speed * 8;
			acceleration.y = 420;
			maxVelocity.x = run_speed;
			maxVelocity.y = 200;
		}
		
		public function handle_brick(Brick:FlxSprite):void
		{
			if(isTouching(FlxObject.CEILING) && climbing)
			{
				//no collision!
				Brick.allowCollisions = FlxObject.NONE;
			}else
			{
				climbing = false;
			}
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
			
			if(on_ladder)
			{
				acceleration.y = 0;
				if(FlxG.keys.UP)
				{
					velocity.y = -16;
					climbing = true;
				}
				else if(FlxG.keys.DOWN)
				{
					velocity.y = 16;
					climbing = true;
				}else velocity.y = 0;
			}else
			{
				acceleration.y = 420;
			}
			on_ladder = false;
			
			super.update();
		}
	}
}