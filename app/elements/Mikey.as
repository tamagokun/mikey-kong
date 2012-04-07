package elements
{
	public class Mikey extends FlxSprite
	{
		[Embed(source="../../assets/mikey.gif")] private var ImgMikey:Class;
		
		public function Mikey():void
		{
			super(0,0,ImgMikey);
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