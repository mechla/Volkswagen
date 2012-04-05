package
{
	import com.adobe.protocols.dict.events.ErrorEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.system.Security;
	
	[SWF(width='831',height='700',frameRate='25')]
	public class Volkswagen extends MovieClip
	{
		
		Security.allowDomain('*');
		public function Volkswagen()
		{
			super();
			if(this.stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(...args):void{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			this.addEventListener(ErrorEvent.ERROR,errorHandler);
			
			addChild(Game.instance());
			
			Game.instance().init();
		}
		private function onResize(e:Event):void{
			trace("resize");
		}
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			throw new Error(" wywołuje Uncaught");
		}
		private function errorHandler(evt:Error):void
		{
			throw new Error(" wywołuje ");
			
		}
	}
}