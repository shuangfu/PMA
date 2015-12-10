package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.*;
	import com.adobe.serialization.json.*;
	/**
	 * ...
	 * @author fs
	 */
	public class StationLine extends MovieClip 
	{
		private var _stationVO :StationVO;
		private var cellArr:Array;
		private var func:Function;
		public function StationLine(_stationVO:StationVO,func:Function) 
		{
			super();
			this.func = func;
			this._stationVO = _stationVO;
			showCell();
		}
		
		public function showCell():void 
		{
			var tempX:Number = 0;
			cellArr = new Array();
			cellArr.push(new NewCell(new NewCellVO(_stationVO["stationNum"]), 40 , 25));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.stationName), 200 , 25));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.bluePrintNum.toString())));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.DutyMan)));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.startPoint)));
			for (var j:int = 0; j < _stationVO.stageArr.length ; j++) 
			{
				trace("===",_stationVO.stageArr[j][2],"===");
				cellArr.push(new NewCell(new NewCellVO(_stationVO.stageArr[j][0],_stationVO.stageArr[j][1],_stationVO.stageArr[j][2],_stationVO.stageArr[j][3])));
			}
			for (var i:int = 0; i < cellArr.length; i++) 
			{
				cellArr[i].x = tempX;
				tempX += cellArr[i].width - 1;
				cellArr[i].y = 0;
				if (i > 4) 
				{
					(cellArr[i] as NewCell).addEventListener(MouseEvent.CLICK, func);
				}
				addChild(cellArr[i]);
			}
		}
		
		
		private function decodeJSON(e:Event):void 
		{
			trace("send change Data Done...");
			(this.parent as ProjectTable).reflush(JSON.decode(URLLoader( e.target ).data));
		}
		

		public function get stationVO():StationVO
		{
			return _stationVO;
		}
		
		public function set stationVO(value:StationVO):void 
		{
			_stationVO = value;
		}
	}

}