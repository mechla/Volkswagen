package Games
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class BaseGame extends ShowObject
	{
		
		protected var _bg:MovieClip;
		protected var _miniseconds:Number = 0;
		protected var _game_over:Boolean = false;
		protected var _one_round_time:Number = 0;
		protected var _start_date:Date;
		protected var _i:int = 4;
		
		public function BaseGame(parent:DisplayObjectContainer, cansShow:Boolean = false)
		{
			super(parent, cansShow);
			addBackground()
		}
		protected function addBackground():void{
			
		}
		
		public function onTime(e:Event):void{
			var date:Date =  new Date();
			_miniseconds = Math.floor((date.valueOf() - _start_date.valueOf())/Vars.instance().time_change);
			showTime(calculateTime(Game.instance().data.score + _miniseconds));
			//			}
		}

		protected function showTime(time:String):void{
			
		}
		protected function timerStart():void{
			_start_date =  new Date();
			addEventListener(Event.ENTER_FRAME, onTime);
		}
		protected function timerStop():void{
			removeEventListener(Event.ENTER_FRAME, onTime);
		}
		protected function gameOver():void{
			_game_over = true;
			timerStop();
			Game.instance().data.score = Game.instance().data.score + _miniseconds;
			trace("SCORE: ", Game.instance().data.score, _miniseconds);
			TweenLite.delayedCall(2, nextGame);
			showTime(calculateTime(Game.instance().data.score));
		}
		protected function nextGame():void{
		}   
		
		
		
	}
}