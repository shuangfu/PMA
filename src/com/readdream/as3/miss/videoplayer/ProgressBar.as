package com.readdream.as3.miss.videoplayer 
{
	import adobe.utils.CustomActions;
	import com.readdream.as3.event.VPUIEvent;
	import com.readdream.as3.robot.Robot_PicLoader;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author fs
	 */
	public class ProgressBar extends VideoPlayerBtnCore 
	{
		private var controlBtn:Robot_PicLoader;
		private var backgroundBar:Sprite;
		private var bufferedBar:Sprite;
		private var playedBar:Sprite;
		
		private var totalTime:Number;
		private var nowTime:Number;
		
		private var allowedControlBarMove:Boolean = true;
		
		private var fullScreenFlag:Boolean = true;
		public function ProgressBar(status1AssetURL:String,status2AssetURL:String = null,initStatus:Boolean = false) 
		{
			super(status1AssetURL,null,initStatus);
		}
		override protected function setupUI():void {
			status2 = status1;
			controlBtn = status1;
			controlBtn.buttonMode = true;

			backgroundBar = new Sprite();
			bufferedBar = new Sprite();
			playedBar = new Sprite();
			playedBar.y = 4.5;
			bufferedBar.y = 4.5;
			backgroundBar.y = 3.5;
			this.addChildAt(playedBar, 0);
			this.addChildAt(bufferedBar,0);
			this.addChildAt(backgroundBar,0);
			
		}
		public function toggleFullScreen(isFullScreenFlag:Boolean):void {
			buildUI(isFullScreenFlag);
		}
		public function setTotalTime(totalTime:Number):void {
			this.totalTime = totalTime;
		}
		private function buildUI(isFullScreenFlag:Boolean):void //true:normalScreen false:fullScreen
		{
			if (!isFullScreenFlag) 
			{
				backgroundBar.graphics.clear();
				backgroundBar.graphics.beginFill(VideoPlayerBtnCore.PROGRESSBARBACKGROUNDCOLOR);
				backgroundBar.graphics.drawRect(0, 0, VideoPlayerBtnCore.PROGRESSBARWIDTH, VideoPlayerBtnCore.PROGRESSBARHEIGHT);
				backgroundBar.graphics.endFill();
				backgroundBar.graphics.lineStyle(1, VideoPlayerBtnCore.PROGRESSBARUPBORDERCOLOR);
				backgroundBar.graphics.lineTo(VideoPlayerBtnCore.PROGRESSBARWIDTH, 0);
				backgroundBar.graphics.lineStyle(1, VideoPlayerBtnCore.PROGRESSBARDOWNBORDERCOLOR);
				backgroundBar.graphics.moveTo(0, VideoPlayerBtnCore.PROGRESSBARHEIGHT);
				backgroundBar.graphics.lineTo(VideoPlayerBtnCore.PROGRESSBARWIDTH, VideoPlayerBtnCore.PROGRESSBARHEIGHT);
				//setProgressTo(controlBtn.x / (Capabilities.screenResolutionX -262) * VideoPlayerBtnCore.PROGRESSBARWIDTH);
			} else {
				backgroundBar.graphics.clear();
				backgroundBar.graphics.beginFill(VideoPlayerBtnCore.PROGRESSBARBACKGROUNDCOLOR);
				backgroundBar.graphics.drawRect(0, 0, Capabilities.screenResolutionX - 274, VideoPlayerBtnCore.PROGRESSBARHEIGHT);
				backgroundBar.graphics.endFill();
				backgroundBar.graphics.lineStyle(1, VideoPlayerBtnCore.PROGRESSBARUPBORDERCOLOR);
				backgroundBar.graphics.lineTo(Capabilities.screenResolutionX -274, 0);
				backgroundBar.graphics.moveTo(0, VideoPlayerBtnCore.PROGRESSBARHEIGHT);
				backgroundBar.graphics.lineStyle(1, VideoPlayerBtnCore.PROGRESSBARDOWNBORDERCOLOR);
				backgroundBar.graphics.lineTo(Capabilities.screenResolutionX - 274, VideoPlayerBtnCore.PROGRESSBARHEIGHT);
				//setProgressTo(controlBtn.x / VideoPlayerBtnCore.PROGRESSBARWIDTH * (Capabilities.screenResolutionX - 262));
			}
			
			this.addChild(bufferedBar);
			this.addChild(playedBar);
			this.addChild(controlBtn);
		}
		
		override protected function setEvent():void //progress bar & volumeBtn need to override
		{
			status1.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			status1.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			controlBtn.addEventListener(MouseEvent.MOUSE_DOWN, controlBtnDownHandler);
			this.addEventListener(MouseEvent.CLICK, backgroundClickHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		private function keyDownHandler(e:KeyboardEvent):void 
		{
			var tempTime:Number = controlBtn.x * totalTime / backgroundBar.width;
			switch (e.keyCode) 
			{
				case Keyboard.LEFT:
					tempTime -= 8;
				break;
				case Keyboard.RIGHT:
					tempTime += 8;
				break;
			}
			if (tempTime <0) 
			{
				tempTime = 0;
			} else if (tempTime > totalTime) {
				tempTime = totalTime;
			}
			if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT) {
				setProgressTo(-tempTime);	
			}	
		}
		
		private function backgroundClickHandler(e:MouseEvent):void 
		{
			setProgressTo(e.localX);
		}
		private function controlBtnDownHandler(e:MouseEvent):void 
		{
			controlBtn.startDrag(false, new Rectangle(0, 0, backgroundBar.width, 0));
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			allowedControlBarMove = false;
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			setProgressTo(controlBtn.x);
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			controlBtn.stopDrag();
			allowedControlBarMove = true;
		}
		
		public function updateNewProgress(timePoint:Number):void { //recieve progress
			var tempPos:Number = backgroundBar.width * timePoint / totalTime;
			if (allowedControlBarMove) 
			{
				reflushBars(tempPos);
			}
			
		}
		public function updateNewBuffering(percent:Number):void {
			var xPosOfControlBar:Number;
			xPosOfControlBar = backgroundBar.width * percent;
			reDrawTool(bufferedBar, xPosOfControlBar,VideoPlayerBtnCore.PROGRESSBUFFINGCOLOR);
		}
		public function setProgressTo(xPos:Number):void {//send progress
			
			if (xPos < 0) //timePoint
			{
				//dispatchEvent  -xPos
				dispatchEvent(new VPUIEvent(VPUIEvent.SET_PROGRESS,-xPos));
				reflushBars(-(xPos * backgroundBar.width / totalTime));
			} else { //position point
				dispatchEvent(new VPUIEvent(VPUIEvent.SET_PROGRESS,xPos * totalTime / backgroundBar.width));
				reflushBars(xPos);
			}
			
		}
		
		private function reflushBars(xPosOfControlBar:Number):void {
			if (controlBtn.x != xPosOfControlBar) 
			{
				controlBtn.x = xPosOfControlBar;
			}
			reDrawTool(playedBar, xPosOfControlBar,VideoPlayerBtnCore.PROGRESSPLAYEDCOLOR);
		}
		
		private function reDrawTool(bar:Sprite, xPosOfControlBar:Number = 0,colo:uint = 0xffffff):void 
		{
			bar.graphics.clear();
			bar.graphics.beginFill(colo);
			bar.graphics.drawRect(0, 0, xPosOfControlBar, VideoPlayerBtnCore.PROGRESSBARHEIGHT - 1);
		
			bar.graphics.endFill();	
		}
	}
}
