package 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author fs
	 */
	public class DispatchVO extends EventDispatcher 
	{
		public var dataObj:Object;
		public function DispatchVO(target:flash.events.IEventDispatcher=null) 
		{
			this.dataObj = new Object();
			super(target);
			
		}
		
	}

}