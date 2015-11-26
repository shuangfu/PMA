package 
{
	/**
	 * ...
	 * @author fs
	 */
	public class NewCellVO 
	{
		private var _lable:String;
		private var _projectBelong:String;
		private var _stationBelong:String;
		private var _percent:Number;
		private var _statusFlag:String;
		private var _stageNum:String;

		public function NewCellVO(_lable:String, _projectBelong:String, _stationBelong:String,_stageNum:String = null, _percent:Number = NaN, _statusFlag:String = "TEXT" ) 
		{
			this._lable = _lable;
			this._projectBelong = _projectBelong;
			this._stationBelong = _stationBelong;
			this._stageNum = _stageNum;
			this._percent = _percent;
			this._statusFlag = _statusFlag;
		}
		public function get lable():String 
		{
			return _lable;
		}
		
		public function set lable(value:String):void 
		{
			_lable = value;
		}
		
		public function get projectBelong():String 
		{
			return _projectBelong;
		}
		
		public function set projectBelong(value:String):void 
		{
			_projectBelong = value;
		}
		
		public function get stationBelong():String 
		{
			return _stationBelong;
		}
		
		public function set stationBelong(value:String):void 
		{
			_stationBelong = value;
		}
		
		public function get percent():Number 
		{
			return _percent;
		}
		
		public function set percent(value:Number):void 
		{
			_percent = value;
		}
		
		public function get statusFlag():String 
		{
			return _statusFlag;
		}
		
		public function set statusFlag(value:String):void 
		{
			_statusFlag = value;
		}
		
		public function get stageNum():String 
		{
			return _stageNum;
		}
		
		public function set stageNum(value:String):void 
		{
			_stageNum = value;
		}
	}

}