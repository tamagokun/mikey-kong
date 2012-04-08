package elements
{
	import org.flixel.*;
	
	public class Mikey extends FlxSprite
	{
		[Embed(source="../../assets/mikey.gif")] private var ImgMikey:Class;
		
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
		
		override public function update():void
		{
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
				acceleration.x = -maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				acceleration.x = maxVelocity.x*4;
			if(FlxG.keys.justPressed("SPACE") && isTouching(FlxObject.FLOOR))
				velocity.y = -maxVelocity.y/2;
			
			super.update();
		}
	}
}