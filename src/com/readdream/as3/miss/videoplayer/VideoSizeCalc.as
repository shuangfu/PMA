package com.readdream.as3.miss.videoplayer 
{
	import flash.media.Video;
	
	/**
	 * ...
	 * @author fs
	 */
	public class VideoCalc 
	{
		
		public function VideoCalc() 
		{
			
		}
		public static function resizeVideo(video:Video,video_width:Number,video_height:Number,stage_width:Number,stage_height:Number):void {
			if ((video_width / video_height) < (stage_width / stage_height)) {
				trace("1");
				video.height = stage_height;
				video.width = (stage_height*video_width)/video_height;
			} else if ((video_width / video_height) > (stage_width / stage_height)) {
				trace("2");
				video.width = stage_width;
				video.height = stage_width*video.height/video.width;
			} else if ((video_width / video_height) == (stage_width / stage_height)) {
				trace("3");
				video.width = stage_width;
				video.height = stage_height;
			}
		}
			public static  function calTime(video_time:Number):String {
			var minute:Number=Math.floor(video_time / 60);
			var min_str:String;
			if (minute >= 10) {
				min_str=String(minute);
			} else {
				min_str="0" + minute;
			}
			var second:Number=Math.round(video_time % 60);
			var sec_str:String;
			if (second >= 10) {
				sec_str=String(second);
			} else {
				sec_str="0" + second;
			}
			return min_str + ":" + sec_str;
		}
	}
}