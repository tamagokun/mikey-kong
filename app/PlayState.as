package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import elements.*;
	import levels.*;
	import overrides.*;
	
	public class PlayState extends ChildState
	{
		public var level:*;
		public var barrels:FlxGroup;
		public var mikey:Mikey;
		public var dk:Kong;
		public var bonus:uint = 4200;
		public var time:uint = 0;
		
		protected var label_bonus:FlxText;
		protected var graphic_bonus:FlxSprite;
		protected var bonus_timer:FlxTimer;
		
		[Embed(source="../assets/04B_11__.TTF", fontFamily="04B", embedAsCFF="false")]
		public var Font04B:String;
		[Embed(source="../assets/PressStart2P.ttf", fontFamily="2P", embedAsCFF="false")]
		public var Font2P:String;
		
		[Embed(source="../assets/audio/bacmusic.mp3")] private var SndLevel:Class;
		[Embed(source="../assets/audio/complete.mp3")] private var SndWin:Class;
		[Embed(source="../assets/bonus-box.gif")] private var ImgBonus:Class;
		[Embed(source="../assets/lives.gif")] private var ImgLife:Class;
		
		override public function create():void
		{
			//gui
			graphic_bonus = new FlxSprite(179,40,ImgBonus);
			add(graphic_bonus);
			
			label_bonus = new FlxText(183,46,50,"4200");
			label_bonus.setFormat("2P",8,0x00ffff,"left");
			add(label_bonus);

			//level init stuff
			level = new Level1(this) as Level1;
			add(level.ladders);
			add(level.bricks);
			if(level.stairs) add(level.stairs);
			level.create();
			
			//create dk! oh noes!
			dk = new Kong(this);
			add(dk);
			
			barrels = new FlxGroup();
			add(barrels);
			
			//create mikey!
			mikey = new Mikey(this);
			mikey.lives = 4;
			add(mikey);
			
			update_lives(mikey.lives);
			
			bonus_timer = new FlxTimer();
			bonus_timer.start(2.5,0,decrease_bonus);
			
			level.bgm = FlxG.loadSound(SndLevel,1,true,true,true);
		}
		
		public function reset():void
		{
			barrels.clear();
			dk.kill();
			dk.revive();
			mikey.reset(31,228);
			update_lives(mikey.lives);
			bonus = 4200;
			bonus_timer.start(2.5,0,decrease_bonus);
			active = true;
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
			main.score += amount;
			var base:String = "000000";
			base = base.slice(0,base.length - String(main.score).length);
			main.label_score.text = base + String(main.score);
			if(point)
			{
				var point_label:FlxText = new FlxText(point.x,point.y,50,String(main.score));
				point_label.setFormat("2P",8,0xffffff,"center");
				//kill text after a couple seconds.
			}
		}
		
		public function decrease_bonus(Timer:FlxTimer):void
		{
			bonus -= 100;
			if(bonus < 0) bonus = 0;
			var base:String = "0000";
			base = base.slice(0,base.length - String(bonus).length);
			label_bonus.text = base + String(bonus);
		}
		
		override public function update():void
		{
			if(!active) return;
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
				active = false;
				barrels.clear();
				bonus_timer.stop();
				dk.stop();
				level.bgm.stop();
				//you win!
				FlxG.play(SndWin,1,false,true);
				//go to next!
			}
			
			if(mikey.y > FlxG.height) mikey.kill();
		}
		
		public function handle_ladders(Ladder:FlxSprite, Mikey:FlxSprite):void
		{
			if(mikey.jumping) return;
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
				if(mikey.climbing) return;
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
			main.lives.clear();
			var i:uint = 0;
			for(i; i < amount; i++)
			{
				var life:FlxSprite = new FlxSprite(17+(i*8),24,ImgLife);
				main.lives.add(life);
			}
		}
	}
}
