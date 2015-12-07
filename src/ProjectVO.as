package 
{
	/**
	 * ...
	 * @author fs
	 */
	public class ProjectVO 
	{
		private var _projectName:String;
		private var _stationArr:Array;
		
		public function ProjectVO(_projectName:String,_stationArr:Array) 
		{
			this._projectName = _projectName;
			this._stationArr = _stationArr;
		}

		
		public function get stationArr():Array 
		{
			return _stationArr;
		}
		
		public function set stationArr(value:Array):void 
		{
			_stationArr = value;
		}
		
		
		
		public function get projectName():String 
		{
			return _projectName;
		}
		
		public function set projectName(value:String):void 
		{
			_projectName = value;
		}
		
	}

}