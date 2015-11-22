package 
{
	/**
	 * ...
	 * @author fs
	 */
	public class Station 
	{
		private var _stationName : String;
		private var _bluePrintNum : Number;
		private var _dutyMan:String;
		private var _startPoint:Date;
		private var _stageArr:Array;
		
		public function Station(_stationName : String, _bluePrintNum : Number,  _dutyMan:String, _startPoint:Date, _stageArr:Array) 
		{
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
		
		public function get startPoint():Date 
		{
			return _startPoint;
		}
		
		public function set startPoint(value:Date):void 
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
		
	}

}