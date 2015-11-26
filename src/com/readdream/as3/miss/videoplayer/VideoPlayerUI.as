package com.readdream.as3.miss.videoplayer
{
	import com.greensock.TweenMax;
	import com.readdream.as3.event.VPUIEvent;
	import com.readdream.as3.mr.Mr_Lable;
	import com.readdream.as3.mr.Mr_Layouter;
	import com.readdream.as3.robot.Robot_TextFormater;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author fs
	 */
	public class VideoPlayerUI extends Sprite
	{
		private var playerWidth:Number = 640;
		private var playerHeight:Number = 400;
		
		private var playPauseBtn:PlayPauseBtn;
		private var progressBar:ProgressBar;
		private var currentTimeTF:TextField;
		private var totalTimeTF:TextField;
		private var volumeBtn:VolumeBtn;
		private var maskScreenBtn:MaskScreenBtn;
		private var fullScreenBtn:FullScreenBtn;
		private var backgroundBlack:Sprite;
		private var eventSprite:Sprite;
		private var controlBar:Sprite;
		
		private var bigPlayBtn:BigPlayBtn;
		
		private var isScreenMaskedFlag:Boolean = false;
		private var isBufferingFlay:Boolean;
		private var isFreezingFlay:Boolean;
		private var isKeyboardAvailable:Boolean;
		private var videoW:Number;
		private var videoH:Number;
		private var videoSizeInit:Boolean = false;
		
		public var vdSmall:Video;
		public var vdBig:Video;
		private var theTimer:Timer;
		private var doubleClickFlag:Boolean = false;
		
		public function VideoPlayerUI()
		{
			playPauseBtn = new PlayPauseBtn("assets/mediaplayerUI/playBtnIcon.png", "assets/mediaplayerUI/pauseBtnIcon.png", false);
			progressBar = new ProgressBar("assets/mediaplayerUI/progressBtnIcon.png", null);
			volumeBtn = new VolumeBtn("assets/mediaplayerUI/muteBtnIcon.png", "assets/mediaplayerUI/volumeBtnIcon.png", false);
			maskScreenBtn = new MaskScreenBtn("assets/mediaplayerUI/screenOffBtnIcon.png", "assets/mediaplayerUI/screenOnBtnIcon.png");
			fullScreenBtn = new FullScreenBtn("assets/mediaplayerUI/normalScreenBtnIcon.png", "assets/mediaplayerUI/fullScreenBtnIcon.png", false);
			bigPlayBtn = new BigPlayBtn("assets/mediaplayerUI/bigPlay.png", null, false);
			currentTimeTF = Mr_Lable.getLable("00:00 / ", Robot_TextFormater.getTextFormat(Robot_TextFormater.VIDEOPLAYER_TIME));
			totalTimeTF = Mr_Lable.getLable("00:00",Robot_TextFormater.getTextFormat(Robot_TextFormater.VIDEOPLAYER_TIME));
			controlBar = new Sprite();
			vdSmall = new Video(640, 360);
			backgroundBlack = new Sprite();
			eventSprite = new Sprite();
			run();
		}
		
		private function run():void
		{
			this.addChild(vdSmall);
			setupUI();
			setupEvent();
		}
		
		private function setupEvent():void
		{
			fullScreenBtn.addEventListener(MouseEvent.CLICK, fullScreenToggle);
			maskScreenBtn.addEventListener(MouseEvent.CLICK, maskScreen);
			volumeBtn.addEventListener(VPUIEvent.SET_VOLUME, adjustVolume);
			progressBar.addEventListener(VPUIEvent.SET_PROGRESS, adjustProgress);
			playPauseBtn.addEventListener(MouseEvent.CLICK, togglePlayPauseHandler);
			bigPlayBtn.addEventListener(MouseEvent.CLICK, togglePlayPauseHandler);
			
			eventSprite.doubleClickEnabled = true;
			eventSprite.buttonMode = true;
			eventSprite.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler,false,100);
			eventSprite.addEventListener(MouseEvent.CLICK,firstClick);
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
		}
		
		private function fullScreenHandler(e:FullScreenEvent):void 
		{
			//fullScreenBtn.toggleStatus();
			if (e.fullScreen) 
			{
					
			} else {
				if (fullScreenBtn.toggleFlag) 
				{
					fullScreenBtn.toggleStatus();
				}
			}
			buildUI();
			adjustVideoSize();
		}
		
		private function addToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
			this.stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenHandler);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				togglePlayPauseHandler(null);
			}
			else if ((e.keyCode == Keyboard.ENTER) && (e.shiftKey == true))
			{
				fullScreenBtn.toggleStatus()
				fullScreenToggle(null);
			}
		}
		
		private function doubleClickHandler(e:MouseEvent):void
		{
			doubleClickFlag = true;
		}
		private function firstClick(e:MouseEvent):void{
			doubleClickFlag = false;
			var clickGap:Timer = new Timer(260, 1);
			eventSprite.removeEventListener(MouseEvent.CLICK, firstClick);
			clickGap.addEventListener(TimerEvent.TIMER_COMPLETE,decideDoubleOrClick);
			clickGap.start();
		}
		
		private function decideDoubleOrClick(e:TimerEvent):void 
		{
			if (doubleClickFlag) 
			{
				fullScreenBtn.toggleStatus();
				fullScreenToggle(null);
			} else {
				togglePlayPauseHandler(null);	
			}
			eventSprite.addEventListener(MouseEvent.CLICK,firstClick);
		}
		private function togglePlayPauseHandler(e:MouseEvent):void
		{
			if (e == null)
			{
				playPauseBtn.toggleStatus();
				bigPlayBtn.toggleStatus();
			}
			else
			{
				if (e.currentTarget == bigPlayBtn)
				{
					trace("enen");
					playPauseBtn.toggleStatus();
				}
				else
				{
					trace("21221");
					bigPlayBtn.toggleStatus();
				}
			}
			dispatchEvent(new VPUIEvent(VPUIEvent.PLAYPAUSETOGGLE, null));
		}
		
		public function setupUI():void
		{
			buildUI(); //true:normal false:FullScreen
		}
		
		private function buildUI():void
		{
			trace("buildUI for fullscreen:" + fullScreenBtn.toggleFlag);
			controlBar.graphics.clear();
			controlBar.graphics.beginFill(VideoPlayerBtnCore.BACKGROUNDCOLOR);
			backgroundBlack.graphics.clear();
			backgroundBlack.graphics.beginFill(0x000000);
			eventSprite.graphics.clear();
			eventSprite.graphics.beginFill(0xff0000, 0);
			if (!fullScreenBtn.toggleFlag)
			{
				controlBar.graphics.drawRect(0, 0, 640, 40);
				backgroundBlack.graphics.drawRect(0, 0, 640, 400);
				eventSprite.graphics.drawRect(0, 0, 640, 360);
			}
			else
			{
				controlBar.graphics.drawRect(0, 0, Capabilities.screenResolutionX, 40);
				backgroundBlack.graphics.drawRect(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
				eventSprite.graphics.drawRect(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY - 40);
			}
			controlBar.graphics.endFill();
			backgroundBlack.graphics.endFill();
			eventSprite.graphics.endFill();
			
			controlBar.graphics.lineStyle(1, VideoPlayerBtnCore.BACKGROUNDUPBORDERCOLOR);
			if (!fullScreenBtn.toggleFlag)
			{
				controlBar.graphics.lineTo(640, 0);
			}
			else
			{
				controlBar.graphics.lineTo(Capabilities.screenResolutionX, 0);
			}
			var objArr:Array = new Array();
			if (!fullScreenBtn.toggleFlag)
			{
				objArr.push({stuff: playPauseBtn, xPos: 22, yPos: 13});
				objArr.push({stuff: progressBar, xPos: 57, yPos: 13.5});
				objArr.push({stuff:currentTimeTF,xPos:640-205,yPos:12});
				objArr.push({stuff:totalTimeTF,xPos:640-164,yPos:12});
				objArr.push({stuff: volumeBtn, xPos: 538, yPos: 14});
				objArr.push({stuff: maskScreenBtn, xPos: 575, yPos: 13});
				objArr.push({stuff: fullScreenBtn, xPos: 600, yPos: 13});
			}
			else
			{
				//full screen position
				objArr.push({stuff: playPauseBtn, xPos: 22, yPos: 13});
				objArr.push({stuff: progressBar, xPos: 57, yPos: 13.5});
				objArr.push({stuff:currentTimeTF,xPos:Capabilities.screenResolutionX - 205,yPos:12});
				objArr.push({stuff:totalTimeTF,xPos:Capabilities.screenResolutionX - 164,yPos:12});
				objArr.push({stuff: volumeBtn, xPos: Capabilities.screenResolutionX - 102, yPos: 14});
				objArr.push({stuff: maskScreenBtn, xPos: Capabilities.screenResolutionX - 65, yPos: 13});
				objArr.push({stuff: fullScreenBtn, xPos: Capabilities.screenResolutionX - 40, yPos: 13});
			}
			Mr_Layouter.layouter(controlBar, objArr);
			this.addChildAt(backgroundBlack, 0);
			this.addChild(eventSprite);
			this.addChild(controlBar);
			controlBar.x = 0;
			if (!fullScreenBtn.toggleFlag)
			{
				
				controlBar.y = 360;
				TweenMax.to(controlBar, 0.3, {y: 360, overwrite: 1});
				if (this.hasEventListener(KeyboardEvent.KEY_DOWN))
				{
					trace("rsrsrsrsrsrsrsa");
					this.removeEventListener(KeyboardEvent.KEY_DOWN, showHidedControlBar);
				}
				if (theTimer != null)
				{
					
					if (theTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
					{
						trace("rsrsrsrsrsrsrsa");
						theTimer.stop();
						theTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, controlBarGoBack);
						
					}
				}
				if (this.hasEventListener(MouseEvent.MOUSE_MOVE)) 
				{
					this.removeEventListener(MouseEvent.MOUSE_MOVE,getControlBarUP);
				}
				
			}
			else
			{
				trace("not here");
				controlBar.y = Capabilities.screenResolutionY - 40;
				theTimer = new Timer(1600, 1);
				TweenMax.to(controlBar, 0.3, {y: Capabilities.screenResolutionY, delay: 2, onComplete: hidedControlBar, overwrite: 1});
			}
			progressBar.toggleFullScreen(fullScreenBtn.toggleFlag);

			if (fullScreenBtn.toggleFlag)
			{
				bigPlayBtn.scaleX = 2;
				bigPlayBtn.scaleY = 2;
				bigPlayBtn.x = (Capabilities.screenResolutionX - 30) / 2;
				bigPlayBtn.y = (Capabilities.screenResolutionY - 30 - 40) / 2;
			}
			else
			{
				bigPlayBtn.scaleX = 1;
				bigPlayBtn.scaleY = 1;
				bigPlayBtn.x = (640 - 30) / 2;
				bigPlayBtn.y = (360 - 30) / 2;
			}
			this.addChild(bigPlayBtn);
		}
		
		private function hidedControlBar():void
		{
			trace("fuck here");
			this.addEventListener(KeyboardEvent.KEY_DOWN, showHidedControlBar);
			this.addEventListener(MouseEvent.MOUSE_MOVE,getControlBarUP);
			theTimer.addEventListener(TimerEvent.TIMER_COMPLETE, controlBarGoBack);
		}
		
		private function controlBarGoBack(e:TimerEvent):void
		{
			trace("it's you");
			TweenMax.to(controlBar, 0.3, {y: Capabilities.screenResolutionY, overwrite: 1});
		}
		
		private function showHidedControlBar(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.SPACE: 
				case Keyboard.RIGHT: 
				case Keyboard.LEFT: 
				case Keyboard.UP: 
				case Keyboard.DOWN: 
					trace("it's me");
					getControlBarUP(null);
			}
		}
		
		private function getControlBarUP(e:MouseEvent):void 
		{
			TweenMax.to(controlBar, 0.3, {y: Capabilities.screenResolutionY - 40, overwrite: 1});
			theTimer.reset();
			theTimer.start();
		}
		
		public function fullScreenToggle(e:MouseEvent):void
		{
			if (fullScreenBtn.toggleFlag)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function adjustVolume(e:VPUIEvent):void
		{
			dispatchEvent(new VPUIEvent(VPUIEvent.SET_VOLUME, e.value));
		}
		public function setVideoSize(vw:Number, vh:Number):void {
			videoW = vw;
			videoH = vh;
		}
		public function maskScreen(e:MouseEvent):void
		{
			if (!isScreenMaskedFlag)
			{
				intoScreenMaskMode();
			}
			else
			{
				intoScreenNormalMode();
			}
			isScreenMaskedFlag = !isScreenMaskedFlag;
		}
		
		public function adjustProgress(e:VPUIEvent):void
		{
			dispatchEvent(new VPUIEvent(VPUIEvent.SET_PROGRESS, e.value));
		}
		
		public function adjustVideoSize():void
		{
			//if (!videoSizeInit)
			//{
				
				//videoSizeInit = true;
				//VideoSizeCalc.resizeVideo(vdSmall, vw, vh, 640, 360);
				//vdSmall.x = (640 - vdSmall.width) / 2;
				//vdSmall.y = (360 - vdSmall.height) / 2;
			//}
			//else
			if (!fullScreenBtn.toggleFlag)
			{
				trace(".............");
				VideoCalc.resizeVideo(vdSmall, videoW, videoH, 640, 360);
				vdSmall.x = (640 - vdSmall.width) / 2;
				vdSmall.y = (360 - vdSmall.height) / 2;
			}
			else
			{
				trace("full screen");
				VideoCalc.resizeVideo(vdSmall, videoW, videoH, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
				trace(Capabilities.screenResolutionX);
				vdSmall.x = (Capabilities.screenResolutionX - vdSmall.width) / 2;
				vdSmall.y = (Capabilities.screenResolutionY - vdSmall.height) / 2;
			}
		}
		
		public function intoBufferMode():void
		{
			
		}
		
		public function setProgressTotalTime(totalTime:Number):void
		{
			progressBar.setTotalTime(totalTime);
		}
		
		public function updateProgressBar(timePoint:Number):void
		{
			progressBar.updateNewProgress(timePoint);
		}
		
		public function updateTimeLable(currentTime:String="00:00/",totalTime:String="10:00"):void
		{
			this.currentTimeTF.text = currentTime;
			this.totalTimeTF.text = totalTime;
		}
		
		public function intoFreezeMode():void
		{
		
		}
		
		public function intoScreenMaskMode():void
		{
			vdSmall.alpha = 0.2;
		}
		
		public function intoScreenNormalMode():void
		{
			vdSmall.alpha = 1;
		}
		public function updateNewBuffering(percent:Number):void {
			progressBar.updateNewBuffering(percent);
		}
		public function activateKeyboard():void
		{
		
		}
		
		public function freezeKeyboard():void
		{
		
		}
	}
}
