package controlers
{
	import com.adobe.crypto.MD5;
	import com.adobe.protocols.dict.events.ErrorEvent;
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	
	import popUps.Player;
	
	public class Data extends EventDispatcher
	{
		protected var _gameId:String;  //przychodzi we falshcars
		protected var _userId:String;  //przychodzi jako id
		protected var _facebookId:Number;  //facebook_id
		
		
		protected var _code:String = "si39g03kv0";
		protected var _formula_add:Number = 124981204;
		protected var _formula:Number;
		protected var _md5:String;
		protected var _timestamp:Number;
		
		private var _game1_score:String;
		private var _game2_score:String;
		private var _game3_score:String;
		private var _score:Number = 0;
		
		
		private var _first_name:String;
		private var _last_name:String;
		
		private var _current_user_index:String = "";
		private var _players:Array =  new Array();
		private var _woman:Boolean =  false;
		
		
		private var _sendPost:SendPost =  new SendPost();
		
		
		
		public function Data()
		{
		}
		
		public function get gameId():String
		{
			return _gameId;
		}
		
		public function set gameId(value:String):void
		{
			_gameId = value;
		}
		
		// FACEBOOK DATA
		public function sendGameId():void{
			var send_score:SendPost =  new SendPost();
			var data:URLVariables =  new URLVariables();
			data.id = _gameId;
			data.c = _code;
			send_score.sendPost(send_score.INFO,data,reciveFacebookData);
		}
		private function reciveFacebookData(e:Object):void
		{
			var obj:Object = JSON.decode(e.target.data)
			_first_name = obj.first_name;
			_last_name =  obj.last_name;
			_userId = obj.id;
			_facebookId  = obj.facebook_id;
			//      sendScore();
		}
		//SCORE AND RANKING
		public function sendScore():void{
			calculateMD5();
			var send_score:SendPost =  new SendPost();
			var data:URLVariables = new URLVariables();
			data.c = _code;
			data.points = _score;
			data.gameId = _gameId;
			data.userId  = _userId;
			data.t = _timestamp;
			data.e = _md5;
			send_score.sendPost(send_score.SCORE,data,reciveRanking,true)
		}
		private function reciveRanking(e:Object):void{
			var obj:Object = JSON.decode(e.target.data)
			var rank:Object =  obj.rank;
			_players =  new Array();
			_current_user_index =  obj.current_user_index;
			for each ( var o:Object in rank){
				var player:Player =  new Player(o.index,o.score,o.name);
				_players.push(player);
			}
			Game.instance().ranking.updateRanking();
		}
		private function calculateMD5():void{
			var date:Date = new Date();
			_timestamp = Math.round(date.getTime()/1000);
			_formula = (_score + _formula_add)*9 + _timestamp;
			_md5 = MD5.hash(_formula.toString());
		}
		//GETERS SETTERS
		public function get game1_score():String
		{
			return _game1_score;
		}
		
		public function set game1_score(value:String):void
		{
			_game1_score = value;
		}
		
		public function get game2_score():String
		{
			return _game2_score;
		}
		
		public function set game2_score(value:String):void
		{
			_game2_score = value;
		}
		
		public function get game3_score():String
		{
			return _game3_score;
		}
		
		public function set game3_score(value:String):void
		{
			_game3_score = value;
		}
		
		public function get score():Number
		{
			return _score;
		}
		
		public function set score(value:Number):void
		{
			_score = value;
		}
		
		public function get woman():Boolean
		{
			return _woman;
		}
		
		public function set woman(value:Boolean):void
		{
			_woman = value;
		}
		
		public function get first_name():String
		{
			return _first_name;
		}
		
		public function set first_name(value:String):void
		{
			_first_name = value;
		}
		
		public function get last_name():String
		{
			return _last_name;
		}
		
		public function set last_name(value:String):void
		{
			_last_name = value;
		}
		
		public function get players():Array
		{
			return _players;
		}
		
		public function set players(value:Array):void
		{
			_players = value;
		}
		
		public function get current_user_index():String
		{
			return _current_user_index;
		}
		
	}
}
//		kodowanie
//		(liczba punktow + id uzytkownika)*9 + 124981204 + timestamp

//   wysyłam wyniki:
//    https://oxapps.pl/apps/vw_game/game/endGame?gameId=83712873&userId=923823&c=si39g03kv0&points=100

//   dostaje JSONa
//  https://oxapps.pl/apps/vw_game/game/info?gameId=83712873&c=kod
