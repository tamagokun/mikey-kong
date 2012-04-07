package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		//public var exit:FlxSprite;
		public var barrels:FlxGroup;
		public var mikey:FlxSprite;
		public var score:FlxText;
		public var time:FlxText;
		
		[Embed(source="")]
		
		override public function create():void
		{
			//level init stuff
			
			level = new FlxTilemap();
			level.loadMap();
			add(level);
			
			
		}
		
		public function create_barrel(X:uint,Y:uint):void
		{
			var barrel:FlxSprite = new FlxSprite();
			barrel.makeGraphic();
			barrels.add(barrel);
		}
		
		override public function update():void
		{
			mikey.acceleration.x = 0;
			if(FlxG.keys.LEFT)
				mikey.acceleration.x = -mikey.maxVelocity.x*4;
			if(FlxG.keys.RIGHT)
				mikey.acceleration.x = mikey.maxVelocity.x*4;
			if(FlxG.keys.justPressed("SPACE") && mikey.isTouching(FlxObject.FLOOR))
				mikey.velocity.y = -mikey.maxVelocity.y/2;
				
			super.update();
			
			FlxG.overlap(barrels, mikey, touch_barrel);
			FlxG.overlap(exit, mikey, win);
			FlxG.collide(level,mikey);
			
			if(player.y > FlxG.height)
			{
				FlxG.score = 1;	//sets status.text to "Aww, you died!"
				FlxG.resetState();
				
			}
			
		}
		
		public function touch_barrel(Barrel:FlxSprite,Mikey:FlxSprite):void
		{
			//Barrel.kill();
			score.text = "SCORE: "+(barrels.countDead()*100);
			if(barrels.coundLiving() == 0)
			{
				status.text = "Blah";
				exit.exists = true;
			}
		}
		
		public function win(Exit:FlxSprite,Mikey:FlxSprite):void
		{
			status.text = "Yay, you won!";
			score.text = "SCORE: 5000";
			Mikey.kill();
		}
	}
}