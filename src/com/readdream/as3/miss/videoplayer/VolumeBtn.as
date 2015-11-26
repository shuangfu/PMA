package com.readdream.as3.miss.videoplayer
{
	import com.readdream.as3.event.VPUIEvent;
	import com.readdream.as3.robot.Robot_PicLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author fs
	 */
	public class VolumeBtn extends VideoPlayerBtnCore
	{
		private var backgroundContainer:Sprite;
		private var controlBtn:Robot_PicLoader;
		private var volumeUpLine:Sprite;
		private var volumeDownLine:Sprite;
		
		private var theTimer:Timer;
		private var backgroundShowingUpFlag:Boolean = false;
		
		private var memoryOfVolume:Number = 10;
		
		public function VolumeBtn(status1AssetURL:String, status2AssetURL:String = null, initStatus:Boolean = true)
		{
			super(status1AssetURL, status2AssetURL, initStatus);
		}
		
		override protected function setupUI():void
		{
			backgroundContainer = new Sprite();
			backgroundContainer.graphics.beginFill(VideoPlayerBtnCore.BACKGROUNDCOLOR);
			backgroundContainer.graphics.drawRect(0, 0, 40, 113);
			backgroundContainer.graphics.endFill();
			backgroundContainer.graphics.lineStyle(1, VideoPlayerBtnCore.BACKGROUNDUPBORDERCOLOR);
			backgroundContainer.graphics.lineTo(40, 0);
			backgroundContainer.graphics.lineTo(40, 113);
			backgroundContainer.graphics.moveTo(0, 113);
			backgroundContainer.graphics.lineTo(0, 0);
			controlBtn = new Robot_PicLoader("assets/mediaplayerUI/volumeControlBtn.png");
			controlBtn.x = 13;
			controlBtn.y = 10;
			controlBtn.buttonMode = true;
			volumeUpLine = new Sprite();
			volumeUpLine.graphics.beginFill(VideoPlayerBtnCore.PROGRESSBUFFINGCOLOR);
			volumeUpLine.graphics.drawRect(0, 0, 5, 70);
			volumeUpLine.graphics.endFill();
			volumeUpLine.x = 17;
			volumeUpLine.y = 10;
			volumeDownLine = new Sprite();
			volumeDownLine.graphics.beginFill(VideoPlayerBtnCore.PROGRESSPLAYEDCOLOR);
			volumeDownLine.graphics.drawRect(0, 0, 5, 70);
			volumeDownLine.graphics.endFill();
			volumeDownLine.x = 17;
			volumeDownLine.y = 10;
			backgroundContainer.addChild(volumeUpLine);
			backgroundContainer.addChild(volumeDownLine);
			backgroundContainer.addChild(controlBtn);
			backgroundContainer.x = -10;
			backgroundContainer.y = -14 - (113 - 40);
		}
		
		override protected function setEvent():void //progress bar & volumeBtn need to override
		{
			status1.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler1);
			status2.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler1);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler1);
			
			status1.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			status2.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			status1.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			status2.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			status1.addEventListener(MouseEvent.CLICK, clickHandler1);
			status2.addEventListener(MouseEvent.CLICK, clickHandler1);
			
			controlBtn.addEventListener(MouseEvent.MOUSE_DOWN, controlBtnDownHandler);
			
			backgroundContainer.addEventListener(MouseEvent.CLICK, backgroundClickHandler);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			theTimer = new Timer(800, 1);
			theTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timeCompleteHandler);
		}
		
		private function clickHandler1(e:MouseEvent):void
		{
			if (!toggleFlag)
			{
				memoryOfVolume = controlBtn.y;
				setVolumeTo(74);
			}
			else
			{
				setVolumeTo(memoryOfVolume);
			}
		
		}
		
		private function timeCompleteHandler(e:TimerEvent):void
		{
			rollOutHandler1(null);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			var tempPos:Number = controlBtn.y;
			switch (e.keyCode)
			{
				case Keyboard.UP: 
					tempPos -= 8;
					if (!backgroundShowingUpFlag)
					{
						rollOverHandler1(null);
					}
					theTimer.reset();
					theTimer.start();
					break;
				case Keyboard.DOWN: 
					tempPos += 8;
					if (!backgroundShowingUpFlag)
					{
						rollOverHandler1(null);
					}
					theTimer.reset();
					theTimer.start();
					break;
			}
			if (tempPos < 10)
			{
				tempPos = 10;
			}
			else if (tempPos > 74)
			{
				tempPos = 74;
			}
			setVolumeTo(tempPos);
		}
		
		private function backgroundClickHandler(e:MouseEvent):void
		{
			if (e.target != e.currentTarget)
			{
				return;
			}
			var yPositon:Number;
			if (e.localY < 10)
			{
				yPositon = 10;
			}
			else if (e.localY > 74)
			{
				yPositon = 74;
			}
			else
			{
				yPositon = e.localY;
			}
			setVolumeTo(yPositon);
		}
		
		private function setVolumeTo(yPos:Number):void
		{
			if (controlBtn.y != yPos)
			{
				controlBtn.y = yPos;
			}
			volumeUpLine.graphics.clear();
			volumeUpLine.graphics.beginFill(VideoPlayerBtnCore.PROGRESSBUFFINGCOLOR);
			volumeUpLine.graphics.drawRect(0, 0, 5, yPos - 10);
			volumeUpLine.graphics.endFill();
			volumeDownLine.graphics.clear();
			volumeDownLine.graphics.beginFill(VideoPlayerBtnCore.PROGRESSPLAYEDCOLOR);
			volumeDownLine.graphics.drawRect(0, 0, 5, 80 - yPos);
			volumeDownLine.graphics.endFill();
			volumeDownLine.y = yPos;
			if (toggleFlag && (yPos < 74))
			{
				toggleStatus();
			}
			else if (!toggleFlag && (yPos == 74))
			{
				toggleStatus();
			}
			dispatchEvent(new VPUIEvent(VPUIEvent.SET_VOLUME,(74 - yPos) / 64));
		}
		
		private function controlBtnDownHandler(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler1);
			controlBtn.startDrag(false, new Rectangle(13, 10, 0, 64));
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseMoveHandler(e:MouseEvent):void
		{
			setVolumeTo(controlBtn.y);
		}
		
		private function mouseUpHandler(e:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			controlBtn.stopDrag();
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler1);
			if (!this.backgroundContainer.hitTestPoint(e.stageX, e.stageY))
			{
				rollOutHandler1(null);
			}
		}
		
		private function rollOverHandler1(e:MouseEvent):void
		{
			backgroundShowingUpFlag = true;
			this.addChildAt(backgroundContainer, 0);
		}
		
		private function rollOutHandler1(e:MouseEvent):void
		{
			trace("fuck");
			backgroundShowingUpFlag = false;
			if (backgroundContainer.stage != null)
			{
				this.removeChild(backgroundContainer);
			}
		}
		
		override public function setCursor(hasCursor:Boolean = true):void
		{ //volume button need to override
			status1.buttonMode = hasCursor;
			status2.buttonMode = hasCursor;
		}
	}

}
