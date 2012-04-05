
package
{
	import Games.Fuel.Fuel;
	import Games.Parking.Parking;
	import Games.Trunk.Trunk;
	
	import popUps.nextGamePopUp;
	
	import controlers.Data;
	import popUps.Ranking;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	[SWF(width=831,height=700)]
	public class Game extends Sprite
	{
		private var _small_size:Boolean =  false;
		private var _scale:Number =  .8;
		private var _fuel_game:Fuel;
		private var _trunk_game:Trunk;
		private var _parking:Parking;
		
		private var _ranking:Ranking;
		private var _data:Data =  new Data();
		private var _start_instructions_popup:instructions_trunk =  new instructions_trunk();
		private var _next_game_popup:nextGamePopUp;
		
		private static var _instance:Game= new Game()
		
		public function Game()
		{
		}
		public function init():void{
			_next_game_popup =  new nextGamePopUp(this, false);
			getFlashvars();
			startGames();
//			startFuelGame();
			// ddDataView();
			//startParking();
//			startTrunkGame();
			//addRanking();
		}
		public function startGames():void{
			_data.score = 0;
			while(this.numChildren)
				this.removeChild(this.getChildAt(0))
			addInstructions(); 
		}
		//FFUEL GAME
		private function startFuelGame():void{
			_fuel_game =  new Fuel(this);
			if(_small_size)
				_fuel_game.scaleX = _fuel_game.scaleY = _scale;
			_fuel_game.show();
		}
		public function addFuelMouseEve():void{
			root.addEventListener(MouseEvent.MOUSE_DOWN, _fuel_game.onClick);
		}
		public function removeFuelMouseEve():void{
			root.removeEventListener(MouseEvent.MOUSE_DOWN, _fuel_game.onClick);
		}
		public function removeFuelGame():void{
			_next_game_popup.update(_data.game1_score,nextGamePopUp.TANK, showNextParking);
			_next_game_popup.show();
		}
		private function showNextParking():void{
			_fuel_game.hide();
			startParking();
		}
		//PARKING GAME
		private function startParking():void{
			_parking =  new Parking(this);
			_parking.init();
			_parking.show();
		}
		public function parkingAddEvent():void{
			root.addEventListener(KeyboardEvent.KEY_DOWN,_parking.car.myOnPress);
			root.addEventListener(KeyboardEvent.KEY_UP,_parking.car.myOnRelease);
			stage.focus =  stage;  
		}
		public function removeParkingGame():void{
			root.removeEventListener(KeyboardEvent.KEY_DOWN,_parking.car.myOnPress);
			root.removeEventListener(KeyboardEvent.KEY_UP,_parking.car.myOnRelease);
			_next_game_popup.update(_data.game2_score,nextGamePopUp.PARK, showNextTrunk);
			_next_game_popup.show();
		}
		private function showNextTrunk():void{
			_parking.hide();
			startTrunkGame();
		}
		
		//TRUNK GAME
		private function startTrunkGame():void{
			_trunk_game =  new Trunk(this);
			if(_small_size)
				_trunk_game.scaleX = _trunk_game.scaleY = _scale;
			_trunk_game.show();
		}
		public function removeTrunk():void{
			_next_game_popup.update(_data.game3_score,nextGamePopUp.TRUNK, showNextRanking,true);
			_next_game_popup.show();
		}
		private function showNextRanking():void{
			_trunk_game.hide();
			addRanking();
		}
		
		//RANKING
		public function addRanking():void{
			Game.instance().data.sendScore();
			_ranking = new Ranking(this);
			if(_small_size)
				_ranking.scaleX = _ranking.scaleY = _scale;
			_ranking.show();
		}
		private function addInstructions():void{
			if(_small_size)
				_start_instructions_popup.scaleX = _start_instructions_popup.scaleY = _scale;
			this.addChild(_start_instructions_popup);
			_start_instructions_popup.men.buttonMode = true;
			_start_instructions_popup.men.mouseEnabled = true;
			_start_instructions_popup.woman.buttonMode = true;
			_start_instructions_popup.woman.mouseEnabled = true;
			_start_instructions_popup.men.addEventListener(MouseEvent.CLICK, manMode);
			_start_instructions_popup.woman.addEventListener(MouseEvent.CLICK, womanMode);
		}
		private function manMode(e:MouseEvent):void{
			_start_instructions_popup.men.removeEventListener(MouseEvent.CLICK, manMode);
			_start_instructions_popup.woman.removeEventListener(MouseEvent.CLICK, womanMode);
			removeChild(_start_instructions_popup);
			Game.instance().data.woman =  false;
			startFuelGame();
		}
		private function womanMode(e:MouseEvent):void{
			_start_instructions_popup.men.removeEventListener(MouseEvent.CLICK, manMode);
			_start_instructions_popup.woman.removeEventListener(MouseEvent.CLICK, womanMode);
			removeChild(_start_instructions_popup);
			Game.instance().data.woman =  true;
			startFuelGame();
			
		}
		private function getFlashvars():void{
			root.loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
		}
		private function loaderComplete(myEvent:Event):void {
			trace("root.loaderInfoCompleted");
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			if ((paramObj['gameId'] != undefined)) {
				_data.gameId = paramObj['gameId']
			} else {
				_data.gameId = '22';
			}
			_data.sendGameId();
			
		}
		public function get data():Data
		{
			return _data;
		}
		
		public function get parking():Parking
		{
			return _parking;
		}
		
		public function get trunk_game():Trunk
		{
			return _trunk_game;
		}
		
		public function get fuel_game():Fuel
		{
			return _fuel_game;
		}
		
		public static function instance():Game
		{
			return _instance;
		}
		
		public function get ranking():Ranking
		{
			return _ranking;
		}
		
		public function get small_size():Boolean
		{
			return _small_size;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		
		
	}
}