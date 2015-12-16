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
		private var func:Function;
		public function ProjectTable(projectObj:Object,func:Function) 
		{
			super();
			this.func = func;
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
			pvo = new ProjectVO(projectObj["projectName"], projectObj["projectDataVO"]);
			tableHead = new TableHead();
			(tableHead.tableHead as TextField).text = pvo.projectName;
			this.addChild(tableHead);
			var tempStationVO:StationVO;
			var sl:StationLine;
			for (var i:int = 0; i < pvo.stationArr.length; i++) 
			{
				//_stationNum:String, _projectBelong:String, _stationName : String, _bluePrintNum : Number,  _dutyMan:String, _startPoint:String, _stageArr:Array
				tempStationVO = new StationVO(pvo["stationArr"][i]["stationNo"], pvo["stationArr"][i]["stationName"], pvo["stationArr"][i]["bluePrintQ"], "dutyman", pvo["stationArr"][i]["stationStartTime"], pvo["stationArr"][i]["stageArr"]);
				trace("station info:",pvo["stationArr"][i]["stageArr"]);
				sl = new StationLine(tempStationVO,func);
				sl.x = 0;
				sl.y = 85 + i * 25;
				this.addChild(sl);
			}
		}
	}

}