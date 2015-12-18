package
{
	import adobe.utils.CustomActions;
	import com.bit101.components.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import com.adobe.serialization.json.*;

	/**
	 * ...
	 * @author fs
	 */
	[SWF(width="1230", height="700", frameRate="60", backgroundColor="#ffffff")]
	public class Main extends Sprite
	{
		public var loginWindow:LoginWindow;
		public var inputWindow:InputDataWindow;
		public var pmMainPage:PMMainPage;
		public var gmMainPage:GMMainPage;
		public var projectDetailPage:ProjectDetailPage;
		public var mainContainer:VBox;
		public var dispatchVO:DispatchVO;
		public var projectName:String = "项目名称";

		public var un:String = "";
		public var manageMainPageVO:Object;
		public var role:String = "";
		public var realName:String;
		public function Main()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			dispatchVO = new DispatchVO();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			Stage.prototype.host = "localhost:8010"
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
			mainContainer = new VBox(this, 0, 0);
			mainContainer.spacing = 45;
			mainContainer.alignment = "center";

			drawPageHead();
			showLoginWindow();
			this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			dispatchVO.addEventListener(Event.COMPLETE,controlHandler);
		}


		public function controlHandler(e:Event):void {
			var loader:URLLoader;
			var variables:URLVariables;
			var urlRequest;URLRequest;
			switch (e.target.dataObj["route"])
			{
				case "1":
					this.realName = e.target.dataObj["realName"];
					trace("login");
					if (this.un == "")
					{
						this.un = e.target.dataObj["userName"];
					}

					if (this.role == "")
					{
						this.role = e.target.dataObj["role"]
						Stage.prototype.role = this.role;
					}

					trace("importent1:", this.role);
					variables = new URLVariables();
					loader = new URLLoader();
					variables.un = this.un;
					urlRequest = new URLRequest( "http://" + Stage.prototype.host + "/getProjectDelayInfo"); //接收数据。
					urlRequest.method = URLRequestMethod.POST;
					urlRequest.data = variables;
					loader.addEventListener(Event.COMPLETE, managerDataHandler);
					loader.load(urlRequest);

				break;
			case "2":
					trace("importent:",this.role);
					if (this.role == "manager")
					{
						showGMMainPage(e.target.dataObj["data"])
					}else {
						showPMMainPage(e.target.dataObj["data"]);
					}

				break;
			case "3":
					loader = new URLLoader();
					variables = new URLVariables();
					variables.pn = e.target.dataObj["projectName"];
					projectName = e.target.dataObj["projectName"];
					urlRequest = new URLRequest( "http://" + Stage.prototype.host + "/getProjectInfo"); //接收数据。
					urlRequest.method = URLRequestMethod.POST;
					urlRequest.data = variables;
					loader.addEventListener(Event.COMPLETE, projectDetailDataHandler);
					loader.load(urlRequest);
				break;
			case "4":
				//pvo = new ProjectVO(projectObj["projectName"], projectObj["projectCode"], projectObj["projectDutyMan"], projectObj["stationArr"] as Array, projectObj["tableHeadArr"] as Array);
					showProjectDetailTable(e.target.dataObj["data"]);
				break;
			case "5":
				//pvo = new ProjectVO(projectObj["projectName"], projectObj["projectCode"], projectObj["projectDutyMan"], projectObj["stationArr"] as Array, projectObj["tableHeadArr"] as Array);
					if (e.target.dataObj["type"] == "goback")
					{
						dispatchVO.dataObj["route"] = "1";
						dispatchVO.dataObj["userName"] = this.un;
						e.target.dataObj["role"] = this.role;
						dispatchVO.dispatchEvent(new Event(Event.COMPLETE));
					}else {
						dispatchVO.dataObj["route"] = "3";
						dispatchVO.dataObj["projectName"] = this.projectName;
						dispatchVO.dispatchEvent(new Event(Event.COMPLETE));
					}
				break;
			case "6":
				trace("show input window");
				showInputWindow();
				break;
			case "7" :
				sendNewProjectInfoToBack(e.target.dataObj["projectInfo"]);
			break;
			default:
				trace("no case care");
			}
		}

		public function sendNewProjectInfoToBack(tempObj:Object):void
		{
			var jsonString : String = JSON.encode(tempObj);
			var loader:URLLoader;
			loader = new URLLoader();
			var variables:URLVariables = new URLVariables();
			variables.pi = jsonString;
			var urlRequest:URLRequest = new URLRequest( "http://" + Stage.prototype.host + "/addProject"); //接收数据。
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = variables;
			loader.addEventListener(Event.COMPLETE, sendSuccess);
			loader.load(urlRequest);
		}

		private function sendSuccess(e:Event):void
		{
			trace("send new project data successed...");
			dispatchVO.dataObj["route"] = "5";
			dispatchVO.dataObj["type"] = "goback";
			dispatchVO.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function showInputWindow():void
		{
			trace("ready to new project:",this.realName);
			inputWindow = new InputDataWindow(mainContainer, 0, 0, "新项目数据录入",realName);
			inputWindow.setSize(650, 400);
			this.stage.dispatchEvent(new Event(Event.RESIZE));
			inputWindow.addEventListener(Event.COMPLETE,controlHandler);
		}

		public function showGMMainPage(dataVO:Object):void
		{
			gmMainPage = new GMMainPage(mainContainer, 0, 0, "所有项目进度概览",dataVO);
			gmMainPage.setSize(970, 400);
			this.stage.dispatchEvent(new Event(Event.RESIZE));
			gmMainPage.addEventListener(Event.COMPLETE,controlHandler);
		}

		private function enterFrameHandler(e:Event):void
		{
			this.stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			resizeHandler(null);
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////
		////
		//////////////////////////////////////////////////////////////////////////////////////////////////////

		private function drawPageHead():void
		{
			Style.fontSize = 42;
            Style.embedFonts = false;
            Style.fontName = 'Verdana';
			Style.setStyle("light");
			var pageTitle:Label = new Label(mainContainer, 0, 0, "PMA - 利元亨项目管理助手  V0.3.1");
			//pageTitle.move((this.stage.stageWidth - pageTitle.width) / 2, 30);
			Style.fontSize = 13;
		}

		private function showLoginWindow():void {
			loginWindow = new LoginWindow(mainContainer, 0, 0, "登    录");
			loginWindow.setSize(650, 400);
			loginWindow.addEventListener(Event.COMPLETE,controlHandler);

			//loginWindow.draggable = false;
			//loginWindow.panel.shadow = false;
			//loginWindow.hasCloseButton = true;
			//loginWindow.hasMinimizeButton = true;
			//loginWindow.move((this.stage.stageWidth - loginWindow.width) / 2, 120);
		}
		public function showPMMainPage(dataVO:Object):void
		{
			pmMainPage = new PMMainPage(mainContainer, 0, 0, "所有项目进度概览",dataVO);
			//manageMainPage.setSize(650, 400);

			pmMainPage.addEventListener(Event.COMPLETE,controlHandler);
		}
		public function showProjectDetailTable(dataVO:Object):void
		{
			var obj:Object = new Object;
			obj["projectName"] = this.projectName;
			obj["projectDataVO"] = dataVO;
			trace("ready to render tableDetails:",this.projectName);
			projectDetailPage = new ProjectDetailPage(mainContainer, 0, 0, "项目详细信息", obj);
			projectDetailPage.setSize(1211, 400);
			this.stage.dispatchEvent(new Event(Event.RESIZE));
			projectDetailPage.addEventListener(Event.COMPLETE,controlHandler);
		}
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		////
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		private function resizeHandler(e:Event):void
		{
			//trace("resize is trigger");
			mainContainer.move((this.stage.stageWidth - mainContainer.width) / 2, 30);
		}

		private function managerDataHandler(e:Event):void
		{
			dispatchVO.dataObj["route"] = "2";
			dispatchVO.dataObj["data"] = JSON.decode( URLLoader( e.target ).data );
			dispatchVO.dispatchEvent(new Event(Event.COMPLETE));
		}
		public function projectDetailDataHandler(e:Event):void
		{
			dispatchVO.dataObj["route"] = "4";
			dispatchVO.dataObj["data"] = JSON.decode( URLLoader( e.target ).data );
			dispatchVO.dispatchEvent(new Event(Event.COMPLETE));
		}
	}

}

