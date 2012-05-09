package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import elements.*;
	import levels.*;
	
	public class PlayState extends FlxState
	{
		public var level:*;
		public var lives:FlxGroup;
		public var barrels:FlxGroup;
		public var mikey:Mikey;
		public var dk:Kong;
		public var score:uint = 0;
		public var time:uint = 0;
		
		protected var label_score:FlxText;
		protected var label_time:FlxText;
		protected var label_player1:FlxText;
		protected var label_high_score:FlxText;
		protected var high_score:FlxText;
		protected var label_level:FlxText;
		protected var label_bonus:FlxText;
		protected var graphic_bonus:FlxSprite;
		
		[Embed(source="../assets/04B_11__.TTF", fontFamily="04B", embedAsCFF="false")]
		public var Font04B:String;
		[Embed(source="../assets/PressStart2P.ttf", fontFamily="2P", embedAsCFF="false")]
		public var Font2P:String;
		
		[Embed(source="../assets/bonus-box.gif")] private var ImgBonus:Class;
		[Embed(source="../assets/lives.gif")] private var ImgLife:Class;
		
		override public function create():void
		{
			//gui
			lives = new FlxGroup();
			add(lives);
			setup_labels();
			
			//level init stuff
			level = new Level1(this) as Level1;
			add(level.ladders);
			add(level.bricks);
			if(level.stairs) add(level.stairs);
			level.create();
			barrels = new FlxGroup();
			add(barrels);
			
			//create dk! oh noes!
			dk = new Kong(this);
			add(dk);
			
			//create mikey!
			mikey = new Mikey(this);
			mikey.lives = 4;
			add(mikey);
			
			update_lives(mikey.lives);
		}
		
		public function reset():void
		{
			barrels.clear();
			dk.kill();
			dk.revive();
			mikey.reset(31,228);
			update_lives(mikey.lives);
		}
		
		public function create_barrel(X:uint,Y:uint):void
		{
			var barrel:Barrel = new Barrel(X,Y);
			barrels.add(barrel);
		}
		
		public function destroy_barrel(Barrel:FlxSprite):void
		{
			var point:Object = {"x":Barrel.x,"y":Barrel.y};
			Barrel.kill();
			award_points(100,point);
		}
		
		public function award_points(amount:uint, point:Object = null):void
		{
			score += amount;
			var base:String = "000000";
			base = base.slice(0,String(score).length);
			label_score.text = base + String(score);
			if(point)
			{
				var point_label:FlxText = new FlxText(point.x,point.y,50,String(score));
				point_label.setFormat("2P",8,0xffffff,"center");
				//kill text after a couple seconds.
			}
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
			
			if(mikey.y > FlxG.height) mikey.kill();
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
				if(FlxCollision.pixelPerfectCheck(Barrel,Mikey))
					mikey.kill();
			}
		}
		
		public function update_lives(amount:int):void
		{
			lives.clear();
			var i:uint = 0;
			for(i; i < amount; i++)
			{
				var life:FlxSprite = new FlxSprite(17+(i*8),24,ImgLife);
				lives.add(life);
			}
		}
		
		protected function setup_labels():void
		{
			label_score = new FlxText(17,8,63,"000000");
			label_score.setFormat("2P",8,0xffffff,"left");
			add(label_score);
			
			label_player1 = new FlxText(33,0,40,"1UP");
			label_player1.setFormat("2P",8,0xff0000,"left");
			add(label_player1);
			
			label_high_score = new FlxText(81,0,100,"HIGH SCORE");
			label_high_score.setFormat("2P",8,0xff0000,"center");
			add(label_high_score);
			
			high_score = new FlxText(81,8,100,"000000");
			high_score.setFormat("2P",8,0xffffff,"center");
			add(high_score);
			
			label_level = new FlxText(178,24,50,"L=00");
			label_level.setFormat("2P",8,0x0000aa,"left");
			add(label_level);
			
			graphic_bonus = new FlxSprite(179,40,ImgBonus);
			add(graphic_bonus);
			
			label_bonus = new FlxText(183,46,50,"4200");
			label_bonus.setFormat("2P",8,0x00ffff,"left");
			add(label_bonus);
		}
	}
}