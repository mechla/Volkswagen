package Games
{
  import com.greensock.TweenMax;
  import com.greensock.easing.Back;
  
  import flash.display.DisplayObjectContainer;
  import flash.display.MovieClip;
  
  public class ShowObject extends MovieClip
  {
    protected var _parentClip:DisplayObjectContainer;
    protected var _stage_width:Number = 830;
    protected var _stage_height:Number = 700;
    
    public function ShowObject(pClip:DisplayObjectContainer, canShow:Boolean = false)
    {
      super();
      _parentClip = pClip;
      if(canShow)
        show();
    }
    public function blink(v:uint=0xffffff):void
    {
      TweenMax.to(this, 0.25, {glowFilter:{color:v, alpha:1, blurX:20, blurY:20, strength:1, remove:true}});
    }
    public function show(...args):void
    {
      if (!this.stage)
      {
        _parentClip.addChild(this);
        this.alpha=0;
      }
      TweenMax.to(this,0.5,{alpha:1,ease:Back.easeOut});
    }
    
    public function hide(...params):void
    { 
      if (this.stage)
      {
        TweenMax.to(this,0.5,{alpha:0,ease:Back.easeIn,onComplete:removeMe});
      }
    }
    public function removeMe():void
    {
      if(this.stage != null)
        this.parent.removeChild(this);
    }
    public function get parentClip():DisplayObjectContainer
    {
      return _parentClip;
    }
	protected function calculateTime(time:Number):String{
		var seconds:Number = Math.floor(time/100);
		var minisecons:Number = time%100;
		var minuts:Number = Math.floor(seconds/60);
		seconds = seconds%60;
		var minisec_str:String;
		if(minisecons.toString().length == 1)
			minisec_str = "0"+minisecons.toString();
		if(minisecons.toString().length == 2)
			minisec_str = ""+minisecons.toString();
		if(minisecons.toString().length == 3)
			minisec_str = minisecons.toString();
		
		minisec_str = minisec_str.charAt(0) + minisec_str.charAt(1);
		var time_str:String;
		if (seconds.toString().length == 1)
			time_str = "0"+seconds.toString();
		else
			time_str = seconds.toString();
		
		var minut_str:String = "00:";
		if (minuts.toString().length == 1)
			minut_str = "0"+minuts.toString();
		else
			minut_str = minuts.toString();
		return minut_str+":"+time_str+":"+minisec_str;
	}
  }
}