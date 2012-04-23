package
{
	import org.flixel.*;
	import elements.*;
	import levels.*;
	
	public class PlayState extends FlxState
	{
		public var level:*;
		public var barrels:FlxGroup;
		public var mikey:Mikey;
		public var label_score:FlxText;
		public var label_time:FlxText;
		public var score:uint = 0;
		public var time:uint = 0;
		
		[Embed(source="../assets/04B_11__.TTF", fontFamily="04B", embedAsCFF="false")]
		public var Font04B:String;
		
		override public function create():void
		{
			//gui
			label_score = new FlxText(17,8,63,"000000");
			label_score.setFormat("04B",8,0xffffff,"left");
			add(label_score);
			
			//level init stuff
			level = new Level1(this) as Level1;
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
		
		public function destroy_barrel(Barrel:FlxSprite):void
		{
			Barrel.kill();
			score += 100;
			var base:String = "000000";
			base = base.slice(0,String(score).length);
			label_score.text = base + String(score);
		}
		
		override public function update():void
		{		
			super.update();
			
			FlxG.overlap(barrels, mikey, touch_barrel);
			FlxG.collide(level.bricks, barrels);
			FlxG.collide(level.stairs, barrels);
			
			FlxG.overlap(level.ladders,mikey,handle_ladders);
			FlxG.overlap(level.ladder_checks, barrels, handle_barrel_ladders);
			FlxG.collide(level.bricks, mikey)
			if(level.stairs) FlxG.overlap(level.stairs, mikey, handle_stairs);
			
			if(level.completed())
			{
				//stop game.
				//go to next!
			}
			
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
					destroy_barrel(Barrel);
				else if(mikey.facing == FlxObject.RIGHT && mikey.x >= Barrel.x)
					destroy_barrel(Barrel);	
			}else
			{
				mikey.flicker();
			}
		}
	}
}