package controlers
	/**
	 * DeltaTimer - written by Dylan Engelman a.k.a LordOfDuct
	 * 
	 * Class written and devised for the LoDGameLibrary. The use of this code 
	 * is hereby granted to any user at their own risk. No promises or guarantees 
	 * are made by the author. Use at your own risk.
	 * 
	 * Copyright (c) 2009 Dylan Engelman
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy of this 
	 * software and associated documentation files (the "Software"), to deal in the Software 
	 * without restriction, including without limitation the rights to use, copy, modify, 
	 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
	 * permit persons to whom the Software is furnished to do so, subject to the following 
	 * conditions:
	 * 
	 * The above copyright notice and this permission notice shall be included in all copies 
	 * or substantial portions of the Software.
	 * 
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
	 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
	 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
	 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
	 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
	 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	 * 
	 * 
	 * In other words, no guarantees are made that it will work as expected nor that I (Dylan Engelman) 
	 * have to repair or give any assistance to you the user when you have troubles.
	 * 
	 */
{
	﻿  import flash.events.EventDispatcher;
	﻿  import flash.events.TimerEvent;
	﻿  import flash.utils.getTimer;
	
	﻿  public class DeltaTimer extends EventDispatcher
	﻿  {
		﻿  ﻿  private var _time:int = 0;
		﻿  ﻿  private var _dt:int = 0;
		﻿  ﻿  private var _count:int = 0;
		﻿  ﻿  private var _repeatCount:int = 0;
		﻿  ﻿  
		﻿  ﻿  private var _reinitPoint:Number = 0;
		﻿  ﻿  private var _isPaused:Boolean = true;
		﻿  ﻿  
		﻿  ﻿  public function get time():Number { return _time / 1000; }
		﻿  ﻿  public function get timeMilli():int { return _time; }
		﻿  ﻿  public function get dt():Number { return _dt / 1000; }
		﻿  ﻿  public function get dtMilli():int { return _dt; }
		﻿  ﻿  public function get currentCount():int { return _count; }
		﻿  ﻿  public function get repeatCount():int { return _repeatCount; }
		﻿  ﻿  public function get paused():Boolean { return _isPaused; }
		﻿  ﻿  
		﻿  ﻿  public function DeltaTimer( repeat:int=0 )
		﻿  ﻿  {
			﻿  ﻿  ﻿  super();
			﻿  ﻿  ﻿  _repeatCount = 0;
		﻿  ﻿  }
		﻿  ﻿  
		 ﻿  ﻿  /**
		 ﻿  ﻿   * Start the timer, resets the timer before 
		 ﻿  ﻿   * restarting in case start has already been 
		 ﻿  ﻿   * called before.
		 ﻿  ﻿   */
		﻿  ﻿  public function start(repeat:int=-1):void
		﻿  ﻿  {
			﻿  ﻿  ﻿  reset();
			﻿  ﻿  ﻿  _isPaused = false;
			﻿  ﻿  ﻿  if(repeat >= 0) _repeatCount = repeat;
		﻿  ﻿  }
		﻿  ﻿  
		 ﻿  ﻿  /**
		 ﻿  ﻿   * Updates the timer one last time and pauses it
		 ﻿  ﻿   */
		﻿  ﻿  public function pause():void
		﻿  ﻿  {
			﻿  ﻿  ﻿  _isPaused = true;
		﻿  ﻿  }
		﻿  ﻿  
		 ﻿  ﻿  /**
		 ﻿  ﻿   * resumes the timer if paused.
		 ﻿  ﻿   */
		﻿  ﻿  public function resume():void
		﻿  ﻿  {
			﻿  ﻿  ﻿  if (this.paused)
			﻿  ﻿  ﻿  {
				﻿  ﻿  ﻿  ﻿  Assertions.isNotTrue((_repeatCount && _count >= _repeatCount), "com.lordofduct.util::DeltaTimer - timer can not resume when repeatCount is satisfied.", Error ); 
				﻿  ﻿  ﻿  ﻿  _isPaused = false;
				﻿  ﻿  ﻿  ﻿  _reinitPoint = getTimer() - _time;
				﻿  ﻿  ﻿  ﻿  //accurate method
				﻿  ﻿  ﻿  ﻿  //_reinitPoint = getAccurateTimer() - _time;
			﻿  ﻿  ﻿  }
		﻿  ﻿  }
		﻿  ﻿  
		 ﻿  ﻿  /**
		 ﻿  ﻿   * resets the timer to 0 and stops it
		 ﻿  ﻿   */
		﻿  ﻿  public function reset():void
		﻿  ﻿  {
			﻿  ﻿  ﻿  _isPaused = true;
			﻿  ﻿  ﻿  _time = 0;
			﻿  ﻿  ﻿  _dt = 0;
			﻿  ﻿  ﻿  _count = 0;
			﻿  ﻿  ﻿  _reinitPoint = getTimer();
			﻿  ﻿  ﻿  //accurate method
			﻿  ﻿  ﻿  //_reinitPoint = getAccurateTimer();
		﻿  ﻿  }
		﻿  ﻿  
		 ﻿  ﻿  /**
		 ﻿  ﻿   * change in time since the last tick update... in milliseconds
		 ﻿  ﻿   */
		﻿  ﻿  public function deltaSinceLastTick():int
		﻿  ﻿  {
			﻿  ﻿  ﻿  return getTimer() - _time - _reinitPoint;
			﻿  ﻿  ﻿  //accurate method
			﻿  ﻿  ﻿  //return getAccurateTimer() - _time - _reinitPoint;
		﻿  ﻿  }
		﻿  ﻿  
		 ﻿  ﻿  /**
		 ﻿  ﻿   * Update the delta value
		 ﻿  ﻿   */
		﻿  ﻿  public function update():void
		﻿  ﻿  {
			﻿  ﻿  ﻿  if(this.paused) return;
			﻿  ﻿  ﻿  
			﻿  ﻿  ﻿  _count++;
			﻿  ﻿  ﻿  
			﻿  ﻿  ﻿  _dt = deltaSinceLastTick();
			﻿  ﻿  ﻿  _time += _dt;
			﻿  ﻿  ﻿  
			﻿  ﻿  ﻿  _dt = Math.max(0, _dt);
			﻿  ﻿  ﻿  
			﻿  ﻿  ﻿  this.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
			﻿  ﻿  ﻿  
			﻿  ﻿  ﻿  if(_repeatCount && _count == _repeatCount)
				﻿  ﻿  ﻿  ﻿  this.repeatCountDone();
		﻿  ﻿  }
		﻿  ﻿  
		﻿  ﻿  protected function repeatCountDone():void
		﻿  ﻿  {
			﻿  ﻿  ﻿  _isPaused = true;
			﻿  ﻿  ﻿  this.dispatchEvent( new TimerEvent( TimerEvent.TIMER_COMPLETE ) );
		﻿  ﻿  }
		﻿  ﻿  
		﻿  ﻿  static public function getAccurateTimer():Number
		﻿  ﻿  {
			﻿  ﻿  ﻿  return (new Date()).time;
		﻿  ﻿  }
	﻿  }
}