package com.readdream.as3.miss.videoplayer
{
	import com.readdream.as3.event.VPModelEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author fs
	 */
	public class VideoPlayerModel extends EventDispatcher
	{
		public var ns:NetStream;
		private var nc:NetConnection;
		private var videoURL:String;
		
		public function VideoPlayerModel()
		{
			nc = new NetConnection();
			
			nc.connect(null);
			ns = new NetStream(nc);
			ns.client = this;
			
			ns.checkPolicyFile = true;
			
			nc.addEventListener(NetStatusEvent.NET_STATUS,streamnotfound);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netmistake);
			nc.addEventListener(IOErrorEvent.NETWORK_ERROR,ioErrorHandler);
			ns.addEventListener(IOErrorEvent.NETWORK_ERROR,ioErrorHandler);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,netmistake);
			ns.addEventListener(NetStatusEvent.NET_STATUS,streamnotfound);

		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace("IO error");
		}
		private function netmistake(evt:AsyncErrorEvent):void {
			trace("异步错误");
		}
		private function streamnotfound(evt:NetStatusEvent):void {
			switch (evt.info.code) {
				case "NetStream.Play.Stop" :
					
					break;
				case "NetStream.Play.Start" :
					trace("视频开始播放");
					dispatchEvent(new VPModelEvent(VPModelEvent.BEGIN_TO_PLAY));
					break;
				case "NetStream.Buffer.Empty" :
					trace("数据的接收速度不足以填充缓冲区。");
					break;
				case "NetStream.Buffer.Full" :
					trace("缓冲区已满并且流将开始播放。");
					break;
				case "NetStream.Buffer.Flush" :
					trace("数据已完成流式处理，剩余的缓冲区将被清空。");
					break;
				case "NetStream.Seek.Notify" :
					trace("搜寻操作完成。");
				case "NetStream.Seek.InvalidTime":
					ns.seek(evt.info.details);
					break;
			}
		}
		
		public function onMetaData(infoObject:Object):void
		{
			trace("metadata");
			dispatchEvent(new VPModelEvent(VPModelEvent.GET_META_DATA,infoObject));
		}
		
		public function onCuePoint(infoObject:Object):void
		{
			trace("cue point");
		}
		public function onXMPData(infoObject:Object):void
		{
			trace("XMPData point");
		}
		public function playVideo(url:String):void {
			videoURL = url;
			ns.play(url);
		}
		public function getProgressJump(timePoint:Number):void
		{
			ns.seek(timePoint);
		}
		
		public function getToPlay():void
		{
		
		}
		
		public function getVolumeAdjusted():void
		{
		
		}
		
		public function getToStop():void
		{
		
		}
		
		public function metaDataHasArrived():void
		{
		
		}
		
		public function streamIsBuffering():void
		{
		
		}
		
		public function streamIsPlaying():void
		{
		
		}
		
		public function connctionHasSuccessed():void
		{
		
		}
	}

}
