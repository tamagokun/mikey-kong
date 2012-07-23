package elements
{
	import org.flixel.*;

	public class Manda extends FlxSprite
	{
		private var _parent:PlayState;
		private var flail_timer:FlxTimer;
		[Embed(source="../../assets/manda.gif")] private var ImgManda:Class;

		public function Manda(parent:PlayState = null):void
		{
			super(96,31);
			loadGraphic(ImgManda,true,true,39,25);
			_parent = parent;

			addAnimation("stand",[1],0);
			addAnimation("flail",[1,0,1,0,1,0,1,0,1,0],8,false);
			addAnimation("help",[3,3],1,false);

			flail_timer = new FlxTimer();
			flail_timer.start(4,0,try_flail);

			play("stand");
		}

		public function try_flail(Timer:FlxTimer):void
		{
			var chance:Number = FlxG.random()*10;
			if(chance > 5) play("flail");
		}

		override public function update():void
		{
			if(finished && _curAnim.name == "flail")
				play("help");
			if(finished && _curAnim.name == "help")
				play("stand");
			super.update();
		}
	}
}
