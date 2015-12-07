package 
{
	/**
	 * ...
	 * @author fs
	 */
	public class NewCellVO 
	{
		private var _lable:String;
		private var _stageID:String;
		private var _percent:String;
		private var _statusFlag:String;

		public function NewCellVO(_lable:String, _stageID:String = "", _percent:String = "溢出", _statusFlag:String = "TEXT" ) 
		{
			this._lable = _lable;
			this._stageID = _stageID;
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
		

		
		public function get percent():String 
		{
			return _percent;
		}
		
		public function set percent(value:String):void 
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
		
		public function get stageID():String 
		{
			return _stageID;
		}
		
		public function set stageID(value:String):void 
		{
			_stageID = value;
		}
		
	}

}