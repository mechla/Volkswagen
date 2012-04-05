package popUps
{
	import Games.ShowObject;
	
	import flash.display.DisplayObjectContainer;
	
	public class WentWrong extends ShowObject
	{
		public function WentWrong(pClip:DisplayObjectContainer, canShow:Boolean=false)
		{
			super(pClip, canShow);
			var bg:sorry_went_wrong =  new sorry_went_wrong();
			bg.x = _stage_width/2 - bg.width/2;
			bg.y = _stage_height/2 -bg.height/2;
			this.addChild(bg);
		}
	}
}