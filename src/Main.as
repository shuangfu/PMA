package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	/**
	 * ...
	 * @author fs
	 */
	public class Main extends Sprite 
	{
		private var testCell:TableCell;
		private var tempDate:Date = new Date();
		private var positionX:Number = 480;
		private var positionY:Number = 85;
		private var projects:Array;
		
		private var projectTable:MovieClip;
		private var stationArr:Array;
		
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var cellArr :Array = new Array();
			
			initData();
			drawTable();

			//for (var j:int = 0; j < 12; j++) 
			//{
				//for (var i:int = 0; i < 8; i++) {
					//cellArr[j*8 + i].x = positionX + i * 80;
					//cellArr[j*8 + i].y = positionY + j * 25;
					//cellArr[j*8 + i].addEventListener(MouseEvent.CLICK, clickHandler);
					//addChild(cellArr[j*8 + i]);
				//}
//
			//}
		}
		
		private function initData():void 
		{
			stationArr = new Array();
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			stationArr.push(new Station("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))

			projects = new Array();
			projects.push(new ProjectVO("B1090 LFP包装机左线排期表（3台）", "B1090", "付爽", stationArr, ["序号","工位名称","图纸数量","负责人","开始时间","3D","2D","外购清单","资材","机加工","外购件","物料入库","模块装配","整机装配"]));
		}
		
		private function drawTable():void {
			projectTable = new MovieClip();
			var tableHead : TableHead = new TableHead();
			(tableHead.tableHead as TextField).text = (projects[0] as ProjectVO).projectName;
			projectTable.addChild(tableHead);
			var sl:StationLine = new StationLine(((projects[0] as ProjectVO).stationArr[0] as Station));
			trace(((projects[0] as ProjectVO).stationArr[0] as Station).DutyMan);
			sl.x = 0;
			sl.y = 85;
			projectTable.addChild(sl);
			this.stage.addChild(projectTable);
			
			//var tc:TableCell = new TableCell(new CellVO("付爽"), 200, 25);
			//addChild(tc);
		}
		private function clickHandler(e:MouseEvent):void 
		{
			((e.currentTarget ) as TableCell).setCompleted();
		}
		
	}
	
}

