package Games

{
  import com.greensock.TweenMax;
  
  import flash.filters.BevelFilter;
  import flash.filters.BlurFilter;
  import flash.filters.DropShadowFilter;
  import flash.filters.GlowFilter;
  import flash.text.*;
  
  
  public class BaseTextFiled extends TextField
  {
    private static const fontName:String = "Arial";//"Futura T OT Medium"; // "Futura No2 D OT Medium" "Arial"
    private var _fontSize:int;
    private var _defaultFontSize:int;
    private var _format:TextFormat;
    public function BaseTextFiled(fontSize:int=15,fontColor:uint=0x0, bold:Boolean = false)
    {
      super();
      _defaultFontSize = fontSize;
      this.embedFonts = true;
      this.selectable = false;
      this.multiline = true;
      this._fontSize = fontSize;
      createTextFormat(fontSize,fontColor, bold);
      defaultTextFormat=_format;
    }
    
    private function createTextFormat(fontSize:int=15,fontColor:uint=0x0,bold:Boolean = false):void{
      _format = new TextFormat();
      _format.font = fontName;
      _format.bold = bold;
      _format.color = fontColor;
      _format.size = fontSize;
      _format.align = TextFormatAlign.CENTER;
    }
    public function updateTextFormat():void
    {
      if(_format)
      {
        _format.size = _defaultFontSize;
        _fontSize = _defaultFontSize;
        setTextFormat(_format)
      }
    }
    public function fitToWidth(space:Number):void
    {
      while(this.textWidth>space-20) {
        _fontSize--;
        _format.size = _fontSize;
        this.setTextFormat(_format);
      }
    }
    public function changeFontSize(callback:Function = null, callbackParams:* = null):void{
      _fontSize--;
      _format.size = _fontSize;
      this.setTextFormat(_format);
      if(callback!=null)
        callback(callbackParams);
    }
    public function device():void{
      this.text = replace(" ","\n",this.text);
    }
    private function replace(searchStr:String,replaceStr :String,origStr:String):String
    {
      if (origStr.indexOf(searchStr) != -1)
        origStr = origStr.replace(searchStr,replaceStr);
      return origStr;
    }
    
    public function get fontSize():int
    {
      return _fontSize;
    }
    
  }
}