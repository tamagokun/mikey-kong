package
{
	import org.flixel.*;
	import elements.*;
	
	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		//public var exit:FlxSprite;
		public var barrels:FlxGroup;
		public var mikey:FlxSprite;
		public var score:FlxText;
		public var time:FlxText;
		
		[Embed(source="../assets/brick.gif")] private var ImgBrick:Class;
		
		override public function create():void
		{
			//level init stuff
			
			level = new FlxTilemap();
			//level.loadMap();
			add(level);
			
			
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
			FlxG.collide(level,mikey);
			
			if(mikey.y > FlxG.height)
			{
				FlxG.score = 1;	//sets status.text to "Aww, you died!"
				FlxG.resetState();
				
			}
			
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