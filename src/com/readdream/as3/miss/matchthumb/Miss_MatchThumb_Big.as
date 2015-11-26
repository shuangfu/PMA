package com.readdream.as3.miss.matchthumb
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.readdream.as3.miss.Miss_Arrow;
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
	public class Miss_MatchThumb_Big extends Miss_MatchThumb_Abstract
	{
		private const defaultBackground:uint = 0xF8F8F8; //默认背景颜色
		private const activateBackground:uint = 0xECECEC; //激活背景颜色
		private const SprCompHeight:Number = 100;
		private const compPicWidth:Number = 460; //大图片 宽度
		private const compPicHeight:Number = 340; //小图片 高度	
		private const sizeWidth:Number = 480;
		private const sizeHeight:Number = 400;
		private const matchTitleX:Number = 15;
		private const matchTitleY:Number = 360
		private const SprCompY:Number = 350;
		
		private var matchName:TextField;
		private var matchDiscription:TextField;
		private var matchSponsor:TextField;
		private var postArr:Array = new Array();
		private var index:int = 0;
		private var masker:Sprite;
		private var sprLine:Shape = new Shape;
		private var sprComp:Sprite = new Sprite();
		private var sprPic:Sprite = new Sprite();
		private var sprPicContainer:Sprite = new Sprite();
		private var maskerInfo:Sprite;
		private var sprInfo:Sprite = new Sprite();
		private var theArrows:Miss_Arrow;

		private var btnCheckIn:Miss_Button;
		
		private var lineUp:Sprite;
		private var mainContainer:Sprite;
		private var bottomContainer:Sprite;
		
		private var motionDownCompletedFlag:Boolean = true;

				
		public function Miss_MatchThumb_Big(vo:Vo_Match)
		{

			//this.opaqueBackground = 0xff00ff;
			super(vo);
			setupUIAssets();
			placeElements();
			this.addEventListener(Event.ADDED_TO_STAGE,setupEvent);

		}
		
		private function setupUIAssets():void
		{
			postArr[index] = new Robot_PicLoader(vo.picture[index], 0, 0, compPicWidth - 1, compPicHeight - 1);

			matchName = Mr_Lable.getLable(vo.matchTitle,Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHTITLE));
			matchSponsor = Mr_Lable.getLable(vo.matchFrom,Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHFROM));
			matchDiscription = Mr_Lable.getLable(vo.matchComp.slice(0, 75),71 Robot_TextFormater.getTextFormat(Robot_TextFormater.MATCHTHUMB_MATCHCOMP);
			matchDiscription.wordWrap = true;
			matchDiscription.width = 455;
			
			bottomContainer = new Sprite();
			bottomContainer.graphics.beginFill(defaultBackground);
			bottomContainer.graphics.drawRect(0, 0, 478, 100);
			bottomContainer.graphics.endFill();

			mainContainer = new Sprite();
			
			theArrows = new Miss_Arrow(0, ((290 - Miss_Arrow.arrowHeight) / 2), masker.width - 24, (290 - Miss_Arrow.arrowHeight) / 2);
			theArrows.leftNoSelect.visible = false;
			theArrows.rightNoSelect.visible = false;
			theArrows.leftSelect.x -= 1;
			
			lineUp = new Sprite();
			lineUp.graphics.lineStyle(lineColorNormal);
			lineUp.graphics.lineTo(sizeWidth,0);
			
			//btnCheckIn = new Miss_Button("报名", 140, 25);
			this.graphics.beginFill(defaultBackground);
			this.graphics.drawRect(0,0,sizeWidth,sizeHeight);
			this.graphics.endFill();
		}
		
		private function placeElements():void
		{
			var objComp:Array = new Array();
			objComp.push({stuff: matchName, xPos: matchTitleX, yPos: 10})
			objComp.push({stuff: matchSponsor, xPos: matchTitleX, yPos: 10 + matchName.textHeight + 5});
			objComp.push({ stuff: matchDiscription, xPos: matchTitleX, yPos: 10 + matchName.textHeight + matchSponsor.height + 15 } );
			//objComp.push({ stuff:btnCheckIn, xPos:300, yPos:10 } );
			Mr_Layouter.layouter(bottomContainer, objComp);
			
			masker = Mr_Dresser.getMasker(460, 340);
			masker.x = masker.y = 10;
			
			mainContainer.addChild(postArr[index]);
			mainContainer.addChild(theArrows);
			//btnCheckIn.visible = false;
			mainContainer.mask = masker;
			this.addChild(mainContainer);
			this.addChild(masker);
			this.addChild(bottomContainer);
			this.addChild(lineUp);
		}
		
		private function setupEvent(e:Event):void 
		{
			this.addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			theArrows.leftSelect.addEventListener(MouseEvent.CLICK, leftMouseClickHandler);
			theArrows.rightSelect.addEventListener(MouseEvent.CLICK, rightMouseClickHandler);	
		}
		
		private function mouseRollOverHandler(e:MouseEvent):void	
		{
			theArrows.leftNoSelect.visible = true;
			theArrows.rightNoSelect.visible = true;
			theArrows.leftNoSelect.x -= 24;
			theArrows.rightNoSelect.x += 24;
			
			lineUp.graphics.lineStyle(lineColorDark);
			lineUp.graphics.moveTo(0,0);
			lineUp.graphics.lineTo(sizeWidth,0);
			if (motionUPCompletedFlag) 
			{
				TweenLite.to(bottomContainer, 0.3, {y:compPicHeight - 10 - 35,delay:0.3,onStart:onStart,onComplete:onMoveCompleteHandler});
			} else {
				TweenLite.to(bottomContainer, 0.3, {y:compPicHeight - 10 - 35,onComplete:onMoveCompleteHandler});
			}
		}
		
		private function onMoveCompleteHandler():void
		{
			TweenLite.to(theArrows.leftNoSelect, 0.15, {x: -1});
			TweenLite.to(theArrows.rightNoSelect, 0.15, {x: (masker.width - Miss_Arrow.arrowWidth)});
		}
		
		private function onStart():void
		{
			this.graphics.beginFill(activateBackground);
			this.graphics.drawRect(0, 0, 480, 400);
			this.graphics.endFill();
			bottomContainer.graphics.beginFill(activateBackground);
			bottomContainer.graphics.drawRect(0, 0, 480, 100);
			bottomContainer.graphics.endFill();
		}
		
		private function mouseRollOutHandler(e:MouseEvent):void
		{
			TweenLite.to(theArrows.leftNoSelect, 0.15, {x: -24,overwrite:true});
			TweenLite.to(theArrows.rightNoSelect, 0.15, {x: (masker.width), onComplete: onRollOutCompleteHandler,overwrite:true});
			TweenLite.to(bottomContainer, 0.3, {y:compPicHeight - 10 - 35, onComplete:motionDownComplete});
		}
		
		private function motionDownComplete():void 
		{
			motionUPCompletedFlag = true;
			lineUp.graphics.lineStyle(lineColorNormal);
			lineUp.graphics.moveTo(0,0);
			lineUp.graphics.lineTo(sizeWidth, 0);
			this.graphics.beginFill(defal);
			this.graphics.drawRect(0, 0, 480, 400);
			this.graphics.endFill();
			bottomContainer.graphics.beginFill(defaultBackground);
			bottomContainer.graphics.drawRect(0, 0, 480, 100);
			bottomContainer.graphics.endFill();
		}
		
		private function rightMouseClickHandler(e:MouseEvent):void
		{
			rightMove();
		}
		
		private function leftMouseClickHandler(e:MouseEvent):void
		{
			leftMove();
		}

		private function leftMove():void
		{
			theArrows.leftSelect.removeEventListener(MouseEvent.CLICK, leftMouseClickHandler);
			theArrows.rightSelect.removeEventListener(MouseEvent.CLICK, rightMouseClickHandler);
			index--;
			if (index < 0)
			{
				index = vo.picture.length - 1;				
			}
			
			if (postArr[index] == null)
			{
				postArr[index] = Mr_Dresser.drawBorder(new Robot_PicLoader(vo.picture[index], 0, 0, compPicWidth - 1, compPicHeight - 1), 0xDDDDDD, 1, false)
				postArr[index].x = -460;
				postArr[index].y = 0;
				sprPic.addChildAt(postArr[index],0);
			}
			else
			{
				postArr[index].x = -460;
				postArr[index].y = 0;
			}
			TweenLite.to(postArr[(index + 1) % vo.picture.length], 0.5, {x: 460});
			TweenLite.to(postArr[index], 0.5, {x: 0, onComplete: onCompleteMoveHandler});
		
		}
		
		private function rightMove():void
		{
			theArrows.leftSelect.removeEventListener(MouseEvent.CLICK, leftMouseClickHandler);
			theArrows.rightSelect.removeEventListener(MouseEvent.CLICK, rightMouseClickHandler);
			index++;
			index = index % vo.picture.length;
			
			if (postArr[index] == null)
			{
				postArr[index] = Mr_Dresser.drawBorder(new Robot_PicLoader(vo.picture[index], 0, 0, compPicWidth - 1, compPicHeight - 1), 0xDDDDDD, 1, false)
				postArr[index].x = 460;
				postArr[index].y = 0;
				sprPic.addChildAt(postArr[index % vo.picture.length],0);
			}
			else
			{
				postArr[index].x = 460;
				postArr[index].y = 0;
			}
			
			TweenLite.to(postArr[index], 0.5, {x: 0, y: 0, onComplete: onCompleteMoveHandler});
			if (index == 0)
			{
				TweenLite.to(postArr[(vo.picture.length - 1)], 0.5, {x: -460, y: 0});
			}
			else
			{
				TweenLite.to(postArr[index - 1], 0.5, {x: -460, y: 0});
			}
		}
		
		private function onCompleteMoveHandler():void
		{
			theArrows.leftSelect.addEventListener(MouseEvent.CLICK, leftMouseClickHandler);
			theArrows.rightSelect.addEventListener(MouseEvent.CLICK, rightMouseClickHandler);
		}
	
	}

}