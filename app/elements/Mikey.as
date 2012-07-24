package elements
{
	import org.flixel.*;
	
	public class Mikey extends FlxSprite
	{
		public var lives:int = 0;
		public var jumping:Boolean = false;
		public var ladder:Boolean = false;
		public var climbing:Boolean = false;
		public var default_collisions:int = 0;
		private var _climb_speed:uint = 20;
		private var _walk_sfx:FlxSound;
		private var _jump_sfx:FlxSound;

		private var _parent:PlayState;
		
		[Embed(source="../../assets/mikey.gif")] private var ImgMikey:Class;
		[Embed(source="../../assets/audio/jump.mp3")] private var SndJump:Class;
		[Embed(source="../../assets/audio/walking.mp3")] private var SndWalk:Class;
		
		public function Mikey(parent:PlayState):void
		{
			super(31,228);
			loadGraphic(ImgMikey,true,true,22,16);
			_parent = parent;
			default_collisions = DOWN;
			
			width = 10;
			offset.x = 3;
			
			addAnimation("standing",[0],0);
			addAnimation("jumping",[1],0);
			addAnimation("walking",[1,0,2,0],6+FlxG.random()*4);
			addAnimation("ladder-climbing",[3,4],6+FlxG.random()*4);
			addAnimation("ladder-top-up",[5,6,7],6+FlxG.random()*2,false);
			addAnimation("ladder-top-down",[7,6,5],6+FlxG.random()*2,false);
			addAnimation("hammer",[9,10],6+FlxG.random()*4,false);
			addAnimation("dead",[8],0);
			
			_walk_sfx = FlxG.loadSound(SndWalk,1,true);
			_jump_sfx = FlxG.loadSound(SndJump,1,false);
			
			var run_speed:uint = 45;
			drag.x = run_speed * 8;
			acceleration.y = 350;
			maxVelocity.x = run_speed;
			maxVelocity.y = 100;
		}
		
		override public function postUpdate():void
		{
			if(climbing)
			{
				if(velocity.y != 0) super.postUpdate();
			}else
				super.postUpdate();
		}

		public function clear_states():void
		{
			acceleration.x = 0;
			acceleration.y = 350;
			_walk_sfx.stop();
			_jump_sfx.stop();
			jumping = climbing = ladder = false;
		}

		override public function kill():void
		{
			if(!alive) return; //we're already dead...
			alive = false;
			clear_states();
			play("dead");
			_parent.died();
			
			if(lives < 0)
			{
				//GAME OVER
				_parent.game_over();
				return;
			}else
			{
				var dead_timer:FlxTimer = new FlxTimer();
				dead_timer.start(3,1,restart);
			}
		}

		public function restart(Timer:FlxTimer):void
		{
			_parent.reset();
		}
		
		override public function update():void
		{
			if(!_parent.active || _parent.completed) return;
			acceleration.x = 0;
			if(FlxG.keys.LEFT || FlxG.keys.RIGHT && !climbing)
			{
				acceleration.x = FlxG.keys.LEFT? -maxVelocity.x*4 : maxVelocity.x*4;
				facing = FlxG.keys.LEFT? LEFT : RIGHT;
				if(!jumping) _walk_sfx.play();
			}else _walk_sfx.stop();
			if(!climbing)
			{
				if(velocity.y != 0) play("jumping");
				else{
					play(velocity.x != 0? "walking" : "standing");
					jumping = false;
				}
			}
			
			if(FlxG.keys.justPressed("SPACE") && isTouching(FlxObject.FLOOR))
			{
				velocity.y = -maxVelocity.y;
				jumping = true;
				_walk_sfx.stop();
				_jump_sfx.play(true);
			}
			
			if(FlxG.keys.UP && climbing) velocity.y = -_climb_speed;
			else if(FlxG.keys.DOWN && climbing) velocity.y = _climb_speed;
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
			}else
			{
				acceleration.y = 350;
				allowCollisions = default_collisions;
			}
			super.update();
		}
		
		public function handle_ladders(Ladder:FlxSprite, Mikey:FlxSprite):void
		{
			if(jumping) return;
			if(x + (width*.5) > Ladder.x && x + (width*.5) < Ladder.x + Ladder.width)
				ladder = true;
			
			if(FlxG.keys.UP && climbing)
			{
				allowCollisions = default_collisions;
				if(y + 6 < Ladder.y) play("ladder-top-up");
				else play("ladder-climbing");
			}
			if(climbing) x = Ladder.x - 4;
		}
	}
}
