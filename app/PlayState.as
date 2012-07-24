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
		// <3 <3 <3 <3 <3 <3 <3
		public var mikey:Mikey;
		public var manda:Manda;
		// <3 <3 <3 <3 <3 <3 <3
		public var dk:Kong;
		public var bonus:uint = 4200;
		public var time:uint = 0;
		public var completed:Boolean = false;
		
		protected var label_bonus:FlxText;
		protected var graphic_bonus:FlxSprite;
		protected var bonus_timer:FlxTimer;
		protected var point_labels:FlxGroup;

		[Embed(source="../assets/04B_11__.TTF", fontFamily="04B", embedAsCFF="false")]
		public var Font04B:String;
		[Embed(source="../assets/PressStart2P.ttf", fontFamily="2P", embedAsCFF="false")]
		public var Font2P:String;
		
		[Embed(source="../assets/audio/bacmusic.mp3")] private var SndLevel:Class;
		[Embed(source="../assets/audio/complete.mp3")] private var SndWin:Class;
		[Embed(source="../assets/bonus-box.gif")] private var ImgBonus:Class;
		[Embed(source="../assets/lives.gif")] private var ImgLife:Class;
		[Embed(source="../assets/love.gif")] private var Love:Class;
		
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
			mikey.lives = main.mikey_lives;
			add(mikey);

			//create manda!
			manda = new Manda(this);
			add(manda);

			point_labels = new FlxGroup();
			add(point_labels);

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
			dk.start();
			mikey.reset(31,228);
			mikey.alive = true;
			update_lives(main.mikey_lives);
			bonus = 4200;
			label_bonus.text = "4200";
			bonus_timer.destroy();
			bonus_timer.start(2.5,0,decrease_bonus);
			active = true;
			completed = false;
			level.bgm.play();
		}

		public function died():void
		{
			main.mikey_lives--;
			mikey.lives = main.mikey_lives;
			//stop game.
			active = false;
			barrels.clear();
			bonus_timer.stop();
			dk.stop();
			level.bgm.stop();
		}

		public function game_over():void
		{
			var game_over:FlxText = new FlxText(0,128,256,"GAME OVER");
			game_over.setFormat("2P",8,0xffffff,"center");
			add(game_over);
		}
		
		public function create_barrel(X:uint,Y:uint):void
		{
			var barrel:Barrel = new Barrel(X,Y);
			barrels.add(barrel);
		}
		
		public function destroy_barrel(Barrel:FlxSprite):void
		{
			var point:Object = {"x":Barrel.x + 4,"y":Barrel.y + 4};
			Barrel.kill();
			award_points(100,point);
		}
		
		public function award_points(amount:uint, point:Object = null):void
		{
			main.score += amount;
			var base:String = "000000";
			base = base.slice(0,base.length - String(main.score).length);
			main.label_score.text = base + String(main.score);
			if(main.score > main.high_score)
			{
				main.high_score = main.score;
				main.draw_high_score();
			}
			if(point)
			{
				var point_label:FlxText = new FlxText(point.x - 25,point.y,50,String(amount));
				point_label.setFormat("2P",8,0xffffff,"center");
				point_labels.add(point_label);
				var delay_points:FlxTimer = new FlxTimer();
				delay_points.start(1,1,destroy_point_label);
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

		public function destroy_point_label(Timer:FlxTimer):void
		{
			point_labels.remove(point_labels.members.pop(),true);
			if(point_labels.length < 1) point_labels.clear();
		}

		public function go_next_level(Timer:FlxTimer):void
		{
			main.level++;
			var base:String = "00";
			base = base.slice(0,base.length - String(main.level).length);
			main.label_level.text = "L=" + base + String(main.level);
			main.state = LevelState;
		}

		override public function update():void
		{
			super.update();
			if(!active) return;
			
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
				completed = true;
				barrels.clear();
				bonus_timer.stop();
				dk.stop();
				level.bgm.stop();
				//you win!
				FlxG.play(SndWin,1,false,true);
				manda.play("stand");
				var heart:FlxSprite = new FlxSprite(manda.x + 17, manda.y - 8,Love);
				add(heart);
				dk.play("ouchie");
				mikey.clear_states();
				mikey.play("standing");
				mikey.facing = FlxObject.LEFT;
				mikey.x = manda.x + 30;
				award_points(bonus);
				bonus = 0;
				label_bonus.text = "0000";
				//go to next!
				var to_next_level:FlxTimer = new FlxTimer();
				to_next_level.start(5,1,go_next_level);
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
