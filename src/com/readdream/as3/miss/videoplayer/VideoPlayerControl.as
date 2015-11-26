package com.readdream.as3.miss.videoplayer 
{
	import adobe.utils.CustomActions;
	import com.readdream.as3.event.VPModelEvent;
	import com.readdream.as3.event.VPUIEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author fs
	 */
	public class VideoPlayerControl 
	{
		private var vpUI:VideoPlayerUI = new VideoPlayerUI();
		private var vpM:VideoPlayerModel = new VideoPlayerModel();
		
		private var metaOnce:Boolean = false;
		private var videoSound:SoundTransform = new SoundTransform(1);
		private var totalTime:Number;
		
		public function VideoPlayerControl() 
		{
			vpM.addEventListener(VPModelEvent.BEGIN_TO_PLAY,videoBeginPlayingHandler);
			vpM.addEventListener(VPModelEvent.GET_META_DATA, receivedMetaDataHandler);
			vpUI.addEventListener(VPUIEvent.SET_PROGRESS, setProgressHandler);
			vpUI.addEventListener(VPUIEvent.PLAYPAUSETOGGLE, playPauseHandler);
			vpUI.addEventListener(VPUIEvent.SET_VOLUME,setVolumeHandler);
		}
		
		private function setVolumeHandler(e:VPUIEvent):void 
		{
			videoSound.volume = Number(e.value);
			vpM.ns.soundTransform = videoSound;
		}
		
		private function playPauseHandler(e:VPUIEvent):void 
		{
			vpM.ns.togglePause();
		}
		
		private function setProgressHandler(e:VPUIEvent):void 
		{
			vpM.getProgressJump(Number(e.value));
		}
		public function showVideo(contaier:DisplayObjectContainer,url:String):void {
			contaier.addChild(vpUI);
			readToPlay(url);
		}
		private function videoBeginPlayingHandler(e:VPModelEvent):void 
		{
			vpUI.vdSmall.attachNetStream(vpM.ns);
			
		}
		
		private function updateVPUIHandler(e:Event):void 
		{
			vpUI.updateProgressBar(vpM.ns.time);
			vpUI.updateTimeLable(VideoCalc.calTime(vpM.ns.time) + " /", VideoCalc.calTime(this.totalTime));
			vpUI.updateNewBuffering(vpM.ns.bytesLoaded/vpM.ns.bytesTotal);
		}
		
		private function receivedMetaDataHandler(e:VPModelEvent):void 
		{
			if (!metaOnce) 
			{
				vpUI.setVideoSize(e.value.width, e.value.height);
				vpUI.adjustVideoSize();
				vpUI.setProgressTotalTime(e.value.duration);	
				this.totalTime = e.value.duration;
				vpUI.addEventListener(Event.ENTER_FRAME,updateVPUIHandler);
			}
			metaOnce = false;
			//
		}
		public function readToPlay(url:String):void {
			vpM.playVideo(url);
		}
		
	}

}