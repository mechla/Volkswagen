package Games.Trunk
{
  import Games.BaseGame;
  
  import com.greensock.TweenLite;
  import com.greensock.TweenMax;
  
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  [SWF(width=831,height=700)]
  public class Trunk extends BaseGame
  {
    
    
    private var _objects:Array  = new Array();
    private var _sequence:Array =  new Array();
    private var _current_index:int = 0;
    
    private var _time_spacing:Number = 1.5;
    private var _rounds:Number = 1;
    private var _amount:Number = 5;
    
    
    
    private var _instructions:game3_info =  new game3_info();
    
    public function Trunk(parent:DisplayObjectContainer, cansShow:Boolean = false)
    {
      super(parent, cansShow);
      addInstructions();
    }
    private function addInstructions():void{
      _instructions.x = _stage_width/2  -_instructions.width/2;
      _instructions.y = _stage_height/2  -_instructions.height/2;
      _instructions.ok.addEventListener(MouseEvent.CLICK, onClick);
      _instructions.ok.buttonMode =  true;
      _instructions.ok.useHandCursor =  true;
      addChild(_instructions);
    }
    private function onClick(e:MouseEvent):void{
      _instructions.ok.removeEventListener(MouseEvent.CLICK, onClick);
      removeChild(_instructions);
      if(Game.instance().data.woman) 
        addObjectsWoman()
      else
        addObjectsMan();
      startSequence()
      
    }
    private function addObjectsWoman():void{
      
      addObject("hand_bag",YellowHandBag, new Point(250,468), new Point(718,280));
      addObject("bags",TwoBags, new Point(217,322), new Point(618,283));
      addObject("beach_ball",Ball, new Point(176,442), new Point(535,355));
      addObject("deck_chair",DeckChair, new Point(315,402), new Point(600,424));
      addObject("hat",Hat, new Point(332,321), new Point(695,372));
      
    }
    private function addObjectsMan():void{
      addObject("ball",FoodBall, new Point(280,470), new Point(650,480));
      addObject("barbecue",Barbecoue, new Point(175,420), new Point(680,400));
      addObject("grill",Grill, new Point(187,330), new Point(603,302));
      addObject("giutar",Gitar, new Point(331,321), new Point(514,300));
      addObject("back_pack",BackPack, new Point(241,318), new Point(660,260));
    }
    private function addObject(id:String,className:Class,desc:Point, start:Point):void{
      var obj:TrunkObject =  new TrunkObject(id,className,desc,start);
      obj.name = id;
      _objects.push(obj)
      _sequence.push(id);
      this.addChild(obj);
    }
    private function startSequence():void{
      var i:int = 0;
//	  _sequence = randomizeSequence(_sequence);
      for each (var id:String in _sequence){
        TweenLite.delayedCall(i+=_time_spacing,startShowAniamation,[getObjectById(id)]);
      }
      TweenLite.delayedCall(i+=_time_spacing, moveObjectToStart)
    }
    private function  moveObjectToStart():void{
      for each (var o:TrunkObject in _objects){
        o.moveToStartPosition();
      }
      TweenMax.delayedCall(1,enableObjectsDrag);
    }
    private  function enableObjectsDrag():void{
      for each (var o:TrunkObject in _objects){
        o.enableDrag(checkSequence);
      }
      timerStart();
    }
    private function checkSequence(id:String):void{ //callback
      if(id == _sequence[_current_index]){
        _current_index++;
        if(_current_index == _amount){
//          _timer.stop();
			removeEventListener(Event.ENTER_FRAME, onTime);
          TweenLite.delayedCall(1,startNextSequence);
        }
        getObjectById(id).playCorrectFitAnim();
      }
      else{
        getObjectById(id).playWrongFitAnim();
        
      }
    }
    public function moveToFront(object:DisplayObject):void{
      this.setChildIndex(object, this.numChildren-1);
    }
    private function startNextSequence():void{
      _rounds--;
      if(_rounds > 0){
        _current_index = 0;
        _sequence = randomizeSequence(_sequence);
        for each (var o:TrunkObject in _objects){
          o.moveToStartPosition()
        }
        TweenLite.delayedCall(1,startSequence);
      }
      else{
        gameOver();
      }
    }
    override protected function gameOver():void{
      super.gameOver();
      Game.instance().data.game3_score = calculateTime(_miniseconds);
      
    }
    private function startShowAniamation(o:TrunkObject):void{
      o.showAtDestinationAnimation()
    }
    override protected function addBackground():void{
      _bg =  new Background_packing()
      _bg.time.text = calculateTime(Game.instance().data.score);
      this.addChild(_bg);
    }
    override protected function showTime(time:String):void{
      _bg.time.text = time;
    }
    private function getObjectById(id:String):TrunkObject{
      for each(var obj:TrunkObject in _objects){
        if (obj.name == id)
          return obj;
      }
      return null;
    }
    private function randomizeSequence(array:Array):Array{
      var newArray:Array = new Array();
      while(array.length > 0){
        newArray.push(array.splice(Math.floor(Math.random()*array.length), 1));
		trace(newArray);
      }
      return newArray;
    }
    override protected function nextGame():void{
      Game.instance().removeTrunk();
    }   
  }
}
