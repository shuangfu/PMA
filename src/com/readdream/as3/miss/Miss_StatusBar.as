package com.readdream.as3.miss 
{
	import com.readdream.as3.mr.Mr_Dresser;
	import com.readdream.as3.robot.Robot_PicLoader;
	import com.readdream.as3.robot.Robot_TextFormater;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author evstar
	 */
	public class Miss_StatusBar extends Sprite 
	{
		private const sizeWidth:Number = 960;
		private const sizeHeight:Number = 40;
		private const txtLoginX:Number = 880;
		private const backgroundColor:uint = 0xECECEC;
		private const borderColor:uint = 0xBDBDBD;
		private const userName:String = "evstarcn@gmail.com";

		
		public var txtLogin:TextField = new TextField();
		private var picDefault:Robot_PicLoader;
		private var picActivate:Robot_PicLoader;
		private var picClick:Robot_PicLoader;
		private var sprPic:Sprite = new Sprite();
		
		private var sprContent:Sprite = new Sprite();
		private var picLogin:Robot_PicLoader;
		
		
		
		public function Miss_StatusBar() 
		{
			initData();
			initStyle();

			
		}
		
		private function initData():void 
		{
			sprContent = Mr_Dresser.getMasker(sizeWidth, sizeHeight, backgroundColor);
			txtLogin.text = "登录";
			//txtLogin.autoSize = TextFieldAutoSize.LEFT;
			//txtLogin.opaqueBackground = 0xff0000;
			txtLogin.width = 218;
			txtLogin.height = 19
			txtLogin.x = 700;
			txtLogin.y = (sprContent.height / 2) - (txtLogin.height / 2) + 2;
			txtLogin.selectable = false;
			//txtLogin.
			txtLogin.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.STATUSBAR_LOGINTEXT));
			
			picDefault = new Robot_PicLoader("assets/setdefault.png", 0, 0, 30, 25);
			picActivate = new Robot_PicLoader("assets/setmoveon.png", 0, 0, 30, 25);
			picClick = new Robot_PicLoader("assets/setclick.png", 0, 0, 30, 25);			
		}
		
		private function initStyle():void 
		{
			Mr_Dresser.drawBorderByLine(sprContent, new Point(0, 0), new Point(sizeWidth, 0), new Point(sizeWidth, sizeHeight), new Point(0, sizeHeight), 0.5, 0xBDBDBD, 1);
			
			sprPic.addChild(picClick);
			sprPic.addChild(picActivate);
			sprPic.addChild(picDefault);
			
			sprPic.x = 923;
			sprPic.y = (sprContent.height / 2) - (sprPic.height / 2);
			
			
			
			addChild(sprContent);
			sprContent.addChild(txtLogin);
			sprContent.addChild(sprPic);
			
			
			
			sprPic.addEventListener(MouseEvent.ROLL_OVER, picRollOverHandler);
			sprPic.addEventListener(MouseEvent.ROLL_OUT, picRollOutHandler);
			sprPic.addEventListener(MouseEvent.MOUSE_DOWN, picMouseDownHandler);
			sprPic.addEventListener(MouseEvent.MOUSE_UP, picMouseUpHandler);
			txtLogin.addEventListener(MouseEvent.ROLL_OVER, txtLoginRollOverHandler);
			txtLogin.addEventListener(MouseEvent.ROLL_OUT, txtLoginRollOutHandler);
			txtLogin.addEventListener(MouseEvent.CLICK, txtLoginClickHandler);
		}
		
		private function txtLoginClickHandler(e:MouseEvent):void 
		{
			if (txtLogin.text == "登录") {
				loginIn();
			}else {
				loginOut();
			}
		}
		
		public function loginIn():void {
			txtLogin.text = userName;
			txtLogin.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.STATUSBAR_LOGINTEXT));
			picLogin = new Robot_PicLoader("assets/picLogin.png", 0, 0, 7, 4);
			txtLogin.x = 685;
			picLogin.x = 908;
			picLogin.y = (sprContent.height / 2) - (picLogin.height / 2) + 2;
			sprContent.addChild(picLogin);
		}
		
		public function loginOut():void {
			txtLogin.text = "登录";
			txtLogin.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.STATUSBAR_LOGINTEXT));
			txtLogin.x = 700;
			sprContent.removeChild(picLogin);
			
		}
		
		private function txtLoginRollOutHandler(e:MouseEvent):void 
		{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function txtLoginRollOverHandler(e:MouseEvent):void 
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		private function picMouseUpHandler(e:MouseEvent):void 
		{
			picActivate.visible = true;
		}
		
		private function picMouseDownHandler(e:MouseEvent):void 
		{
			picActivate.visible = false;
		}
		
		private function picRollOutHandler(e:MouseEvent):void 
		{
			picDefault.visible = true;
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function picRollOverHandler(e:MouseEvent):void 
		{
			picDefault.visible = false;
			Mouse.cursor = MouseCursor.BUTTON;
		}		
		
	}

}