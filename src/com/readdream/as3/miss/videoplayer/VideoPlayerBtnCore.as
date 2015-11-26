package com.readdream.as3.miss.videoplayer
{
	import com.greensock.TweenMax;
	import com.readdream.as3.robot.Robot_PicLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author fs
	 */
	public class VideoPlayerBtnCore extends Sprite
	{
		public var toggleFlag:Boolean = true;
		protected var initStatus:Boolean;
		protected var status1:Robot_PicLoader;
		protected var status2:Robot_PicLoader;
		protected var status1AssetURL:String;
		protected var status2AssetURL:String;
		protected var freezeToggle:Boolean = false;
		
		public static const BACKGROUNDCOLOR:uint = 0x3B3B3B;
		public static const BACKGROUNDUPBORDERCOLOR:uint = 0x646464;
		//public var backgroundDownBoaderColor:uint;
		public static const PROGRESSPLAYEDCOLOR:uint = 0xCE2B1B;
		public static const PROGRESSBUFFINGCOLOR:uint = 0xC0C0C0;
		public static const PROGRESSBARBACKGROUNDCOLOR:uint = 0x808080;
		public static const PROGRESSBARUPBORDERCOLOR:uint = 0x303030;
		public static const PROGRESSBARDOWNBORDERCOLOR:uint = 0x666666;

		public static const PROGRESSBARWIDTH:Number = 368;
		public static const PROGRESSBARHEIGHT:Number = 7;
		
		public function VideoPlayerBtnCore(status1AssetURL:String, status2AssetURL:String = null, initStatus:Boolean = true)
		{
			this.initStatus = initStatus;
			this.status1AssetURL = status1AssetURL;
			this.status2AssetURL = status2AssetURL;
			if (!initStatus)
			{
				toggleFlag = !toggleFlag;
			}
			loadAssets();
			setupUI();
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		protected function setupUI():void //override by volumeBtn and progressBar and bigPlayBtn
		{
		
		}
		
		protected function addToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			setCursor();
			setEvent();
		}
		
		protected function setEvent():void //progress bar & volumeBtn need to override
		{
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.addEventListener(MouseEvent.CLICK, clickHandler,false,100);
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			//e.stopPropagation();
			toggleStatus();
		}
		
		protected function rollOverHandler(e:MouseEvent):void
		{
			TweenMax.to(e.target, 0.3, {glowFilter: {color: 0xffffff, alpha: 0.7, blurX: 3.5, blurY: 3.5, strength: 3.5}});
		}
		
		protected function rollOutHandler(e:MouseEvent):void
		{
			TweenMax.to(e.target, 0.3, {glowFilter: {color: 0xffffff, alpha: 0.7, blurX: 0, blurY: 0, strength: 0}});
		}
		
		protected function removeFromStageHandler(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			//removeEvent();
		}
		
		protected function removeEvent():void //progress bar & volumeBtn need to override
		{
			this.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			this.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function loadAssets():void
		{
			if (status1AssetURL != null)
			{
				status1 = new Robot_PicLoader(status1AssetURL);
			}
			if (status2AssetURL != null)
			{
				status2 = new Robot_PicLoader(status2AssetURL);
			}
			if (initStatus)
			{
				if (status1 != null)
				{
					addChild(status1);
				}
				
			}
			else
			{
				if (status2 != null)
				{
					addChild(status2);
				}
			}
		}
		
		public function toggleStatus():void//ove
		{
			toggleFlag = !toggleFlag;
			trace("fullscreen: " + toggleFlag);
			if (!toggleFlag)
			{
				if (status1 != null)
				{
					removeChild(status1);
				}
				if (status2 != null)
				{
					addChild(status2);
				}
				
			}
			else
			{
				if (status2 != null)
				{
					removeChild(status2);
				}
				if (status1 != null)
				{
					addChild(status1);
				}
				
			}
			
		}
		
		public function setCursor(hasCursor:Boolean = true):void
		{ //volume button need to override
			this.buttonMode = hasCursor;
		}
	}

}