package elements
{
	import org.flixel.*;
	
	public class Kong extends FlxSprite
	{
		private var _parent:PlayState;
		
		[Embed(source="../../assets/kong.gif")] private var ImgKong:Class;
		
		public function Kong(parent:PlayState):void
		{
			super(31,48);
			loadGraphic(ImgKong,true,true,52,36);
			_parent = parent;
			
			addAnimation("standing",[0],0);
			addAnimation("throw_left",[8,8],4,false);
			addAnimation("throw_right",[9,9],4,false);
			
			var barrel_timer:FlxTimer = new FlxTimer();
			barrel_timer.start(5,0,dk_throw);
			
			play("standing");
		}
				
		public function dk_throw(Timer:FlxTimer):void
		{
		 	play(facing == LEFT? "throw_left" : "throw_right");
			var x_start:uint = facing == LEFT? x + 3 : x + 43;
			_parent.create_barrel(x_start,67);
		}
		
		override public function update():void
		{
			if(finished && (_curAnim.name == "throw_left" || _curAnim.name == "throw_right"))
				play("standing");
		}
	}
}