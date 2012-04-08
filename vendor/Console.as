package
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	//import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	
	public class Console extends Sprite
	{
		public function Console():void
		{
			super();
			init();
		}
		
		public static function log(... arguments):void
		{
			Console.trace(arguments);
		}
		
		public static function warn(... arguments):void
		{
			Console.trace(arguments, "warn");
		}
		
		public static function error(... arguments):void
		{
			Console.trace(arguments, "error");
		}
		
		private static function trace(args:Object,type:String = "log"):void
		{
			for(var i:String in args)
			{
				if( !args[i] is String)
					args[i] = args[i].toString();
				ExternalInterface.call("console."+type,args[i]);
				if( type == "log") trace(args[i]);
			}
		}
		
		private function init():void
		{
			//if(loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
				//loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler, false, 0, true);
		}
		
		/*private function uncaughtErrorHandler(e:UncaughtErrorEvent):void
		{
			if( e.error is Error)
			{
				var stack:String = Error(e.error).getStackTrace();
				Console.error(Error(e.error).message + ((stack!=null)? "\n"+stack : ""));
			}
			else if( e.error is ErrorEvent)
				Console.error(ErrorEvent(e.error).text);
			else
				Console.error(e.error.toString());
		}*/
	}
}