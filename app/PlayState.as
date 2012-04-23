package
{
	import org.flixel.*;
	import elements.*;
	import levels.*;
	
	public class PlayState extends FlxState
	{
		//public var exit:FlxSprite;
		public var level:*;
		public var barrels:FlxGroup;
		public var mikey:Mikey;
		public var score:FlxText;
		public var time:FlxText;
		
		override public function create():void
		{
			//level init stuff
			level = new Level1() as Level1;
			add(level.ladders);
			add(level.bricks);
			if(level.stairs) add(level.stairs);
			level.create();
			
			//create mikey!
			mikey = new Mikey(this);
			add(mikey);
			
			barrels = new FlxGroup();
			add(barrels);
			var barrel_timer:FlxTimer = new FlxTimer();
			barrel_timer.start(5,0,dk_throw);
		}
		
		public function dk_throw(Timer:FlxTimer):void
		{
			create_barrel(0,0);
		}
		
		public function create_barrel(X:uint,Y:uint):void
		{
			var barrel:Barrel = new Barrel(X,Y);
			barrels.add(barrel);
		}
		
		override public function update():void
		{		
			super.update();
			
			FlxG.overlap(barrels, mikey, touch_barrel);
			//FlxG.overlap(exit, mikey, win);
			FlxG.collide(level.bricks, barrels);
			FlxG.collide(level.stairs, barrels);
			
			FlxG.overlap(level.ladders,mikey,handle_ladders);
			FlxG.overlap(level.ladder_checks, barrels, handle_barrel_ladders);
			FlxG.collide(level.bricks, mikey)
			if(level.stairs) FlxG.overlap(level.stairs, mikey, handle_stairs);
			
			/*if(mikey.y > FlxG.height)
			{
				FlxG.score = 1;	//sets status.text to "Aww, you died!"
				FlxG.resetState();
				
			}*/
		}
		
		public function handle_ladders(Ladder:FlxSprite, Mikey:FlxSprite):void
		{
			if(!mikey.ladder && FlxG.keys.DOWN)
			{
				mikey.ladder = true;
				mikey.climbing = true;
				mikey.play("ladder-top-down");
			}
			if(FlxG.keys.DOWN && mikey.climbing)
			{
				if(mikey.finished) mikey.play("ladder-climbing");
				if(mikey.y + (mikey.height*.5) > Ladder.y)
					mikey.allowCollisions = mikey.default_collisions;
				else
					mikey.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT;
			}
		}
		
		public function handle_stairs(Brick:FlxSprite, Target:FlxSprite):void
		{
			if(Target.isTouching(FlxObject.FLOOR))
				if(Target.y + Target.height > Brick.y && Target.y < Brick.y) Target.y = Brick.y - Target.height;
			if(Target == mikey)
			{
				if(mikey.y + mikey.height >= Brick.y && mikey.y + mikey.height < Brick.y + (Brick.height*.5) && mikey.allowCollisions == mikey.default_collisions)
					mikey.climbing = false;
				if(!mikey.climbing) FlxObject.separateY(Brick,mikey);
			}else
				FlxObject.separateY(Brick,Target)
		}
		
		public function handle_barrel_ladders(ladder:FlxSprite, barrel:FlxSprite):void
		{
			if(barrel.y + barrel.height > ladder.y + ladder.height) return;
			if(barrel.x < ladder.x - 3 || barrel.x >= ladder.x -2 ) return;
			if(Barrel(barrel).ladder > -1) return;
			var chance:Number = FlxG.random()*10;
			if(chance > 7)
			{
				//TODO: Perform some mikey position/facing checks for better AI
				Barrel(barrel).ladder = ladder.y + 16;
			}
		}
		
		public function touch_barrel(Barrel:FlxSprite,Mikey:FlxSprite):void
		{
			if(mikey.y + mikey.height <= Barrel.y + 4 )
			{
				if(mikey.facing == FlxObject.LEFT && mikey.x <= Barrel.x)
					Barrel.kill();
				if(mikey.facing == FlxObject.RIGHT && mikey.x >= Barrel.x)
					Barrel.kill();	
			}else
			{
				mikey.flicker();
			}
			
			//Barrel.kill();
			//score.text = "SCORE: "+(barrels.countDead()*100);
			//if(barrels.countLiving() == 0)
			//{
				//status.text = "Blah";
				//exit.exists = true;
			//}
		}
		
		public function win(Exit:FlxSprite,Mikey:FlxSprite):void
		{
			//status.text = "Yay, you won!";
			score.text = "SCORE: 5000";
			Mikey.kill();
		}
	}
}