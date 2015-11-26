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
		public function StationLine(_stationVO:StationVO) 
		{
			super();
			this._stationVO = _stationVO;
			trace(_stationVO["projectBelong"]);
			showCell();
		}
		
		public function showCell():void 
		{
			var tempX:Number = 0;
			cellArr = new Array();
			trace(_stationVO["stationNum"]);
			cellArr.push(new NewCell(new NewCellVO(_stationVO["stationNum"], _stationVO["projectBelong"], _stationVO["stationNum"]), 40 , 25));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.stationName, _stationVO.projectBelong, _stationVO.stationNum), 200 , 25));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.bluePrintNum.toString(),_stationVO.projectBelong,_stationVO.stationNum)));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.DutyMan, _stationVO.projectBelong, _stationVO.stationNum)));
			cellArr.push(new NewCell(new NewCellVO(_stationVO.startPoint, _stationVO.projectBelong, _stationVO.stationNum)));
			for (var j:int = 0; j < _stationVO.stageArr.length ; j++) 
			{
				cellArr.push(new NewCell(new NewCellVO(_stationVO.stageArr[j]["lable"],_stationVO.projectBelong,_stationVO.stationNum,j.toString(),_stationVO.stageArr[j]["percent"],_stationVO.stageArr[j]["statusFlag"])));
			}
			for (var i:int = 0; i < cellArr.length; i++) 
			{
				cellArr[i].x = tempX;
				tempX += cellArr[i].width - 1;
				cellArr[i].y = 0;
				if ((cellArr[i] as NewCell).theVO.statusFlag == "RUNNING")
				{
					(cellArr[i] as NewCell).addEventListener(MouseEvent.CLICK, mouseClickHandler);
				}
				addChild(cellArr[i]);
			}
		}
		
		private function mouseClickHandler(e:MouseEvent):void 
		{
			trace((e.currentTarget as NewCell).theVO.projectBelong);
			trace((e.currentTarget as NewCell).theVO.stationBelong);
			trace((e.currentTarget as NewCell).theVO.stageNum);
			var loader:URLLoader = new URLLoader();  
			var url:URLRequest = new URLRequest("http://127.0.0.1:8010/cd");
			url.method = URLRequestMethod.GET;
			var values:URLVariables = new URLVariables();
			values.project = (e.currentTarget as NewCell).theVO.projectBelong;
			values.station = (e.currentTarget as NewCell).theVO.stationBelong;
			values.stage = (e.currentTarget as NewCell).theVO.stageNum;
				
			url.data = values;
			loader.addEventListener(Event.COMPLETE, decodeJSON);  
			loader.load(url);//这里是你要获取JSON的路径  
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