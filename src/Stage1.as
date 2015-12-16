package 
{
	import com.bit101.components.Calendar;
	import com.bit101.components.Style;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.TextInput;
	
	/**
	 * ...
	 * @author fs
	 */
	public class Stage1 extends MovieClip 
	{
		var currentTextInput:TextInput;
		var cal:Calendar;
		public var callBackFun:Function;
		public var dataVO:Object;
		public function Stage1() 
		{
			super();
			this.dataVO = new Object();
		}

		public function transitionIn(container:DisplayObjectContainer):void 
		{
			container.addChild(this);
			TweenLite.from(this, 0.1, { alpha:0} );
		}
		public function transitionOut(callBackFun):Object 
		{
			this.callBackFun = callBackFun;
			TweenLite.to(this, 0.1, { alpha:0, onComplete:overFunc } );
			this.dataVO["projectName"] = projectName.text;
			return this.dataVO;
		}
		private function overFunc():void {
			this.alpha = 1;
			this.parent.removeChild(this);
			callBackFun.apply();
		}
	}
}