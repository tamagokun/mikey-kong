package elements
{
	import org.flixel.*;
	
	public class Barrel extends FlxSprite
	{
		public var ladder:int = -1;
		private var _speed:uint = 55;
		
		[Embed(source="../../assets/barrel-roll.gif")] private var ImgBarrel:Class;
		
		public function Barrel(X:int,Y:int):void
		{
			super(X,Y);
			loadGraphic(ImgBarrel,true,false,15,14);
			
			addAnimation("Roll",[0,1,2,3],6+FlxG.random()*4);
			addAnimation("Ladder",[4,5],6+FlxG.random()*4);
			
			play("Roll");
			
			elasticity = 0.35;
			acceleration.y = 420;
			right();
		}
		
		public function left():void
		{
			facing = LEFT;
			velocity.x = -_speed;
		}
		
		public function right():void
		{
			facing = RIGHT;
			velocity.x = _speed;
		}
		
		override public function update():void
		{
			if(x >= 224) left();
			if(x <= 5) right();
			
			if(ladder > -1)
			{
				play("Ladder");
				acceleration.y = 0;
				velocity.x = 0;
				velocity.y = _speed;
				allowCollisions = UP;
				
				if(y > ladder)
				{
					solid = true;
					if(isTouching(FLOOR))
					{
						play("Roll");
						ladder = -1;
						acceleration.y = 420;
						velocity.y = 0;
						if(facing & LEFT) right();
						else left();
					}
				}
			}
			if( x <= 8 && y >= 230 || y > FlxG.height) kill();
			super.update();
		}
	}
}