package elements
{
	import org.flixel.*;
	
	public class Mikey extends FlxSprite
	{
		public var ladder:Boolean = false;
		public var climbing:Boolean = false;
		public var default_collisions:int = 0;

		private var _parent:PlayState;
		
		[Embed(source="../../assets/jumpman.gif")] private var ImgMikey:Class;
		
		public function Mikey(parent:PlayState):void
		{
			super(0,0);
			loadGraphic(ImgMikey,true,true,22,16);
			_parent = parent;
			default_collisions = DOWN;
			
			x = 50;
			width = 12;
			
			addAnimation("standing",[0],0);
			addAnimation("jumping",[1],0);
			addAnimation("walking",[1,0,2,0],6+FlxG.random()*4);
			addAnimation("ladder-idle",[3],0);
			addAnimation("ladder-climbing",[3,4],6+FlxG.random()*8);
			addAnimation("ladder-top",[5,6,7],6+FlxG.random()*8);
			addAnimation("hammer",[9,10],6+FlxG.random()*4,false);
			
			var run_speed:uint = 40;
			drag.x = run_speed * 8;
			acceleration.y = 420;
			maxVelocity.x = run_speed;
			maxVelocity.y = 200;
		}
			
		override public function update():void
		{
			acceleration.x = 0;
			if(FlxG.keys.LEFT || FlxG.keys.RIGHT && !climbing)
			{
				acceleration.x = FlxG.keys.LEFT? -maxVelocity.x*4 : maxVelocity.x*4;
				facing = FlxG.keys.LEFT? LEFT : RIGHT;
			}
			if(!climbing)
			{
				if(velocity.y != 0) play("jumping");
				else play(velocity.x != 0? "walking" : "standing");
			}
			
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
						allowCollisions = default_collisions;
					}
					if(FlxG.keys.UP) climbing = true;
				}
			}else
			{
				ladder = false;
				climbing = false;
				allowCollisions = default_collisions;
			}
			
			if(!ladder) climbing = false;
			if(climbing) {
				acceleration.y = 0;
				play(velocity.y != 0? "ladder-climbing" : "ladder-idle");
			}else
			{
				acceleration.y = 420;
				allowCollisions = default_collisions;
			}
			super.update();
		}
		
		public function handle_ladders(Ladder:FlxSprite, Mikey:FlxSprite):void
		{
			if(x + (width*.5) > Ladder.x && x + (width*.5) < Ladder.x + Ladder.width)
				ladder = true;
			
			if(FlxG.keys.UP && climbing)
			{
				allowCollisions = default_collisions;
			}
			if(climbing) x = Ladder.x - 7;
		}
	}
}