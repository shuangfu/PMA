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
	
	[Event(name="select",type="flash.events.Event")]
	[Event(name="close",type="flash.events.Event")]
	[Event(name="resize",type="flash.events.Event")]
	
	public class ProjectDetailPage extends Component
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
		
		private var projectName:String;
		private var projectDataVO:Object;
		private var un:String;
		private var role:String;
		
		public var dataObj:Object;
		public var scollPanel:ScrollPane;
		private var inputData:Object;
		
		private var tableHeadMargin:Number = 45;
		private var footerMargin:Number = 30;
		private var wd:StageDetailWindow;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param title The string to display in the title bar.
		 */
		public function ProjectDetailPage(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, title:String = "Window", inputData:Object = null)
		{
			_title = title;
			this.inputData = inputData;
			this.projectName = this.inputData["projectName"];
			this.projectDataVO = this.inputData["projectDataVO"];
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(1211, 400);
			this.addEventListener(Event.ADDED_TO_STAGE, addtoStageHandler);
		}
		
		private function addtoStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addtoStageHandler);
			resizeHandler(null);
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
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
			_titleLabel = new Label(_titleBar.content, 5, 6, _title, 0x000000);
			_titleLabel.color = 0xFFFFFF;
			
			_panel = new Panel(null, 0, 30);
			//_panel.visible = true;
			_panel.shadow = false;
			super.addChild(_panel);
			/////////////////////////////////////////////////////////////////////////////////
			////
			/////////////////////////////////////////////////////////////////////////////////
			scollPanel = new ScrollPane(_panel, 0, tableHeadMargin);
			scollPanel.autoHideScrollBar = true;
			trace(projectName);
			/////////////////////////////////////////////////////////////////////////////////
			////
			/////////////////////////////////////////////////////////////////////////////////
			
			filters = [getShadow(4, false)];
			TweenLite.from(this, 1, {alpha: 0, ease: Circ.easeOut});
			var projectTable = new ProjectTable(inputData, clickTableHandler);
			projectTable.x = 1;
			projectTable.y = 1;
			scollPanel.addChild(projectTable);
			var goBackBtn:PushButton = new PushButton(_panel, 5, 6, "返回", wdgoBackHandler)
			goBackBtn.setSize(100,35);
		}
		
		public function wdgoBackHandler(e:Event):void 
		{
			dataObj = new Object();
			dataObj["route"] = "5";
			dataObj["type"] = "goback";
			TweenLite.to(this,0.3,{alpha:0,onComplete:onCompletedHandler});
		}
		
		private function clickTableHandler(e:MouseEvent):void
		{
			var tempX:Number = 500;
			var tempY:Number = 200;
			trace(e.target.parent.theVO.stageID);
			if (wd != null)
			{
				if (wd.parent != null)
				{
					wd.removeEventListener(Event.CLOSE, wdCloseHandler);
					wd.parent.removeChild(wd);
					tempX = wd.x;
					tempY = wd.y;
				}
			}
			else
			{
				
			}
			wd = new StageDetailWindow(e.target.parent.theVO.stageID, this, tempX, tempY, "本阶段详细信息:");
			wd.hasCloseButton = true;
			wd.addEventListener(Event.CLOSE, wdCloseHandler);
			wd.addEventListener(Event.COMPLETE, wdCompleteHandler);
			wd.setSize(240, 210);
		}
		
		private function wdCompleteHandler(e:Event):void
		{
			dataObj = new Object();
			dataObj["route"] = "5";
			dataObj["type"] = "reflash";
			TweenLite.to(this,0.3,{alpha:0,onComplete:onCompletedHandler});
		}
		
		private function wdCloseHandler(e:Event):void
		{
			wd.removeEventListener(Event.CLOSE, wdCloseHandler);
			wd.parent.removeChild(wd);
		}
		
		public function onCompletedHandler():void
		{
			var parentContainer:DisplayObjectContainer;
			parentContainer = this.parent;
			parent.removeChild(this);
			parentContainer.stage.dispatchEvent(new Event(Event.RESIZE));
			dispatchEvent(new Event(Event.COMPLETE));
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
			scollPanel.setSize(_width, _panel.height - tableHeadMargin);
		
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
			if (_shadow)
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
			if (contains(_panel))
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