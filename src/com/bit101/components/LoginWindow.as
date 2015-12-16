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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import com.greensock.TweenLite;

	[Event(name="select", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="resize", type="flash.events.Event")]
	public class LoginWindow extends Component
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
		
		public var dataObj:Object;
		

		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param title The string to display in the title bar.
		 */
		public function LoginWindow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window")
		{
			_title = title;
			super(parent, xpos, ypos);
		}

		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			setSize(100, 100);
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

			_grips = new Shape();
			
			for(var i:int = 0; i < 4; i++)
			{
				_grips.graphics.lineStyle(1, 0xffffff, .55);
				_grips.graphics.moveTo(0, 3 + i * 4);
				_grips.graphics.lineTo(100, 3 + i * 4);
				_grips.graphics.lineStyle(1, 0, .125);
				_grips.graphics.moveTo(0, 4 + i * 4);
				_grips.graphics.lineTo(100, 4 + i * 4);
			}
			_titleBar.content.addChild(_grips);
			_grips.visible = false;
			
			_panel = new Panel(null, 0, 30);
			//_panel.visible = true;
			_panel.shadow = false;
			super.addChild(_panel);
			
			_unLabel = new Label(_panel, 225, 102, "用户名：");
			_pwLabel = new Label(_panel, 225, 142, "密   码：");
			Style.fontName = 'Verdana';
			_unTextField = new Text(_panel, 285, 100, "", false);
			_unTextField.setSize(140, 25);
			_pwTextField = new Text(_panel, 285, 140, "", false,true);
			_pwTextField.setSize(140, 25);
			_submitBtn = new PushButton(_panel, 550/2, 210, "确  定",submitClickHandler);
			_submitBtn.setSize(100, 35);
			
			_hintLabel = new Label(_panel, 264, 180, "错误的用户名和密码", 0xDA6432);
			_hintLabel.alpha = 0;

			filters = [getShadow(4, false)];
			TweenLite.from(super, 0.3, {alpha:0});
		}
		
		public function submitClickHandler(e:MouseEvent):void 
		{
			var loader:URLLoader = new URLLoader();  
			loader.addEventListener(Event.COMPLETE, loginResHandler);  
			un = _unTextField.text;
			loader.load(new URLRequest( "http://" + Stage.prototype.host + "/login?un=" + un + '&pw=' + _pwTextField.text));//这里是你要获取JSON的路径  
		}
		
		private function loginResHandler(e:Event):void 
		{
			var data = JSON.decode(URLLoader( e.target ).data);
			if (data.role != "None") 
			{
				this.role = data.role;
				this.realName = data.realName;
				_hintLabel.alpha = 0;
				dataObj = new Object();
				dataObj["route"] = "1";
				dataObj["role"] = this.role;
				dataObj["realName"] = this.realName;
				dataObj["userName"] = this.un;
				TweenLite.to(this, 0.3, { alpha:0 ,onComplete:onCompletedHandler} );
			} else {
				TweenLite.to(_hintLabel,0.3,{alpha:1});
			}
		}
		public function onCompletedHandler():void {
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
			_titleBar.color = Style.WIN8_1_COLOR;
			_panel.color = _color;
			_titleBar.width = width;
			_titleBar.draw();

			_grips.x = _titleLabel.x + _titleLabel.width;

			_grips.width = _width - _grips.x - 2;

			_panel.setSize(_width, _height - 30);
			_panel.draw();
			_titleLabel.x = (_panel.width - _titleLabel.width) / 2;
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