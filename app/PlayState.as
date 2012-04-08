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
			mikey = new Mikey();
			add(mikey);
			
			barrels = new FlxGroup();
			add(barrels);
			//create_barrel(0,0);
		}
		
		public function create_barrel(X:uint,Y:uint):void
		{
			var barrel:Barrel = new Barrel(X,Y);
			barrels.add(barrel);
		}
		
		override public function update():void
		{		
			super.update();
			
			//FlxG.overlap(barrels, mikey, touch_barrel);
			//FlxG.overlap(exit, mikey, win);
			FlxG.collide(level.bricks, mikey, handle_bricks);
			FlxG.collide(level.bricks, barrels);
			FlxG.overlap(level.ladders, mikey, handle_ladders);
			if(level.stairs) FlxG.overlap(level.stairs, mikey, handle_stairs);
			
			/*if(mikey.y > FlxG.height)
			{
				FlxG.score = 1;	//sets status.text to "Aww, you died!"
				FlxG.resetState();
				
			}*/
			
		}
		
		public function handle_bricks(Brick:FlxSprite, mikey:FlxSprite):void
		{
			Mikey(mikey).handle_brick(Brick);
		}
		
		public function handle_ladders(Ladder:FlxSprite, mikey:FlxSprite):void
		{
			Mikey(mikey).on_ladder = true;
			if(mikey.y + mikey.height <= Ladder.y + 2) Mikey(mikey).climbing = false;
		}
		
		public function handle_stairs(Brick:FlxSprite, mikey:FlxSprite):void
		{
			Mikey(mikey).handle_brick(Brick);
			if(mikey.isTouching(FlxObject.FLOOR))
			if(mikey.y + mikey.height > Brick.y) mikey.y = Brick.y - mikey.height;
			FlxObject.separateY(Brick,mikey);
		}
		
		public function touch_barrel(Barrel:FlxSprite,Mikey:FlxSprite):void
		{
			//Barrel.kill();
			score.text = "SCORE: "+(barrels.countDead()*100);
			if(barrels.countLiving() == 0)
			{
				//status.text = "Blah";
				//exit.exists = true;
			}
		}
		
		public function win(Exit:FlxSprite,Mikey:FlxSprite):void
		{
			//status.text = "Yay, you won!";
			score.text = "SCORE: 5000";
			Mikey.kill();
		}
	}
}