package 
{
	import flash.display.MovieClip;
	import flash.text.*;
	
	/**
	 * ...
	 * @author fs
	 */
	public class ProjectTable extends MovieClip 
	{
		private var pvo:ProjectVO;
		private var tableHead:TableHead;
		public function ProjectTable(projectObj:Object) 
		{
			super();
			drawTable(projectObj);
		}
		
		public function reflush(projectObj:Object):void {
			var len:uint = this.numChildren;
			while(len>0) {
				this.removeChildAt(0);
				len--;
			}
			drawTable(projectObj);
		}
		public function drawTable(projectObj:Object):void 
		{
			pvo = new ProjectVO(projectObj["projectName"], projectObj["projectCode"], projectObj["projectDutyMan"], projectObj["stationArr"] as Array, projectObj["tableHeadArr"] as Array);
			tableHead = new TableHead();
			(tableHead.tableHead as TextField).text = pvo.projectName;
			this.addChild(tableHead);
			var tempStationVO:StationVO;
			var sl:StationLine;
			for (var i:int = 0; i < pvo.stationArr.length; i++) 
			{
				tempStationVO = new StationVO(pvo["stationArr"][i]["stationNum"], pvo["stationArr"][i]["projectBelong"], pvo["stationArr"][i]["stationName"], pvo["stationArr"][i]["bluePrintNum"], pvo["stationArr"][i]["dutyMan"], pvo["stationArr"][i]["startPoint"], pvo["stationArr"][i]["stageArr"]);
				sl = new StationLine(tempStationVO);
				sl.x = 0;
				sl.y = 85 + i * 25;
				this.addChild(sl);
			}
		}
	}

}