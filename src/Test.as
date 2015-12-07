package
{
	import com.bit101.charts.BarChart;
	import com.bit101.components.*;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

    import flash.display.Sprite;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

    public class Test extends Sprite
    {
        private var _btn:PushButton;
		private var _wd:Window;
		private var _calen:Calendar;
		private var  wd:Window;
        public function Test()
        {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
            Style.fontSize = 13;
            Style.embedFonts = false;
            Style.fontName = '宋体';
            Style.BACKGROUND = 0x000000;
            Style.BUTTON_FACE = 0xFFFFFF;
            //_btn = new PushButton(this, 100, 100, '测试');
            //_btn.setSize(100, 25);
//
          ////_btn.enabled = false;
			//
			//_wd = new Window(this, 150, 150, "测试");
			//_wd.setSize(650, 400);
			//_wd.hasCloseButton = true;
			//
			//_calen = new Calendar(this, 100, 100);
			//_calen.setDate(new Date());
		//
			////_calen.setSize(300, 300);
			//var pn:Panel = new Panel(this, 0, 0);
			////pn.gridColor = 0x000000;
			////pn.gridSize = 50;
			//pn.showGrid = true;
			//pn.setSize(200, 250);
			//
			////var sp:ScrollPane = new ScrollPane(this,50,50);
			////sp.setSize(50, 50);
			////sp.addChild(_calen);
			//
			//var tx:Text = new Text(this, 60, 60, "testest");
			//tx.setSize(80, 25);
			//tx.textField.multiline = false;
			//tx.textField.maxChars = 6;
			//tx.useHandCursor = true;
			//var rs:RotarySelector = new RotarySelector(this, 80, 80, "hi", handler);
			//
			//var kn:Knob = new Knob(this, 210, 210, "OK", handler);
			//var wm:WheelMenu = new WheelMenu(this, 5, 80, 60, 10, handler);
			//
			//var sp:ScrollPane = new ScrollPane(this, 100, 100);
			//sp.setSize(150, 150);
			//sp.addChild(pn);
			//sp.autoHideScrollBar = false;
			//sp.dragContent = true;
			//sp.update();
//
			
//

//
            //var il : IndicatorLight = new IndicatorLight(this, 50, 50, 0xFF0000, "hesnten");
			//il.flash(500);
			////
			////var bc :BarChart = new BarChart(this, 100, 100, [3, 5, 7, 1]);
			////bc.setSize(80,100);
			////
			//wd = new Window(this, 50, 50, "nihk ");
			//wd.hasCloseButton = true;
			//wd.hasMinimizeButton = true;
			//wd.addEventListener(Event.CLOSE, wdhandler);
			//
			//var hb:HBox = new HBox(wd, 0, 0);
			//var _btn1 :PushButton;
			//var _btn2 :PushButton;
			//var _btn3 :PushButton;
//
			//_btn1 = new PushButton(hb, 0, 0, '测试');
			//_btn1.setSize(120, 25);
			//_btn2 = new PushButton(hb, 0, 0, '测试');
			//_btn2.setSize(240, 25);
			//_btn3 = new PushButton(hb, 0, 0, '测试');
			//_btn3.setSize(80, 25);
			//
			//hb.spacing = -1;
			//hb.alignment = "middle";
			//hb.addChild(_btn1);
			//hb.addChild(_btn2);
			//hb.addChild(_btn3); 
			//wd.addChild(hb);
			//wd.setSize(hb.width,hb.height + 20);
			////removeChild(wd);
			var pn:Panel = new Panel(this, 50, 50);
			pn.shadow = false;
			
        }
		
		private function wdhandler(e:Event):void 
		{
			removeChild(wd);
		}
		

		private function handler():void
		{
			trace("hihihi");
		}
    }
}