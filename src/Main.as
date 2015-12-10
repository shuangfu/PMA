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
		public var pmMainPage:PMMainPage;
		public var gmMainPage:GMMainPage;
		public var projectDetailPage:ProjectDetailPage;
		public var mainContainer:VBox;
		public var dispatchVO:DispatchVO;
		public var projectName:String = "项目名称";

		public var un:String = "";
		public var manageMainPageVO:Object;
		public var role:String = "";

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
			Stage.prototype.host = "192.168.1.168:8010"
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
			switch (e.target.dataObj["route"])
			{
			case "1":
					if (this.un == "")
					{
						this.un = e.target.dataObj["userName"];
					}

					if (this.role == "")
					{
						this.role = e.target.dataObj["role"]
						Stage.prototype.role = this.role;
					}

					trace("importent1:",this.role);
					if (e.target.dataObj["role"] == "manager")
					{
						loader = new URLLoader();
						loader.addEventListener(Event.COMPLETE, managerDataHandler);
						loader.load(new URLRequest( "http://" + Stage.prototype.host + "/getProjectDelayInfo?un="+this.un));
					} else {
						loader = new URLLoader();
						loader.addEventListener(Event.COMPLETE, managerDataHandler);
						loader.load(new URLRequest( "http://" + Stage.prototype.host + "/getProjectDelayInfo?un="+this.un));
						//conv.y = 30;
						//conv.PMName.text = pmName;
						//loader = new URLLoader();
						//loader.addEventListener(Event.COMPLETE, convHandler);
						//loader.load(new URLRequest( "http://" + Stage.prototype.host + "/getConvData?un=" + conv.PMName.text));
					}
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
					var variables:URLVariables = new URLVariables();
					variables.pn = e.target.dataObj["projectName"];
					projectName = e.target.dataObj["projectName"];
					var urlRequest:URLRequest = new URLRequest( "http://" + Stage.prototype.host + "/getProjectInfo"); //接收数据。
					urlRequest.method = URLRequestMethod.GET;
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

			default:
				trace("no case care");
			}
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
			var pageTitle:Label = new Label(mainContainer, 0, 0, "PMA - 利元亨项目管理助手  V0.2");
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

