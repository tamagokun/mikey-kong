package
{
	import org.flixel.*;
	import elements.*;
	import overrides.*;

	public class LevelState extends ChildState
	{
		private var label_how_high:FlxText;

		[Embed(source="../assets/PressStart2P.ttf", fontFamily="2P", embedAsCFF="false")]
		public var Font2P:String;
		[Embed(source="../assets/audio/intro.mp3")] private var SndIntro:Class;

		override public function create():void
		{
			label_how_high = new FlxText(0,250,256,"HOW HIGH CAN YOU GET ?");
			label_how_high.setFormat("2P",8,0xffffff,"center");
			add(label_how_high);
			display_how_high(main.level);

			FlxG.play(SndIntro,1,false,true);
			var delay_timer:FlxTimer = new FlxTimer();
			delay_timer.start(5,1,start_game);
		}

		public function start_game(Timer:FlxTimer):void
		{
			main.state = PlayState;
		}

		public function display_how_high(level:int):void
		{
			level = Math.min(level,4);
			var i:uint = 0;
			for(i; i < level; i++)
			{
				var dk:Kong = new Kong();
				add(dk);
				dk.x = 102;
				dk.y = 210 - (i * (dk.height + 8));
				dk.play("level");

				var meters:uint = 25 * (i+1);
				var label_dk:FlxText = new FlxText(40,dk.y + dk.height - 16,50,meters + " m");
				label_dk.setFormat("2P",8,0xffffff,"right");
				add(label_dk);
			}
		}
	}
}
