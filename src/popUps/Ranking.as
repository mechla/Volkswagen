package popUps
{
  import Games.ShowObject;
  
  import flash.display.DisplayObjectContainer;
  import flash.display.MovieClip;
  import flash.display.Sprite;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  
  public class Ranking extends ShowObject
  {
    private var _scores_bg:score_list_bg =  new score_list_bg();
    private var _player:position_score_class =  new position_score_class();
    private var _pages:Array =  new Array();
    private var _current_page:int = 0;
    public function Ranking(parent:DisplayObjectContainer, cansShow:Boolean = false)
    {
      super(parent, cansShow);
      
      addChild(_scores_bg);
      _player.x = 30;
      _player.y = 630;
      addChild(_player);
      updatePlayer();
      
    }
    public function updateRanking():void{
      updatePlayer();
      var index:int = -1;
      var start_point:Point =  new Point(30,202);
      for each(var p:Player in Game.instance().data.players){
        index++;
        var player_view:position_score_class =  new position_score_class();
        player_view.position.text = p.place.toString();
        player_view.fullname.text = p.full_name.toString();
        player_view.time.text  = calculateTime(p.points);
        if(index == 0){
          var page:MovieClip =  new MovieClip();
          _pages.push(page)
        }
        if(index <10){
          player_view.x = start_point.x;
          player_view.y = start_point.y + index*40;
          page.addChild(player_view);
        }
        if(index == 9){
          index = -1;
        }
      }
      if(_pages[_current_page] !=null){
        addChild(_pages[_current_page]);
        _scores_bg.next.addEventListener(MouseEvent.CLICK, nextClick);
        _scores_bg.prev.addEventListener(MouseEvent.CLICK, prevClick);
      }
      
    }
    private function nextClick(e:MouseEvent):void{
      removeChild(_pages[_current_page]);
      _current_page++;
      if(_current_page >=_pages.length)
        _current_page = _pages.length-1
      addChild(_pages[_current_page]);
    }
    private function prevClick(e:MouseEvent):void{
      removeChild(_pages[_current_page]);
      _current_page--;
      if(_current_page  <0)
        _current_page = 0
      addChild(_pages[_current_page]);
    }
    public function updatePlayer():void{
      if(Game.instance().data.current_user_index!=null)
        _player.position.text = Game.instance().data.current_user_index;
      else
        _player.position.text = "";
      if(Game.instance().data.first_name !=null)
        _player.fullname.text = Game.instance().data.first_name+" "+Game.instance().data.last_name;
      else
        _player.fullname.text = "unknown";
      _player.time.text = calculateTime(Game.instance().data.score);
    }
	
  }
}