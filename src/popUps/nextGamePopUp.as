package popUps
{
	import Games.ShowObject;
	
	import com.gskinner.motion.plugins.SmartRotationPlugin;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class nextGamePopUp extends ShowObject
	{
		public static const TANK:String = "Zakończyłeś pierwsze zadanie";
		public static const PARK:String = "Zakończyłeś drugie zadanie";
		public static const TRUNK:String = "Zakończyłeś trzecie zadanie";
		private var _bg:next_game_info =  new next_game_info();
		private var _callback:Function;
		public function nextGamePopUp(pClip:DisplayObjectContainer, canShow:Boolean=false)
		{
			super(pClip, canShow);
			if(!Game.instance().small_size){
				_bg.x = _stage_width/2 -_bg.width/2;
				_bg.y = _stage_height/2 - _bg.height/2;
			}else{
				_bg.x = _stage_width*Game.instance().scale/2 -_bg.width/2;
				_bg.y = _stage_height*Game.instance().scale/2 - _bg.height/2;
			}
			addChild(_bg);
			_bg.nextGame.buttonMode = true;
			_bg.nextGame.useHandCursor = true;
			_bg.repeatGame.buttonMode = true;
			_bg.repeatGame.useHandCursor = true
			_bg.nextGame.gotoAndStop(1);
		}
		public function update(time:String,text:String,callback:Function,ranking:Boolean = false):void{
			if(ranking)
				_bg.nextGame.gotoAndStop(2);
			else 
				_bg.nextGame.gotoAndStop(1);
			_callback =  callback;
			_bg.repeatGame.addEventListener(MouseEvent.CLICK, startGamesAgain);
			_bg.nextGame.addEventListener(MouseEvent.CLICK, startNextGame);
			_bg.game_time.text = time;
			_bg.game_number.text = text;
		}
		private function startNextGame(e:MouseEvent):void{
			_bg.nextGame.removeEventListener(MouseEvent.CLICK, startNextGame);
			_callback();
			hide();
		}
		private function startGamesAgain(e:MouseEvent):void{
			_bg.repeatGame.removeEventListener(MouseEvent.CLICK, startGamesAgain);;
			Game.instance().startGames();
			hide()
		}
	}
}