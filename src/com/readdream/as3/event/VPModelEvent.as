package com.readdream.as3.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author fs
	 */
	public class VPModelEvent extends Event 
	{
		public static const GET_META_DATA:String = "get_meta_data";
		public static const BEGIN_TO_PLAY:String = "begin_to_play";

		public var value:Object;
		public function VPModelEvent(eventType:String,value:Object = null) 
		{
			super(eventType);
			this.value = value;
		}
		
	}

}