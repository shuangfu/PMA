package
{
	import adobe.utils.CustomActions;
	import com.adobe.protocols.dict.events.DictionaryServerEvent;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.net.*;
	import com.adobe.serialization.json.*;
	
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
		
		private var projectTable:ProjectTable;
		private var stationArr:Array;
		
		private var lp:LoginPannel;
		private var conv:Conv;
		private var backPageBtn:Miss_Button;
		private var pmName:String;
		private var role:String;
		private var realName:String;
		private var overViewTables:MovieClip;
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
			backPageBtn = new Miss_Button("返回", 80, 25);
			backPageBtn.x = 15;
			backPageBtn.y = 5;
			backPageBtn.addEventListener(MouseEvent.CLICK, backPageBtnClickHandler);
			var cellArr :Array = new Array();
			login();
			//initData();
			//drawTable();

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

		private function backPageBtnClickHandler(e:MouseEvent):void 
		{
			this.stage.removeChild(backPageBtn);
			this.stage.removeChild(projectTable);
			showConV(this.role);
		}
		
		private function login():void 
		{
			lp = new LoginPannel();
			lp.x = 512;
			lp.y = 139;
			lp.hint.alpha = 0;
			lp.lgbtn.addEventListener(MouseEvent.CLICK, loginHandler);
			this.addChild(lp);
		}
		
		private function loginHandler(e:MouseEvent):void 
		{
			var loader:URLLoader = new URLLoader();  
			loader.addEventListener(Event.COMPLETE, loginResHandler);  
			pmName = this.lp.un.text;
			loader.load(new URLRequest( "http://192.168.1.168:8010/login?un="+ this.lp.un.text + '&pw=' +this.lp.pw.text));//这里是你要获取JSON的路径  
		}
		
		private function loginResHandler(e:Event):void 
		{
			var data = JSON.decode(URLLoader( e.target ).data);
			if (data.role != "None") 
			{
				this.role = data.role;
				this.realName = data.realName;
				removeChild(lp);
				trace(this.realName);
				showConV(this.role);
				
			} else {
				this.lp.hint.alpha = 1;
			}
		}
		public function showConV(role:String):void 
		{	
			var loader:URLLoader;
			if (role == "manager") 
			{
				overViewTables = new MovieClip();
				loader = new URLLoader();  
				loader.addEventListener(Event.COMPLETE, managerViewHandler);  
				loader.load(new URLRequest( "http://192.168.1.168:8010/getProjectDelayInfo?un=manager"));
			} else {
				conv = new Conv();
				conv.x = 170;
				conv.y = 30;
				conv.PMName.text = pmName;
				loader = new URLLoader();  
				loader.addEventListener(Event.COMPLETE, convHandler);  
				loader.load(new URLRequest( "http://192.168.1.168:8010/getConvData?un=" + conv.PMName.text));
			}
			
		}
		
		private function managerViewHandler(e:Event):void 
		{
			this.stage.addChild(overViewTables);
			var managerViewObj:Object = JSON.decode( URLLoader( e.target ).data );  
			//var tempOverViewTable:OverviewTable;
			//for (var k:int = 0; k < (managerViewObj as Array).length; k++ ) {
				//tempOverViewTable = new OverviewTable(managerViewObj[k]);
				//overViewTables.addChild(tempOverViewTable);
				//tempOverViewTable.x = 0;
				//tempOverViewTable.y = (managerViewObj[k]["lineArr"] as Array).length * 25 + 50;
				//tempOverViewTable.addEventListener(MouseEvent.CLICK, mouseClickManager);
			//}
			var tagY:Number = 0;
			for (var i:int = 0; i < managerViewObj.length; i++) 
			{
				var tempObjVO:Object = new Object();
				tempObjVO['projectName'] = managerViewObj[i]['projectName'];
				trace("+++",tempObjVO['projectName']);
				tempObjVO['lineArr'] = new Array();
				var tempArray:Array = managerViewObj[i]['list'];
				
				for (var j:int = 0; j < tempArray.length; j++) 
				{
					var tempStageObj:Object = new Object();
					var tempArr:Array = (tempArray[j] as String).split("|");
					tempStageObj['stationName'] = tempArr[0];
					tempStageObj['stageName'] = tempArr[1];
					tempStageObj['delayDays'] = tempArr[2];						
					tempStageObj['process'] = tempArr[3];
					tempStageObj['dutyMan'] = tempArr[4];
					(tempObjVO['lineArr'] as Array).push(tempStageObj);
				}
				var ovTable:OverviewTable = new OverviewTable(tempObjVO);
				ovTable.x = 0;
				ovTable.y = i * 180;
				trace('yyyyyyyy', tagY);
				overViewTables.addChild(ovTable);
				tagY = tagY + tempArray.length;
			}
			
		}
		
		private function mouseClickManager(e:MouseEvent):void 
		{
			trace("here");
		}
		private function convHandler(e:Event):void 
		{
			this.stage.addChild(conv);
			var convVO:Object = JSON.decode( URLLoader( e.target ).data );  
			conv.PMName.text = convVO["pmName"];
			conv.todayDate.text = convVO["date"];
			var tempStr = "您一共有负责 " + convVO["projectNums"] + "个项目，其中：";
			var tempDelayLine : DelayInfoLine;
			for (var j:int = 0; j < (convVO["delayInfo"] as Array).length; j++) 
			{
				tempDelayLine = new DelayInfoLine(convVO["delayInfo"][j]["projectID"]);
				tempDelayLine.projectName.text = convVO["delayInfo"][j]["projectName"];
				tempDelayLine.stationNum.text = convVO["delayInfo"][j]["stationNum"];
				tempDelayLine.stageNum.text = convVO["delayInfo"][j]["stageNum"];
				tempDelayLine.percent.text = convVO["delayInfo"][j]["percent"];
				tempDelayLine.dutyMan.text = convVO["delayInfo"][j]["dutyMan"];
				tempDelayLine.x = 30;
				tempDelayLine.y = 60 + 25 * j;
				conv.addChild(tempDelayLine);
			}
			conv.otherText.text = tempStr;
			conv.addEventListener(MouseEvent.CLICK, mouseClickConv);
		}
		
		private function mouseClickConv(e:MouseEvent):void 
		{
			if (e.target is TextField) {
				drawTable((e.target.parent as DelayInfoLine).projectID);
			} else {
				drawTable((e.target as DelayInfoLine).projectID);
			}
			this.stage.removeChild(conv);
			
		}

		private function initData():void 
		{
			//stationArr = new Array();
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))
			//stationArr.push(new StationVO("工位1", 30, "荣柄杰", new Date("11/03/2015"),[new Date("11/08/2015"),new Date("11/10/2015"),new Date("11/10/2015"),new Date("11/11/2015"),new Date("11/26/2015"),new Date("11/26/2015"),new Date("11/28/2015"),new Date("12/08/2015")]))

			//projects = new Array();
			//projects.push(new ProjectVO("B1090 LFP包装机左线排期表（3台）", "B1090", "付爽", stationArr, ["序号","工位名称","图纸数量","负责人","开始时间","3D","2D","外购清单","资材","机加工","外购件","物料入库","模块装配","整机装配"]));
		}
		
		private function drawTable(projectID:String):void {
			//projectTable = new MovieClip();
			//var tableHead : TableHead = new TableHead();
			//(tableHead.tableHead as TextField).text = (projects[0] as ProjectVO).projectName;
			//projectTable.addChild(tableHead);
			//var sl:StationLine = new StationLine(((projects[0] as ProjectVO).stationArr[0] as StationVO));
			//sl.x = 0;
			//sl.y = 85;
			//projectTable.addChild(sl);
			//this.stage.addChild(projectTable);
			var loader:URLLoader = new URLLoader();  
			loader.addEventListener(Event.COMPLETE, decodeJSON);  
			loader.load(new URLRequest( "http://192.168.1.168:8010/getProjectsByID?projectID=" + projectID));//
			
			//var tc:TableCell = new TableCell(new CellVO("付爽"), 200, 25);
			//addChild(tc);
		}
		private function clickHandler(e:MouseEvent):void 
		{
			//((e.currentTarget ) as TableCell).setCompleted();
		}

		private function decodeJSON(evt:Event):void {  
			trace("got the projects JSON");
			var backProjectVO:Object = JSON.decode( URLLoader( evt.target ).data );  
			
			
			//var tempTableHeadArr : Array = new Array();
			//for (var i:int = 0; i < (backProjectVO["tableHeadArr"] as Array).length; i++) {
				//tempTableHeadArr.push(backProjectVO["tableHeadArr"][i])
				//trace(backProjectVO["tableHeadArr"][i]);
			//}
		
			
			projectTable = new ProjectTable(backProjectVO);
			//trace(((projects[0] as ProjectVO).stationArr[0] as Station).DutyMan);
			
			this.stage.addChild(projectTable);
			this.stage.addChild(backPageBtn);
		}  
		
	}
	
}

