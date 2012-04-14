package elements
{
	import org.flixel.*;
	
	public class Barrel extends FlxSprite
	{
		public var ladder:Boolean = false;
		private var _under_ladder:int = 0;
		
		[Embed(source="../../assets/barrel-roll.gif")] private var ImgBarrel:Class;
		[Embed(source="../../assets/barrel-ladder.gif")] private var ImgBarrelLadder:Class;
		
		public function Barrel(X:int,Y:int):void
		{
			super(X,Y);
			loadGraphic(ImgBarrel,true,false,12,10);
			
			addAnimation("Roll",[0,1,2,3],6+FlxG.random()*4);
			
			play("Roll");
			
			elasticity = 0.25;
			acceleration.y = 420;
			velocity.x = 20;
		}
		
		public function down_ladder(switch_point:int):void
		{
			this.ladder = true;
			this._under_ladder = switch_point;
			acceleration.y = 0;
			velocity.x = 0;
			velocity.y = 20;
			allowCollisions = UP;
		}
		
		public function left():void
		{
			facing = LEFT;
			velocity.x = -20;
		}
		
		public function right():void
		{
			facing = RIGHT;
			velocity.x = 20;
		}
		
		override public function update():void
		{
			if(x >= 224) left();
			if(x <= 8) right();
			
			if(ladder && y + (height*.5) > _under_ladder) solid = true;
			if(ladder && isTouching(FLOOR))
			{
				ladder = false;
				_under_ladder = 0;
				acceleration.y = 420;
				velocity.y = 0;
				if(facing == LEFT) right();
				else left();
			}
			if( x <= 8 && y >= 230) kill();
			super.update();
		}
	}
}