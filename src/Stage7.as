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
	public class Stage7 extends MovieClip 
	{
		var currentTextInput:TextInput;
		var cal:Calendar;
		public var callBackFun:Function;
		public var dataVO:Object;
		public function Stage7() 
		{
			super();
			
			Style.fontSize = 9;
            Style.embedFonts = false;
            Style.fontName = '宋体';
			Style.setStyle("light");
			cal = new Calendar();
			starttimeBtn.addEventListener(MouseEvent.CLICK, startMouseClickHandler);
			endtimeBtn.addEventListener(MouseEvent.CLICK, startMouseClickHandler);
			starttimeBtn.text = endtimeBtn.text = cal.year + "-" + cal.month + "-" + cal.day;
		}
		
		private function startMouseClickHandler(e:Event):void 
		{
			addChild(cal);
			currentTextInput = e.currentTarget as TextInput;
			cal.addEventListener(Event.SELECT, selectHandler);
		}
		
		private function selectHandler(e:Event):void 
		{
			currentTextInput.text = cal.year.toString() + "-" + cal.month.toString() + "-" + cal.day.toString();
			removeChild(cal);
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
			this.dataVO = new Object();
			this.dataVO["starttime"] = starttimeBtn.text;
			this.dataVO["endtime"] = endtimeBtn.text;
			this.dataVO["stageName"] = "外购清单";
			this.dataVO["dutyMan"] = dutyMan.text;
			return this.dataVO;
		}
		private function overFunc():void {
			this.parent.removeChild(this);
			this.alpha = 1;
			callBackFun.apply();
		}
	}
}