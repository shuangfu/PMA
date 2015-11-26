package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author fs
	 */
	public class DelayInfoLine extends MovieClip 
	{
		private var _projectID:String;
		
		public function DelayInfoLine(projectID:String) 
		{
			super();
			this._projectID = projectID;
			trace("this is project", this._projectID);
		}
		
		public function get projectID():String 
		{
			return _projectID;
		}
		
		public function set projectID(value:String):void 
		{
			_projectID = value;
		}
		
	}

}