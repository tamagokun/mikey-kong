package elements
{
	import org.flixel.*;
	
	public class Kong extends FlxSprite
	{
		public var bouncing:Boolean = false;
		private var _parent:PlayState;
		private var barrel_timer:FlxTimer;
		
		[Embed(source="../../assets/kong.gif")] private var ImgKong:Class;
		
		public function Kong(parent:PlayState = null):void
		{
			super(29,48);
			loadGraphic(ImgKong,true,true,52,36);
			_parent = parent;
			
			addAnimation("standing",[0],0);
			addAnimation("pickup_barrel",[8,8],4,false);
			addAnimation("hold_barrel",[11,11],4,false);
			addAnimation("throw",[9,9],4,false);
			addAnimation("climb",[4,5],8,true);
			addAnimation("level",[10],0);
			addAnimation("ouchie",[6,7,6,7,6,7,6,7],2,false);
			
			if(_parent !== null)
			{
				start();
			}
			
			play("standing");
		}

		public function stop():void
		{
			barrel_timer.stop();
		}

		public function start():void
		{
			if(barrel_timer) barrel_timer.destroy();
			barrel_timer = new FlxTimer();
			barrel_timer.start(4,0,find_barrel);
		}

		public function find_barrel(Timer:FlxTimer):void
		{
			play("pickup_barrel");
		}
		
		public function dk_throw():void
		{
			play("throw");
			_parent.create_barrel(x + 43,67);
		}
		
		override public function update():void
		{
			if(finished && _curAnim.name == "pickup_barrel")
				play("hold_barrel");
			if(finished && _curAnim.name == "hold_barrel")
				dk_throw();
			if(finished && _curAnim.name == "throw")
				play("standing");
		}
	}
}
