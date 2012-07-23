package
{
	import org.flixel.*;
	import overrides.*;

	public class MainState extends FlxState
	{
		public var mikey_lives:int = 2;
		public var level:uint = 1;
		public var lives:FlxGroup;
		public var high_score:uint = 1000;
		public var score:uint = 0;
		public var current_state:ChildState;

		public var label_score:FlxText;
		public var label_time:FlxText;
		public var label_player1:FlxText;
		public var label_high_score:FlxText;
		public var value_high_score:FlxText;
		public var label_level:FlxText;

		[Embed(source="../assets/PressStart2P.ttf", fontFamily="2P", embedAsCFF="false")]
		public var Font2P:String;

		override public function create():void
		{
			//gui
			lives = new FlxGroup();
			add(lives);
			setup_labels();
			draw_high_score();
			//label_player1.flicker();

			this.state = LevelState;
		}

		public function set state(NewFlxState:Class):void
		{
			if(current_state)
			{
				remove(current_state);
				current_state.destroy();
				current_state = null;
			}

			current_state = new NewFlxState();
			current_state.parent = this;
			add(current_state);
			current_state.create();
		}

		public function draw_high_score():void
		{
			var base:String = "000000";
			base = base.slice(0,base.length - String(high_score).length);
			value_high_score.text = base + String(high_score);
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
			
			value_high_score = new FlxText(81,8,100,"000000");
			value_high_score.setFormat("2P",8,0xffffff,"center");
			add(value_high_score);

			label_level = new FlxText(178,24,50,"L=01");
			label_level.setFormat("2P",8,0x0000aa,"left");
			add(label_level);
		}
	}
}
