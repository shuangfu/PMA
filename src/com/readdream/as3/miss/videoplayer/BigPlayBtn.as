package com.readdream.as3.miss.videoplayer 
{
	import com.readdream.as3.robot.Robot_MatchThumbFactory;
	import com.readdream.as3.robot.Robot_PicLoader;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author fs
	 */
	public class BigPlayBtn extends VideoPlayerBtnCore 
	{
		private var background:Robot_PicLoader;
		public function BigPlayBtn(status1AssetURL:String,status2AssetURL:String = null,initStatus:Boolean = true)
		{
			super(status1AssetURL,status2AssetURL,initStatus);
		}
		override protected function setupUI():void {
			background = new Robot_PicLoader("assets/mediaplayerUI/playBackground.png");
			status1.addChildAt(background,0);
			background.x = -25;
			background.y = -25;
			
		}
		override protected function setEvent():void //progress bar & volumeBtn need to override
		{
			status1.getChildAt(1).addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			status1.getChildAt(1).addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			status1.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
	}

}