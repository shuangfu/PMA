package 
{
	/**
	 * ...
	 * @author fs
	 */
	public class ProjectVO 
	{
		private var _projectName:String;
		private var _projectCode:String;
		private var _projectDutyMan:String;
		private var _stationArr:Array;
		private var _tableHeadArr:Array;
		
		public function ProjectVO(_projectName:String, _projectCode:String, _projectDutyMan:String,  _stationArr:Array, _tableHeadArr:Array) 
		{
			this._projectName = _projectName;
			this._projectCode = _projectCode;
			this._projectDutyMan = _projectDutyMan;
			this._stationArr = _stationArr;
			this._tableHeadArr = _tableHeadArr;
		}
		
		public function get tableHeadArr():Array 
		{
			return _tableHeadArr;
		}
		
		public function set tableHeadArr(value:Array):void 
		{
			_tableHeadArr = value;
		}
		
		public function get stationArr():Array 
		{
			return _stationArr;
		}
		
		public function set stationArr(value:Array):void 
		{
			_stationArr = value;
		}
		
		public function get projectDutyMan():String 
		{
			return _projectDutyMan;
		}
		
		public function set projectDutyMan(value:String):void 
		{
			_projectDutyMan = value;
		}
		
		public function get projectCode():String 
		{
			return _projectCode;
		}
		
		public function set projectCode(value:String):void 
		{
			_projectCode = value;
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