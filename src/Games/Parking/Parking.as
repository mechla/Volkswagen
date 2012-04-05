package Games.Parking
{
	import Games.BaseGame;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.gskinner.motion.plugins.SmartRotationPlugin;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	
	public class Parking extends BaseGame
	{
		private var _instructions:game2_info =  new game2_info();
		private var _way_points:Array =  new Array();
		private var _current_way_point:Number = 0;
		private var _car:Car =  new Car();
		private var _lamps:llapms =  new llapms();
		
		//collisions
		private var _parking_collision:MovieClip;
		private var _car_collistin:MovieClip;
		
		public function Parking(parent:DisplayObjectContainer, cansShow:Boolean = false)
		{
			super(parent, cansShow);
		}
		
		public function init():void{
			if(!Game.instance().small_size){
				_parking_collision =  new parking_hit_test();
				_car_collistin =  new car_hit_test();
				_car.x = 80;
				_car.y = 180;
			}
			else{
				if(Game.instance().scale == .8){
					_parking_collision =  new parking80();
					_car_collistin =  new car80();
				}
				if(Game.instance().scale == .7){
					_parking_collision =  new parking70();
					_car_collistin =  new car70();
				}
				_car.scaleX = _car.scaleY = Game.instance().scale;
				_lamps.scaleX = _lamps.scaleY = Game.instance().scale;
				_bg.scaleX = _bg.scaleY = Game.instance().scale;
				_car.x = 80 * Game.instance().scale;
				_car.y = 180 *Game.instance().scale;
				
			}
			_car.rotation = 90;
			addChild(_car);
			addChild(_lamps);
			addWayPoints();
			addColisions();
			_car.go = false;
			addInstructions();
		}
		private function addInstructions():void{
			if(!Game.instance().small_size){
				_instructions.x = _stage_width/2  -_instructions.width/2;
				_instructions.y = _stage_height/2  -_instructions.height/2;
			}
			else{
				_instructions.scaleX  = _instructions.scaleY = Game.instance().scale;
				_instructions.x = Math.floor(_stage_width*Game.instance().scale/2)  -Math.floor(_instructions.width*Game.instance().scale/2);
				_instructions.y = Math.floor(_stage_height*Game.instance().scale/2)  -Math.floor(_instructions.height*Game.instance().scale/2);
				
			}
			_instructions.ok.addEventListener(MouseEvent.CLICK, onClick);
			_instructions.ok.buttonMode =  true;
			_instructions.ok.useHandCursor =  true;
			addChild(_instructions);
		}
		private function onClick(e:MouseEvent):void{
			_instructions.ok.removeEventListener(MouseEvent.CLICK, onClick);
			Game.instance().parkingAddEvent();
			removeChild(_instructions);
			timerStart();
			_car.go =  true;
		}
		private function addWayPoints():void{
			var scale:Number = 1;
			if(Game.instance().small_size)
				scale = Game.instance().scale;
			_way_points.push([80*scale,180*scale,90,true]);
			_way_points.push([450*scale,185*scale,90,false]);
			_way_points.push([585*scale,520*scale,180,false]);
			_way_points.push([380*scale,655*scale,-90,false]);
		}
		private function checkWayPoints():void{
			
			if(!_way_points[1][3]){
				if(_car.x >_way_points[1][0]){
					_way_points[1][3] =   true;
					_current_way_point = 1;
					trace("waypoint 1");
				}
			}
			if(!_way_points[2][3] && _way_points[1][3]){
				if(_car.y >_way_points[2][1]){
					_way_points[2][3] =   true;
					_current_way_point = 2;
					trace("waypoint 2");
				}
			}    
			if(!_way_points[3][3] && _way_points[2][3]){
				if(_car.x < _way_points[3][0]){
					_way_points[3][3] =   true;
					_current_way_point = 3
					trace("waypoint 3");
				}
			}
			if(Game.instance().small_size){
				if(_way_points[3][3] && _car.x < 165*Game.instance().scale && _car.y > 410*Game.instance().scale  && _car.y < 540*Game.instance().scale){
					gameOver();
					_car.carRemoveEvents()
				}
			}
			else{
				if(_way_points[3][3] && _car.x < 165 && _car.y > 410  && _car.y < 540){
					gameOver();
					_car.carRemoveEvents()
				}
			}
		}
		private function addColisions():void{
			addChild(_parking_collision);
			_parking_collision.visible  = false;
			addChild(_car_collistin);
			_car_collistin.visible  = false;
			position_hit_test()
		}
		public function position_hit_test():void{
			_car_collistin.x = _car.x;
			_car_collistin.y = _car.y;
			_car_collistin.rotation = _car.rotation;
			//      trace(checkForCollision(_car_collistin, _parking_collision));
			if(checkForCollision(_car_collistin, _parking_collision) !=null){
				_car.go =  false;
				TweenMax.to(_car, 0.25, {glowFilter:{color:0xaa0000, alpha:1, blurX:20, blurY:20, strength:1, remove:true}});
				TweenLite.delayedCall(.5,moveToWayPoint);
			}
			checkWayPoints();
			
		}
		private function moveToWayPoint():void{
			_car.x = _way_points[_current_way_point][0];
			_car.y = _way_points[_current_way_point][1];
			_car.rotation = _way_points[_current_way_point][2];
			_car.go = true;
			
		}
		override protected function addBackground():void{
			_bg =  new parking_bg();
			_bg.time.text = calculateTime(Game.instance().data.score);
			addChild(_bg);
			
		}
		override protected function showTime(time:String):void{
			_bg.time.text = time;
		}
		public function get car():Car
		{
			return _car;
		}
		override protected function nextGame():void{
			Game.instance().removeParkingGame();
			
		} 
		
		override protected function gameOver():void{
			super.gameOver();
			Game.instance().data.game2_score = calculateTime(_miniseconds);
		}
		
		private function checkForCollision(p_clip1:MovieClip,p_clip2:MovieClip,p_alphaTolerance:Number = 255):Rectangle {
			
			var bounds1:Rectangle = p_clip1.getBounds(this);
			var bounds2:Rectangle = p_clip2.getBounds(this);
			
			// rule out anything that we know can't collide:
			if (((bounds1.right < bounds2.left) || (bounds2.right < bounds1.left)) || ((bounds1.bottom < bounds2.top) || (bounds2.bottom < bounds1.top)) ) {
				return null;
			}
			
			// determine test area boundaries:
			var bounds:Rectangle =  new Rectangle()
			bounds.left = Math.max(bounds1.left,bounds2.left);
			bounds.right = Math.min(bounds1.right,bounds2.right);
			bounds.top = Math.max(bounds1.top,bounds2.top);
			bounds.bottom = Math.min(bounds1.bottom,bounds2.bottom);
			
			
			// set up the image to use:
			var img:BitmapData = new BitmapData(bounds.right-bounds.left,bounds.bottom-bounds.top,false);
			
			// draw in the first image:
			var mat:Matrix = p_clip1.transform.concatenatedMatrix;
			mat.tx -= bounds.left;
			mat.ty -= bounds.top;
			img.draw(p_clip1,mat, new ColorTransform(1,1,1,1,255,-255,-255,p_alphaTolerance));
			
			// overlay the second image:
			mat = p_clip2.transform.concatenatedMatrix;
			mat.tx -= bounds.left;
			mat.ty -= bounds.top;
			img.draw(p_clip2,mat, new ColorTransform(1,1,1,1,255,255,255,p_alphaTolerance),"difference");
			
			// find the intersection:
			var intersection:Rectangle = img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);
			
			// if there is no intersection, return null:
			if (intersection.width == 0) { return null; }
			
			// adjust the intersection to account for the bounds:
			intersection.x += bounds.left;
			intersection.y += bounds.top;
			
			return intersection;
		}
		
	}
}