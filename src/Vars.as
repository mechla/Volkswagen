package
{
	public class Vars
	{
		private static var _instance:Vars =  new Vars();
		private  var _time_change:Number =  17; //dzilenik czasu do regulacji wyników w rankingu
		private var _scale:Number = .8;  //mnijeszy wymiar swf 80%
		private var _small:Boolean =  false;  // czy skomplilować swf w skali _scale (wyżej)
		protected var _games:Number = 0; // kompilacja od wybranej gry  1,2,3,4 -ranking
		
		
		public function Vars()
		{
		}

		public function get small():Boolean
		{
			return _small;
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function get time_change():Number
		{
			return _time_change;
		}

		public static function instance():Vars
		{
			return _instance;
		}
	}
}