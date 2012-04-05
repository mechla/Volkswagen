package Games.Trunk
{
  import com.greensock.TweenLite;
  import com.greensock.TweenMax;
  import com.greensock.plugins.*;
  
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.filters.ColorMatrixFilter;
  import flash.filters.GlowFilter;
  import flash.filters.ShaderFilter;
  import flash.geom.Point;
  
  public class TrunkObject extends MovieClip
  {
    private var _id:String;
    private var _destination:Point;
    private var _start:Point;
    private var _object:Sprite;
    private var _shadow:Sprite;
    
    private var _callback:Function;
    private var _mouse_offset:Point;
    private var _fault_distans:Number = 20;
    
    private var _show_time:Number = .4;
    private var _glow_time:Number = .5;
    
    
    TweenPlugin.activate([ColorMatrixFilterPlugin, EndArrayPlugin]);
    public function TrunkObject(id:String,className:Class,desc:Point, start:Point)
    {
      super();
      _id = id;
//      trace(className);
      _object = new className();
//      _object.buttonMode = true;
//      _object.mouseEnabled = true;
      _shadow = new className();
      _destination = desc;
      _start = start;
      addShadow();
      addObject();
    }
    
    //DODANIE OBIEKTÓW
    private function addObject():void{
      _object.x = _start.x;
      _object.y = _start.y;
      this.addChild(_object);
    }
    private  function addShadow():void{
      TweenMax.to(_shadow, 0, {colorMatrixFilter:{colorize:0xffffff, amount:1, brightness:3, hue:0, threshold:128}});
      _shadow.alpha = .2;
      _shadow.x = _destination.x;
      _shadow.y = _destination.y;
      this.addChild(_shadow);
    }
    
    //SHOWING ORDER ANIMATIONS
    public function showAtDestinationAnimation():void{
      TweenLite.to(_object,_show_time,{alpha:0,onComplete:showAtDestination});
    }
    private function showAtDestination():void{
      _object.x = _destination.x;
      _object.y = _destination.y;
      TweenLite.to(_object,_show_time,{alpha:1});
    }
    public function moveToStartPosition():void{
//      trace("move to start position ", _id," alpha to 0");
      TweenLite.to(_object, _show_time, {alpha:0, onComplete:showAtStartPosition});
    }
    public function showAtStartPosition():void{
      _object.x = _start.x;
      _object.y = _start.y;
      TweenLite.to(_object, _show_time, {alpha:1}); // czy tu odrazu dawac drag
    }
//    private function removeFromStartPostion():void{
//      TweenLite.to(_object, _show_time, {_alpha:0, onComplete:showAtStartPosition});
//    }
    
    //MOVING
    public function enableDrag(callback:Function):void{
//      trace("add mouse down event ", _id);
      _callback =  callback;
      _object.addEventListener(MouseEvent.MOUSE_DOWN, startDraging);
    }
    private function startDraging(e:MouseEvent):void{
      Game.instance().trunk_game.moveToFront(this);
//      trace("start draging ", _id);
      _mouse_offset =  new Point(mouseX - _object.x, mouseY -_object.y);
      _object.removeEventListener(MouseEvent.MOUSE_DOWN, startDraging);
      stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      _object.addEventListener( MouseEvent.MOUSE_UP, stopDraging);
    }
    private function onMouseMove(e:MouseEvent):void{
      _object.x = mouseX - _mouse_offset.x;
      _object.y = mouseY - _mouse_offset.y;
    }
    private function stopDraging(e:MouseEvent):void{
//      trace(" stop drag & remove mouse down event ", _id);
      stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
      _object.removeEventListener( MouseEvent.MOUSE_UP, stopDraging);;
      checkAccuracy();
      
    }
    private function checkAccuracy():void{
      if (_object.x > _destination.x - _fault_distans 
        && _object.x < _destination.x + _fault_distans 
        && _object.y > _destination.y - _fault_distans
        && _object.y < _destination.y + _fault_distans){
//        trace("corrent position ", _id);
        _callback(_id);
        TweenLite.to(_object, .5, {x:_destination.x, y:_destination.y});
        
      }
      else
        TweenLite.to(_object, 1, {x:_start.x,y:_start.y, onComplete:enableDrag, onCompleteParams:[_callback]});
//        enableDrag(_callback);
    }
    public function playCorrectFitAnim():void{
      TweenMax.to(_object, _glow_time/2,{glowFilter:{color:0xffffff, alpha:1, blurX:20, blurY:20, strength:1}, onComplete:removeGlow});
    }
    public function playWrongFitAnim():void{
      TweenMax.to(_object, _glow_time/2,{glowFilter:{color:0xcc0000, alpha:1, blurX:20, blurY:20, strength:1}, onComplete:removeGlow});
      TweenLite.delayedCall(_glow_time/2,moveToStartPosition);
      TweenLite.delayedCall(_glow_time,enableDrag,[_callback]);
    }
    private function removeGlow():void{
      TweenMax.to(_object, _glow_time/2,{glowFilter:{color:0xcc0000, alpha:0, blurX:0, blurY:0, strength:0}});
    }
    
    //RESZTA
    public function moveToTruck():void{
      TweenLite.to(_object, 1.5,{x:_destination.x, y:_destination.y});
    }

    public function get id():String
    {
      return _id;
    }
    
    
  }
}