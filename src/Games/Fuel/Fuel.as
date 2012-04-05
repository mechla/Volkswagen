package Games.Fuel
{
  import Games.BaseGame;
  import Games.BaseTextFiled;
  
  import com.greensock.TweenLite;
  import com.greensock.TweenMax;
  import com.greensock.easing.Linear;
  
  import flash.display.DisplayObjectContainer;
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.geom.Point;
  import flash.text.TextFieldAutoSize;
  import flash.utils.Timer;
  
  
  public class Fuel extends BaseGame
  {
    
    private var _aperture:Aperture =  new Aperture();
    
    
    private var _fuel:Number = 0;
    
    
    private var _mid:Point =  new Point(408,392);
    
    private var _vertical:MovieClip;
    private var _horizonal:MovieClip;
    private var _move_horizontal:Boolean = false;
    private var _move_vertical:Boolean = false;
    private var _add:Number =  5;
    
    private var _hit:Number =  17;
    private var _move:Number = 1.6;
    private var _move_bound:Number = 70;
    
    private var _break_time:Number = 3.8;
    private var _cloud_time:Number = 3.3;
    private var _cloud_text:BaseTextFiled =  new BaseTextFiled(13,0x333333);
    private var _text_y_pos:Number  = 498;
    private var _all_texts:Array  = new Array();
    
    
    private var _instructions:game1_info =  new game1_info();
    private var _cloud_tween:Number =0;
    public function Fuel(parent:DisplayObjectContainer, cansShow:Boolean = false)
    {
      super(parent, cansShow);
      
      pushAllTexts();
      addTextField();
      addAperture();
      addNavigation();
      addInstructions();
    }
    private function addTextField():void{
      _cloud_text.x = 602;
      _cloud_text.y =  _text_y_pos;
      _cloud_text.width = 130;
      _cloud_text.wordWrap =  true;
      _cloud_text.autoSize = TextFieldAutoSize.CENTER;
    }
    private function addInstructions():void{
      this.addChild(_instructions);
      _instructions.x =  _stage_width/2 - _instructions.width/2;
      _instructions.y = _stage_height/2 - _instructions.height/2;
      _instructions.ok.buttonMode  = true;
      _instructions.ok.useHandCursor  = true;
      _instructions.ok.addEventListener(MouseEvent.CLICK, startGame);
    }
    private function startGame(e:MouseEvent):void{
      _instructions.ok.removeEventListener(MouseEvent.CLICK, startGame);
      this.removeChild(_instructions);
      TweenLite.delayedCall(.5, startGameNavi);
    }
    private function startGameNavi():void{
      timerStart();
      moveNavigation();
      
    }
    ////// add objects
    private function addAperture():void{
      _aperture.gotoAndStop(1);
      _aperture.x = _mid.x;
      _aperture.y = _mid.y;
      this.addChild(_aperture);
    }  
    override protected function addBackground():void{
      _bg =  new Bg();
      _bg.time.text = calculateTime(Game.instance().data.score);
      this.addChild(_bg);
    }
    override protected function showTime(time:String):void{
      _bg.time.text = time;
    }
    protected function addNavigation():void{
      _vertical = _bg.navigation.vertical;
      _horizonal = _bg.navigation.horizontal;
      _horizonal.x = -_move_bound;
      _vertical.y = -_move_bound;
      _aperture.x = _mid.x +_horizonal.x*_move;
      _aperture.y = _mid.y + _vertical.y* _move;
    }
    private function moveNavigation():void{
      if(!_game_over){
        _aperture.gotoAndStop(1);
//		timerStart();
        _horizonal.x = -_move_bound;
        _vertical.y = -_move_bound;
        _move_horizontal =  true;
        Game.instance().addFuelMouseEve();
        addEventListener(Event.ENTER_FRAME, onEnterFrame);  
      }
    }
//	override public function onTime(e:Event):void{
//		
//		var date:Date =  new Date();
//		_one_round_time = date.valueOf() - _start_date.valueOf()
//		showTime(calculateTime(Game.instance().data.score + _miniseconds + _one_round_time));
//		
//	}
//	override protected function timerStart():void{
//		_one_round_time = 0;
//		_start_date =  new Date();
//		addEventListener(Event.ENTER_FRAME, onTime);
//	}
//	
//	override protected function timerStop():void{
//		removeEventListener(Event.ENTER_FRAME, onTime);
//		_miniseconds = _miniseconds + _one_round_time;
//	}
    
    private function onEnterFrame(e:Event):void{
      if(_move_horizontal){
        _horizonal.x = _horizonal.x + _add;
        if (_horizonal.x > _move_bound){
          _add = _add * (-1);
          _horizonal.x = _move_bound;
        }
        if(_horizonal.x < -_move_bound){
          _horizonal.x = -_move_bound;
          _add = _add * (-1);
        }
        _aperture.x = _mid.x +_horizonal.x*_move;
      }
      if(_move_vertical){
        _vertical.y = _vertical.y + _add;
        if(_vertical.y > _move_bound){
          _add = _add * (-1);
          _vertical.y = _move_bound;
        }
        if(_vertical.y < -_move_bound){
          _vertical.y = -_move_bound;
          _add = _add * (-1);         
        } 
        _aperture.y = _mid.y + _vertical.y* _move;
      }
    }
    public function onClick(e:MouseEvent):void{
      _add = Math.abs(_add);
      if(_move_vertical){
        _move_vertical = false
        removeEventListener(Event.ENTER_FRAME, onEnterFrame); 
        Game.instance().removeFuelMouseEve();
        checkPosition();
      } 
      if(_move_horizontal) {
        _move_horizontal =  false;
        _move_vertical =  true;
      }
    }
    private function checkPosition():void{
      if(_vertical.y>= -_hit  && _vertical.y<= _hit  && _horizonal.x >= -_hit  && _horizonal.x <= _hit ){
        _add = Math.abs(_add)+1;
        moveFuel();
        TweenLite.to(_aperture,.25,{x:_mid.x, y:_mid.y});
      }
      else
        TweenLite.delayedCall(.5,moveNavigation);    
    }   
    private function moveFuel():void{
//		timerStop();
      _aperture.gotoAndPlay(2);
      TweenLite.delayedCall(_break_time,moveNavigation);
      _fuel++;
      _bg.fuel.gotoAndPlay("label"+_fuel.toString());
      playCloud();
      if(_fuel < 5)
        trace("trafiony", _fuel)
      else
        gameOver()
    }
    override protected function nextGame():void{
      Game.instance().removeFuelGame();
    } 
    private function playCloud():void{
      _cloud_text.alpha = 0;
      var text:Array = getText(_fuel-1)
      _cloud_text.text = text[0]+" "+text[1];
      _cloud_text.y = _text_y_pos - _cloud_text.textHeight/2;
      if(_cloud_text.parent == null){
        this.addChild(_cloud_text);
      }
      
      if(_cloud_tween == 0){
        _bg.claud.gotoAndPlay("show");
      }
      _cloud_tween++;
      TweenLite.delayedCall(.5,showCloudText);
    }
    private function showCloudText():void{
      TweenLite.to(_cloud_text, .25, {alpha:1});
      TweenLite.delayedCall(_cloud_time,hideCloud);
      
    }
    private function hideCloud():void{
      
      _cloud_tween--;
      if(_cloud_tween == 0 ){
        TweenLite.to(_cloud_text, .01, {alpha:0});
        _bg.claud.gotoAndPlay("hide");
      }
      
    }
    
    override protected function gameOver():void{
      super.gameOver();
      Game.instance().data.game1_score = calculateTime(_miniseconds);
    }
    
    private function getText(index:int):Array{
      var text:Array = new Array();
      var random:int = Math.floor( Math.random() * _all_texts[index][0] + 1);
      text = _all_texts[index][random];
      
//            trace(index,random, _all_texts[index][0]);
//            trace(text);
//            trace(text[0])
//            trace(text[1]);
//      
      return text;
    }
    private function pushAllTexts():void{
      
      var first:Array =  new Array();
      first.push(1);
      first.push(["Z tą ilością paliwa dojedziesz z ","Krakowa do Częstochowy"]);
      first.push(["Z tą ilością paliwa dojedziesz z","Warszawy do Łodzi"]);
      first.push(["Z tą ilością paliwa dojedziesz z","Warszawy na Camerimage"]);
      first.push(["Z tą ilością paliwa dojedziesz z","Poznania do Zielonej Góry"]);
      first.push(["Z tą ilością paliwa","okrążysz Poznań dookoła"]);
      first.push(["Zaledwie tyle, a","kielczanin zobaczy sukiennice"]);
      first.push(["Tak niewiele, a pozwoli rzeszowianinowi","zobaczyć zaporę w Solinie"]);
      first.push(["Tylko tyle wystarczy, by krakowianin zobaczył","Studnię Trzech Braci"]);
      first.push(["Tyle paliwa wystarczy, by poznaniak","przespacerował się po rawickich plantach"]);
      first[0] = first.length -1;
      _all_texts.push(first);
      
      var second:Array =  new Array();
      second.push(1);
      second.push(["Z tą ilością paliwa dojedziesz z ","Płocka do Sandomierza"]);
      second.push(["Z tą ilością paliwa dojedziesz z ","Radomia do Opola"]);
      second.push(["Tylko tyle wystarczy","by radomianin zaśpiewał w Opolu"]);
      second.push(["Z tą ilością paliwa dojedziesz z","Wrocławia do Pragi"]);
      second.push(["Tak niewiele paliwa w baku up! pozwoli","wrocławianinowi obejrzeć most Karola"]);
      second.push(["Z tą ilością paliwa dojedziesz z Katowic","w Góry Świętokrzyskie"]);
      second.push(["Taka ilość paliwa wystarczy, aby wrocławianin pojechał","aby zajadać się piernikami w Toruniu"]);
      second.push(["Będąc we Wrocławiu taka ilość paliwa w baku up!","dzieli Cię od zajadania się piernikami w Toruniu"]);
      second.push(["Zaledwie tyle paliwa w baku,","a warszawiak zwiedzi kopalnię w Wieliczce"]);
      second.push(["Taka ilość paliwa wystarczy,","by olsztynianin zobaczył rawickie planty"]);
      second[0] = second.length-1;
      _all_texts.push(second);
      
      var third:Array =  new Array();
      third.push(1);
      third.push(["Z tą ilością paliwa dojedziesz z","Bydgoszczy do Berlina"]);
      third.push(["Tylko tyle paliwa wystarczy,","by bydgoszczanin zobaczył Bramę Brandenburską"]);
      third.push(["Z tą ilością paliwa dojedziesz z","Białegostoku do Rzeszowa"]);
      third.push(["Taka ilość paliwa pozwala na to,","by rzeszowianin zobaczył prawdziwego żubra."]);
      third.push(["Z tą ilością paliwa dojedziesz z","Krakowa do Poznania"]);
      third.push(["Zaledwie tyle paliwa w baku up!","dzieli krakowianina od zobaczenia słynnych, poznańskich koziołków."]);
      third.push(["Taka ilość paliwa dzieli krakowianina od","podziwiania poznańskich koziołków"]);
      third.push(["Wystarczy tyle paliwa w baku, by białostoczanin","pojechał do Sopotu i przespacerował się po molo"]);
      third.push(["Tyle paliwa w up! pozwoli","białostoczaninowi na wycieczkę do Sopotu"]);
      third[0] = third.length -1;
      _all_texts.push(third);
      
      
      var fourth:Array =  new Array();
      fourth.push(1);
      fourth.push(["Tylko tyle wystarczy, by","Krakowianin zwiedził Budapeszt"]);
      fourth.push(["Tak niewiele paliwa pozwoli","krakowianinowi spotkać kontrolerów węgierskiego metra"]);
      fourth.push(["Taka ilość paliwa pozwala na to, by","wrocławianin zwiedził Lwów"]);
      fourth.push(["Z tą ilością paliwa dojedziesz z","Warszawy do Krakowa... i z powrotem!"]);
      fourth.push(["Z tą ilością paliwa dojedziesz z","Katowic do Gdańska"]);
      fourth.push(["Tyle paliwa w baku up! pozwala na dojazd z","Katowic nad Morze Bałtyckie!"]);
      fourth.push(["Katowiczanin potrzebuje tylko tyle paliwa w up!, aby pojechać na","wymarzony urlop nad Morze Bałtyckie"]);
      fourth.push(["Z tą ilością paliwa dojedziesz z","Krakowa do Malborka"]);
      fourth.push(["Zaledwie tyle, a krakowianin zwiedzi","krzyżacką twierdzę w Malborku"]);
      fourth[0] = fourth.length -1;
      _all_texts.push(fourth);
      
      var fiveth:Array =  new Array();
      fiveth.push(1);
      fiveth.push(["Z taką ilością paliwa dojedziesz","z Zakopanego do Gdańska"]);
      fiveth[0] = fiveth.length -1;
      _all_texts.push(fiveth);
      
    }
  }
}



//    private function pushTexts():void{
//      _texts.push(["\nTyle paliwa i\ndojedziesz z","Rakowa do \nCzęstochowy"]);
//      _texts.push(["Tak niewiele \npaliwa w \nbaku up! pozwoli","wrocławianinowi \nobejrzeć \nMost Karola" ]);
//      _texts.push(["\nTyle paliwa i \ndojedziesz z","Katowic w \nGóry \nSwiętokrzyskie"]);
//      _texts.push(["Katowiczanin \npotrzebuje tyle paliwa \naby pojechać na ","wymarzony urlop \nnad \nMorze Bałtyckie"]);
//      _texts.push(["\nTyle paliwa \nwystarczy, aby","olsztynianin \nzobaczył \nRawickie Planty"]);
//    }






//1 krok -
//  - Z tą ilością paliwa dojedziesz z Krakowa do Częstochowy
//    - Z tą ilością paliwa dojedziesz z Warszawy do Łodzi
//      - Z tą ilością paliwa dojedziesz z Warszawy na Camerimage
//      - Z tą ilością paliwa dojedziesz z Poznania do Zielonej Góry
//        - Z tą ilością paliwa okrążysz Poznań dookoła
//        - Zaledwie tyle, a kielczanin zobaczy sukiennice
//        - Tak niewiele, a pozwoli rzeszowianinowi zobaczyć zaporę w Solinie
//        - Tylko tyle wystarczy, by krakowianin zobaczył Studnię Trzech Braci
//        - Tylko tyle paliwa w baku up! wystarczy, by poznaniak przespacerował się po rawickich plantach

//        2 krok -
//          
//          - Z tą ilością paliwa dojedziesz z Płocka do Sandomierza
//            - Z tą ilością paliwa dojedziesz z Radomia do Opola
//              - Tylko tyle wystarczy, by radomianin zaśpiewał w Opolu
//              - Z tą ilością paliwa dojedziesz z Wrocławia do Pragi
//                - Tak niewiele paliwa w baku up! pozwoli wrocławianinowi obejrzeć most Karola
//                - Z tą ilością paliwa dojedziesz z Katowic w Góry Świętokrzyskie
//                - Taka ilość paliwa wystarczy, aby wrocławianin pojechał do Torunia, aby zajadać się piernikami
//                  - Będąc we Wrocławiu taka ilość paliwa w baku up! dzieli Cię od zajadania się piernikami w Toruniu.
//                    - Zaledwie tyle paliwa w baku, a warszawiak zwiedzi kopalnię w Wieliczce
//                  - Taka ilość paliwa wystarczy, aby olszytnianin zobaczył rawickie planty
//                  
//   

//                  3 krok -
//                    
//                    - Z tą ilością paliwa dojedziesz z Bydgoszczy do Berlina
//                      - Tylko tyle paliwa wystarczy, by bydgoszczanin zobaczył Bramę Brandenburską.
//                        - Z tą ilością paliwa dojedziesz z Białegostoku do Rzeszowa.
//                          - Taka ilość paliwa pozwala na to, by rzeszowianin zobaczył prawdziwego żubra.
//                            - Z tą ilością paliwa dojedziesz z Krakowa do Poznania
//                              - Zaledwie tyle paliwa w baku up! dzieli krakowianina od zobaczenia słynnych, poznańskich koziołków.
//                                - Taka ilość paliwa dzieli krakowianina od podziwiania poznańskich koziołków.
//                                  - Z tą ilością paliwa dojedziesz z Białegostoku do Sopotu.
//                                    - Zaledwie tyle paliwa w baku up! dzieli krakowianina od zobaczenia słynnych, poznańskich koziołków.
//                                      - Taka ilość paliwa dzieli krakowianina od podziwiania poznańskich koziołków.
//                                        - Wystarczy tyle paliwa w baku, by białostoczanin dojechał do Sopotu i przespacerował się po molo.
//                                          - Tyle paliwa w up! pozwoli białostoczaninowi na wycieczkę do Sopotu.
//                                            4 krok -


//krok 4
//- Tylko tyle wystarczy, by krakowianin zwiedził Budapeszt
//- Tak niewiele paliwa pozwoli krakowianinowi spotkać kontrolerów węgierskiego metra
//- Taka ilość paliwa pozwala na to, by wrocławianin zwiedził Lwów
//- Z tą ilością paliwa dojedziesz z Warszawy do Krakowa... i z powrotem!
//  - Z tą ilością paliwa dojedziesz z Katowic do Gdańska
//    - Tyle paliwa w baku up! pozwala na dojazd z Katowic nad Morze Bałtyckie!
//      - Katowiczanin potrzebuje tylko tyle paliwa w up!, aby pojechać na wymarzony urlop nad Morze Bałtyckie.
//        - Z tą ilością paliwa dojedziesz z Krakowa do Malborka
//          - Zaledwie tyle, a krakowianin zwiedzi krzyżacką twierdzę w Malborku
//          //
//          //
//          //
//                                              