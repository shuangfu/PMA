package 
{
	import adobe.utils.CustomActions;
	/**
	 * ...
	 * @author fs
	 */
	public class CellVO 
	{
		private	var _endDate:Date;
		private var _nowDate:Date;
		private var _startDate:Date;
		private var _comletedDate:Date;
		
		private var _dueTime:Number;
		private var _leftTime:Number;
		private var _status:String;
		
		private var _lable:String;
		
		private var _color:Number;
		
		public function CellVO(_lable:String = null, _endDate:Date = null, _nowDate:Date = null, _startDate:Date = null, _comletedDate:Date = null, _status:String = "COMPLETED") 
		{
			this._lable = _lable;
			this._endDate = _endDate;
			this._nowDate = _nowDate;
			this._startDate = _startDate;
			this._comletedDate = _comletedDate;
			this._status = _status;
		}
		
		public static function getDateString(someDateObj:Date):Array {
			var tempArr:Array = new Array();
			tempArr[0] = (someDateObj.getFullYear()).toString();
			tempArr[1] = (int(someDateObj.getMonth()) + 1).toString();
			tempArr[2] = someDateObj.getDate().toString();
			trace("Str:",tempArr[0],tempArr[1],tempArr[2])
			return tempArr;
		}
		
		public function get endDate():Date 
		{
			return _endDate;
		}
		
		public function set endDate(value:Date):void 
		{
			_endDate = value;
		}
		
		public function get nowDate():Date 
		{
			return _nowDate;
		}
		
		public function set nowDate(value:Date):void 
		{
			_nowDate = value;
		}
		
		public function get color():Number 
		{
			return _color;
		}
		
		public function set color(value:Number):void 
		{
			_color = value;
		}
		
		public function get startDate():Date 
		{
			return _startDate;
		}
		
		public function set startDate(value:Date):void 
		{
			_startDate = value;
		}
		
		public function get dueTime():Number 
		{
			return _dueTime;
		}
		
		public function set dueTime(value:Number):void 
		{
			_dueTime = value;
		}
		
		public function get leftTime():Number 
		{
			return _leftTime;
		}
		
		public function set leftTime(value:Number):void 
		{
			_leftTime = value;
		}
		
		public function get comletedDate():Date 
		{
			return _comletedDate;
		}
		
		public function set comletedDate(value:Date):void 
		{
			_comletedDate = value;
		}
		
		public function get status():String 
		{
			return _status;
		}
		
		public function set status(value:String):void 
		{
			_status = value;
		}
		
		public function get lable():String 
		{
			return _lable;
		}
		
		public function set lable(value:String):void 
		{
			_lable = value;
		}
		
	}

}