package 
{
	/**
	 * ...
	 * @author fs
	 */
	public class StationVO
	{
		private var _stationName : String;
		private var _bluePrintNum : Number;
		private var _dutyMan:String;
		private var _startPoint:String;
		private var _stageArr:Array;
		private var _stationNum:String;
		private var _stageID:String;
		
		public function StationVO(_stationNum:String,_stationName:String, _bluePrintNum : Number,  _dutyMan:String, _startPoint:String, _stageArr:Array) 
		{
			this._stationNum = _stationNum;
			this._stationName = _stationName;
			this._bluePrintNum = _bluePrintNum;
			this._dutyMan = _dutyMan;
			this._startPoint = _startPoint;
			this._stageArr = _stageArr;
		}
		
		public function get stageArr():Array 
		{
			return _stageArr;
		}
		
		public function set stageArr(value:Array):void 
		{
			_stageArr = value;
		}
		
		public function get startPoint():String 
		{
			return _startPoint;
		}
		
		public function set startPoint(value:String):void 
		{
			_startPoint = value;
		}
		
		public function get DutyMan():String 
		{
			return _dutyMan;
		}
		
		public function set DutyMan(value:String):void 
		{
			_dutyMan = value;
		}
		
		public function get bluePrintNum():Number 
		{
			return _bluePrintNum;
		}
		
		public function set bluePrintNum(value:Number):void 
		{
			_bluePrintNum = value;
		}
		
		public function get stationName():String 
		{
			return _stationName;
		}
		
		public function set stationName(value:String):void 
		{
			_stationName = value;
		}
		
		
		public function get stationNum():String 
		{
			return _stationNum;
		}
		
		public function set stationNum(value:String):void 
		{
			_stationNum = value;
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