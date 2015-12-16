package com.readdream.as3.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author fs
	 */
	public class VPUIEvent extends Event 
	{
		public static const SET_VOLUME:String = "set_volume";
		public static const SET_PROGRESS:String = "set_progress";
		public static const FULLSCREENTOGGLE:String = "fullscreentoggle";
		public static const PLAYPAUSETOGGLE:String = "playpausetoggle";
		
		public var value:Object;
		
		public function VPUIEvent(eventType:String,value:Object) 
		{
			super(eventType);
			this.value = value;
		}
		
	}

}