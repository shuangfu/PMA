package com.readdream.as3.miss.matchthumb
{
	import com.greensock.TweenLite;
	import com.readdream.as3.miss.Miss_Button;
	import com.readdream.as3.mr.Mr_Dresser;
	import com.readdream.as3.mr.Mr_Lable;
	import com.readdream.as3.mr.Mr_Layouter;
	import com.readdream.as3.robot.Robot_PicLoader;
	import com.readdream.as3.robot.Robot_TextFormater;
	import com.readdream.as3.vo.Vo_Match;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author evstar
	 */
	public class Miss_MatchThumb_Small extends Miss_MatchThumb_Abstract
	{
		private const defaultBackground:uint = 0xF8F8F8; //默认背景颜色
		private const activateBackground:uint = 0xECECEC; //激活背景颜色
		private const lineColorNormal:uint = 0xffffff;
		private const lineColorDark:uint = 0xf8f8f8;
		private const sizeWidth:Number = 240; //容器宽度
		private const sizeHeight:Number = 200; //容器高度
		public const compPicWidth:Number = 220; //小图片 宽度
		public const compPicHeight:Number = 140; //小图片 高度
		
		private var matchName:TextField;
		private var matchName2:TextField;
		private var matchDiscription:TextField;
		private var matchIcon:Robot_PicLoader;
		private var matchSponsor:TextField;
		private var matchSponsor2:TextField;
		private var matchPost:Sprite;
		private var sprMatchComp:Sprite;
		private var sprContent:Sprite = new Sprite();
		private var lineDown:Sprite;
		private var lineUp:Sprite;
		private var btnCheckIn:Miss_Button;
		
		private var container:Sprite;
		
		private var motionDownCompletedFlag:Boolean = true;
		
		public function Miss_MatchThumb_Small(vo:Vo_Match)
		{
			super(vo)		
			setupUIAssets();
			placeElements();
			this.addEventListener(Event.ADDED_TO_STAGE,setupEvent);
		}
		
		private function setupEvent(e:Event):void 
		{
			this.addEventListener(MouseEvent.ROLL_OVER, MouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, MouseRollOutHandler);
		}
		
		private function setupUIAssets():void
		{
			this.graphics.beginFill(defaultBackground);
			this.graphics.drawRect(0,0,sizeWidth,sizeHeight);
			this.graphics.endFill();
			
			matchName = Mr_Lable.getLable(vo.matchTitle,Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHTITLE));		
			matchName2 = Mr_Lable.getLable(vo.matchTitle,Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHTITLE));
			matchSponsor = Mr_Lable.getLable(vo.matchFrom,Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHFROM));
			matchSponsor2 = Mr_Lable.getLable(vo.matchFrom,Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHFROM));
			matchDiscription = Mr_Lable.getLable(vo.matchComp.slice(0, 70),Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHCOMP));		
			matchDiscription.wordWrap = true;
			matchDiscription.width = 210;
			matchIcon = new Robot_PicLoader(vo.matchIcon, 0, 0, 40, 40);
			matchPost = new Robot_PicLoader(vo.picture[0], 0, 0, compPicWidth - 1, compPicHeight - 1), 0xDDDDDD, 1, false;
			
			lineUp = new Sprite();
			lineUp.graphics.lineStyle(lineColorNormal);
			lineUp.graphics.lineTo(sizeWidth,0);
			
			lineDown = new Sprite();
			lineDown.graphics.lineStyle(lineColorDark);
			lineDown.graphics.lineTo(sizeWidth, 0);
			//btnCheckIn = new Miss_Button("报名", 140, 25);
			container = new Sprite();
		}
	
		
		private function placeElements():void
		{
			var objArr:Array = new Array();
			objArr.push({stuff: matchPost, xPos: 10, yPos: 10});
			objArr.push({stuff: matchName, xPos: 20, yPos: 160})
			objArr.push({stuff: matchSponsor, xPos: 20, yPos: 160 + matchName.textHeight + 5});
			objArr.push({stuff: matchName2, xPos: 20, yPos: 225});
			objArr.push({stuff: matchSponsor2, xPos: 20, yPos: 225 + matchName2.textHeight + 10});
			objArr.push({stuff: matchIcon, xPos: 180, yPos: 225});
			objArr.push( { stuff: matchDiscription, xPos: 18, yPos: 290 } );
			objArr.push({stuff:lineUp,xPos:0,yPos:0});
			objArr.push({stuff:lineDown,xPos:0,yPos:199});
			//objArr.push( { stuff: btnCheckIn, xPos:50, yPos:365 } );
			Mr_Layouter.layouter(container, objArr);
			addChild(container);
		}

		private function MouseRollOverHandler(e:MouseEvent):void
		{
			lineUp.graphics.lineStyle(lineColorDark);
			lineUp.graphics.moveTo(0,0);
			lineUp.graphics.lineTo(sizeWidth,0);
			if (motionUPCompletedFlag) 
			{
				TweenLite.to(container, 0.3, {y:-(sizeHeight - 1),delay:0.3,onStart:onStart});
			} else {
				TweenLite.to(container, 0.3, {y:-(sizeHeight - 1)});
			}
		}
		
		private function motionDownComplete():void 
		{
			motionUPCompletedFlag = true;
			
			this.graphics.beginFill(defaultBackground);
			this.graphics.drawRect(0, 0, 240, 200);
			this.graphics.endFill();
		}
		
		private function onStart():void 
		{
			this.graphics.beginFill(activateBackground);
			this.graphics.drawRect(0, 0, 240, 200);
			this.graphics.endFill();
		}
		
		private function MouseRollOutHandler(e:MouseEvent):void 
		{
			lineUp.graphics.lineStyle(lineColorNormal);
			lineUp.graphics.moveTo(0,0);
			lineUp.graphics.lineTo(sizeWidth, 0);
			
			
			TweenLite.to(container, 0.3, { y:0,onComplete:motionDownComplete} } );
		}
	}

}
