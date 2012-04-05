package popUps
{
  import flash.display.Sprite;

  public class Player extends Sprite
  {
    private var _id:String;
    private var _place:Number;
    private var _full_name:String;
    private var _points:Number;
    public function Player(place:Number,point:Number,full_name:String) 
    {
      super();
      this._place = place;
      _full_name = full_name;
      _points = point;
    }

    public function get id():String
    {
      return _id;
    }

    public function set id(value:String):void
    {
      _id = value;
    }

    public function get place():Number
    {
      return _place;
    }

    public function set place(value:Number):void
    {
      _place = value;
    }

    public function get full_name():String
    {
      return _full_name;
    }

    public function set full_name(value:String):void
    {
      _full_name = value;
    }

    public function get points():Number
    {
      return _points;
    }

    public function set points(value:Number):void
    {
      _points = value;
    }


  }
}