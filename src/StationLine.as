package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author fs
	 */
	public class StationLine extends MovieClip 
	{
		private var _stationVO :Station;
		
		private var cellArr:Array;
		public function StationLine(_stationVO:Station) 
		{
			super();
			this._stationVO = _stationVO;
			showCell();
		}
		
		public function showCell():void 
		{
			var tempX:Number = 0;
			cellArr = new Array();
			cellArr.push(new TableCell(new CellVO("1"), 40 , 25));
			cellArr.push(new TableCell(new CellVO(_stationVO.stationName), 200 , 25));
			cellArr.push(new TableCell(new CellVO(_stationVO.bluePrintNum.toString())));
			cellArr.push(new TableCell(new CellVO(_stationVO.DutyMan)));
			var arr:Array = CellVO.getDateString(_stationVO.startPoint);
			var tempStr = arr[1] + "/" + arr[2];
			cellArr.push(new TableCell(new CellVO(tempStr)));
			for (var j:int = 0; j < _stationVO.stageArr.length ; j++) 
			{
				if (j == 0) 
				{
					cellArr.push(new TableCell(new CellVO(null,_stationVO.stageArr[j], null,_stationVO.startPoint)));
				} else {
					cellArr.push(new TableCell(new CellVO(null,_stationVO.stageArr[j], null,_stationVO.stageArr[j-1])));
				}
				
			}
			
			for (var i:int = 0; i < cellArr.length; i++) 
			{
				cellArr[i].x = tempX;
				trace("----", tempX);
				tempX += cellArr[i].width - 1;
				cellArr[i].y = 0;
				addChild(cellArr[i]);
			}
		}

		
		public function get stationVO():Station 
		{
			return _stationVO;
		}
		
		public function set stationVO(value:Station):void 
		{
			_stationVO = value;
		}
	}

}