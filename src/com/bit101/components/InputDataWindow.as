/**
 * Window.as
 * Keith Peters
 * version 0.9.10
 *
 * A draggable window. Can be used as a container for other components.
 *
 * Copyright (c) 2011 Keith Peters
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.bit101.components
{
	import adobe.utils.CustomActions;
	import com.adobe.serialization.json.JSON;
	import com.greensock.easing.Circ;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import com.greensock.TweenLite;

	[Event(name="select", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="resize", type="flash.events.Event")]
	public class InputDataWindow extends Component
	{
		protected var _title:String;
		protected var _titleBar:Panel;
		protected var _titleLabel:Label;
		protected var _panel:Panel;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _grips:Shape;

		protected var _unTextField:Text;
		protected var _pwTextField:Text;
		protected var _unLabel:Label;
		protected var _pwLabel:Label;
		protected var _submitBtn:PushButton;
		protected var _hintLabel:Label;

		private var realName:String;
		private var un:String;
		private var role:String;
		private var vbox:VBox;

		public var dataObj:Object;
		public var projectInfoVO:Object;
		public var stageInfoArr:Array;

		public var stationArr:Array;
		public var scollPanel:ScrollPane;
		private var inputData:Object;

		private var tableHeadMargin:Number = 45;
		private var footerMargin:Number = 30;

		private var flag:int = 0;
		private var nextBtn:PushButton;
		private var spriteArr:Array;
		private var continueBtn:PushButton;
		private var overBtn:PushButton
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param title The string to display in the title bar.
		 */
		public function InputDataWindow(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, title:String = "Window", rn:String = "")
		{
			this.realName = rn;
			_title = title;
			this.inputData = inputData;
			super(parent, xpos, ypos);
		}

		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			this.addEventListener(Event.ADDED_TO_STAGE, addtoStageHandler);
		}

		private function addtoStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addtoStageHandler);
			resizeHandler(null);
			this.stage.addEventListener(Event.RESIZE,resizeHandler);
		}

		private function resizeHandler(e:Event):void
		{
			if (this.stage != null)
			{
				_height = this.stage.stageHeight - 130;
				draw();
			}
		}
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_titleBar = new Panel();
			_titleBar.filters = [];
			_titleBar.buttonMode = false;
			_titleBar.height = 30;
			super.addChild(_titleBar);
			_titleLabel = new Label(_titleBar.content, 5, 6, _title,0x000000);
			_titleLabel.color = 0xFFFFFF;

			//_panel.visible = true;

			_panel = new Panel(null, 0, 30);
			//_panel.visible = true;
			_panel.shadow = false;
			super.addChild(_panel);

			/////////////////////////////////////////////////////////////////////////////////
			////
			/////////////////////////////////////////////////////////////////////////////////
			//scollPanel = new ScrollPane(_panel, 0, tableHeadMargin);
			//scollPanel.autoHideScrollBar = true;

			//scollPanel.addChild();

			/////////////////////////////////////////////////////////////////////////////////
			////
			/////////////////////////////////////////////////////////////////////////////////

			var stage1:Stage1 = new Stage1();
			var stage2:Stage2 = new Stage2();
			var stage3:Stage3 = new Stage3();
			var stage4:Stage4 = new Stage4();
			var stage5:Stage5 = new Stage5();
			var stage6:Stage6 = new Stage6();
			var stage7:Stage7 = new Stage7();
			var stage8:Stage8 = new Stage8();
			var stage9:Stage9 = new Stage9();
			var stage10:Stage10 = new Stage10();
			var stage11:Stage11 = new Stage11();
			var stage12:Stage12 = new Stage12();
			var stage13:Stage13 = new Stage13();

			spriteArr = new Array();
			spriteArr.push(stage1);
			spriteArr.push(stage2);
			spriteArr.push(stage3);
			spriteArr.push(stage4);
			spriteArr.push(stage5);
			spriteArr.push(stage6);
			spriteArr.push(stage7);
			spriteArr.push(stage8);
			spriteArr.push(stage9);
			spriteArr.push(stage10);
			spriteArr.push(stage11);
			spriteArr.push(stage12);
			spriteArr.push(stage13);

			filters = [getShadow(4, false)];
			TweenLite.from(this, 1, { alpha:0, ease:Circ.easeOut } );
			spriteArr[0].x = (650 - spriteArr[0].width) / 2;
			spriteArr[0].y = 30;
			spriteArr[0].transitionIn(_panel);
			projectInfoVO = new Object();
			projectInfoVO["stations"] = new Array();
			for each (var i in spriteArr)
			{
				i.x = (650 - i.width) / 2;
				i.y = 30;
			}
			nextBtn = new PushButton(_panel, 550/2, 210, "下一步", nextHandler);
			nextBtn.setSize(100, 35);

		}

		private function nextHandler(e:MouseEvent):void
		{
			if (flag < 13)
			{
				if (flag == 0)
				{

					//trace("create a new project, name is: ",projectInfoVO["projectName"]);
				} else if (flag == 1) {
					if (nextBtn.visible == false)
					{
						nextBtn.visible = true;
					}

				} else if (flag < 4)
				{

				} else if (flag == 4)
				{

				} else if(flag > 4)
				{


				}

				spriteArr[flag].transitionOut(showNext1);
			} else {
				nextBtn.label = "完成并返回";
			}

		}


		public function showNext1():void
		{
			trace("go here", flag);

			if (flag == 0)
			{
				projectInfoVO["projectName"] = spriteArr[0].dataVO["projectName"];
				projectInfoVO["realName"] = realName;
				trace("has pm name :", projectInfoVO['realName'], realName);
			}
			if (flag == 1)
			{
				stationArr = new Array();
				stationArr.push(spriteArr[flag].dataVO);
				(projectInfoVO["stations"] as Array).push(stationArr);
				//trace("create a new station:",projectInfoVO["stations"][(projectInfoVO["stations"] as Array).length][0]["stationName"]);
			}
			if (flag < 4 && flag > 1)
			{
				stationArr.push(spriteArr[flag].dataVO);
			}
			if (flag == 4)
			{
				stageInfoArr = new Array();
				stageInfoArr.push(spriteArr[flag].dataVO);
				stationArr.push(stageInfoArr);
			}
			if (flag > 4)
			{
				stageInfoArr.push(spriteArr[flag].dataVO);
			}
			showNext2();

		}
		public function showNext2():void {
			flag++;
			if (flag < 13)
			{
				if (nextBtn.visible == false)
					{
						nextBtn.visible = true;
					}
				if (flag == 4)
				{
					//把整机开始的时间写入3D开始的时间
					spriteArr[flag].starttimeBtn.text = spriteArr[flag - 1].starttime.text;
					spriteArr[flag].endtimeBtn.text = spriteArr[flag - 1].starttime.text;
				} else if (flag > 4)
				{
					//把每个阶段的开始时间设定为上个阶段的结束时间
					spriteArr[flag].starttimeBtn.text = spriteArr[flag - 1].endtimeBtn.text;
					spriteArr[flag].endtimeBtn.text = spriteArr[flag - 1].endtimeBtn.text;
					if (flag == 9) {
						spriteArr[flag].starttimeBtn.text = spriteArr[flag - 2].endtimeBtn.text;
						spriteArr[flag].endtimeBtn.text = spriteArr[flag - 2].endtimeBtn.text;
					}
				}
				spriteArr[flag].transitionIn(_panel);
			} else {
				nextBtn.visible = false;
				if (continueBtn == null)
				{
					continueBtn = new PushButton(_panel, 10, 10, "继续录入下个工位", continueInputHandler);
					overBtn = new PushButton(_panel, 80, 10, "完成并返回", overInputHandler);
				} else {
					_panel.addChild(continueBtn);
					_panel.addChild(overBtn);
				}
			}
		}
		public function overInputHandler(e:Event):void {
			_panel.content.removeChild(continueBtn);
			_panel.content.removeChild(overBtn);
			dataObj = new Object();
				dataObj["route"] = "7";
				projectInfoVO["realName"] = realName;
				dataObj["projectInfo"] = projectInfoVO;

				TweenLite.to(this,0.3,{alpha:0,onComplete:onCompletedHandler});
				_panel.content.removeChild(nextBtn);
		}
		public function continueInputHandler(e:Event):void {
			_panel.content.removeChild(continueBtn);
			_panel.content.removeChild(overBtn);
			flag = 0;
			showNext2();
		}
		public function onCompletedHandler():void
		{
			var parentContainer:DisplayObjectContainer;
			parentContainer = this.parent;
			parent.removeChild(this);
			parentContainer.stage.dispatchEvent(new Event(Event.RESIZE));
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function tableClickHandler(e:MouseEvent):void
		{
			trace(e.target.parent);
			TweenLite.to(this,0.3,{alpha:0,onComplete:onCompletedHandler});
		}


		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * Overridden to add new child to content.
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);
			return child;
		}

		/**
		 * Access to super.addChild
		 */
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}

		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			//trace("panel :",_panel.width,_panel.height);
			_titleBar.color = Style.WIN8_1_COLOR;
			_panel.color = _color;
			_titleBar.width = _width;
			_titleBar.draw();
			//trace(this.stage.stageHeight);
			_panel.setSize(_width, _height - 30 - footerMargin);

			//trace("panel2 :",_panel.width,_panel.height);
			_titleLabel.x = (_panel.width - _titleLabel.width) / 2;
			//scollPanel.setSize(_width, _panel.height - tableHeadMargin);
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * Internal mouseDown handler. Starts a drag.
		 * @param event The MouseEvent passed by the system.
		 */


		/**
		 * Internal mouseUp handler. Stops the drag.
		 * @param event The MouseEvent passed by the system.
		 */


		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		/**
		 * Gets / sets whether or not this Window will have a drop shadow.
		 */
		public function set shadow(b:Boolean):void
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [getShadow(4, false)];
			}
			else
			{
				filters = [];
			}
		}
		public function get shadow():Boolean
		{
			return _shadow;
		}

		/**
		 * Gets / sets the background color of this panel.
		 */
		public function set color(c:int):void
		{
			_color = c;
			invalidate();
		}
		public function get color():int
		{
			return _color;
		}

		/**
		 * Gets / sets the title shown in the title bar.
		 */
		public function set title(t:String):void
		{
			_title = t;
			_titleLabel.text = _title;
		}
		public function get title():String
		{
			return _title;
		}

		/**
		 * Container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
		 */
		public function get content():DisplayObjectContainer
		{
			return _panel.content;
		}

		/**
		 * Sets / gets whether or not the window will be draggable by the title bar.
		 */


		/**
		 * Gets / sets whether or not the window will show a minimize button that will toggle the window open and closed. A closed window will only show the title bar.
		 */



		/**
		 * Gets / sets whether the window is closed. A closed window will only show its title bar.
		 */


		/**
		 * Gets the height of the component. A minimized window's height will only be that of its title bar.
		 */
		override public function get height():Number
		{
			if(contains(_panel))
			{
				return super.height;
			}
			else
			{
				return 30;
			}
		}

		/**
		 * Sets / gets whether or not the window will display a close button.
		 * Close button merely dispatches a CLOSE event when clicked. It is up to the developer to handle this event.
		 */


		/**
		 * Returns a reference to the title bar for customization.
		 */
		public function get titleBar():Panel
		{
			return _titleBar;
		}
		public function set titleBar(value:Panel):void
		{
			_titleBar = value;
		}

		/**
		 * Returns a reference to the shape showing the grips on the title bar. Can be used to do custom drawing or turn them invisible.
		 */
		public function get grips():Shape
		{
			return _grips;
		}


	}
}