package elements
{
	import org.flixel.*;
	
	public class Barrel extends FlxSprite
	{
		[Embed(source="../../assets/barrel-roll.gif")] private var ImgBarrel:Class;
		[Embed(source="../../assets/barrel-ladder.gif")] private var ImgBarrelLadder:Class;
		
		public function Barrel(X:int,Y:int):void
		{
			super(X,Y);
			loadGraphic(ImgBarrel,true);
			
			addAnimation("Roll",[0,1,2,3],6+FlxG.random()*4);
			
			play("Roll");
			
			velocity.x = 10;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}