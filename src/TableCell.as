package 
{
	import adobe.utils.CustomActions;
	import flash.display.*;
	import flash.filters.*;
	import flash.text.*;
	/**
	 * ...
	 * @author fs
	 */
	public class TableCell extends Sprite 
	{
		private var _tiWidth:Number;
		private var _tiHeight:Number;
		private var _textSize:Number;
		private var borderShape:Shape;
		private var textField:TextField;
		private var dateText:String;

		private var _theVO:CellVO;
		
		var tempYearStr:String;
		var tempMouthStr:String;
		var tempDateStr:String;
		var tempArr:Array;
		var nowDateStr:String;
		var endDateStr:String;
		var startDateStr:String;
		
		var r:Number;
		var g:Number;
		var b:Number;
				
		var cha :Cha;
		var stripe :Stripe;
		var unbeginDot : UnBeginDot;
		
		var progress:Number;
		//_tiWidth:Number = 80, _tiHeight:Number = 25, _startDate:Date = null, _endDate:Date= null, _completedDate:Date = null
		public function TableCell(_theVO:CellVO, _tiWidth:Number = 80, _tiHeight:Number = 25) 
		{
			
			super();
			this._tiWidth = _tiWidth;
			this._tiHeight = _tiHeight;
			this._theVO = _theVO;

			//this._theVO.endDate = _endDate;
			//this._theVO.startDate = _startDate;
			//this._theVO.comletedDate = _completedDate;
			
			if (_theVO.lable == null) 
			{
				if (this._theVO.comletedDate == null) 
				{
					this._theVO.nowDate = new Date();
				} else {
					this._theVO.nowDate = this._theVO.comletedDate;
				}
				
				calcStatus();
				calcProgress();
				
				showProgress();
				showStatus();
				
				addTextField(endDateStr.substr(0, 4) + "/" +endDateStr.substr(4, 2) + "/" + endDateStr.substr(6, 2));
			} else {
				this._theVO.color = 0xF2F1E1;
				drawBackground();
				drawBorder();
				
				addTextField(this._theVO.lable);
			}
			
			//addTextField("2015/11/17");
			
			//if (this._theVO.comletedDate != null) 
			//{
				//setCompleted();
			//}
			//
			
		}
		
		public function showProgress():void 
		{
			r = 113 + (213 - 113) * progress;
			g = 186 - (186 - 26) * progress;
			b = 235 - (235 - 33) * progress;	
			
			this._theVO.color = int("0x" + r.toString(16) + g.toString(16) + b.toString(16));
			if (this._theVO.status != "UNBEGINNING") 
			{
				if (progress < 0) {
				this._theVO.color = 0xF2F1E1;
				} else if (progress < 0.5) {
					this._theVO.color = 0x71BAEB;
				} else if (progress < 1) 
				{
					this._theVO.color = 0xF3AE0D;
				} else if (progress <= 2) 
				{
					this._theVO.color = 0xFF7575;
				} else if (progress <= 3) {
					this._theVO.color = 0xD81C23;
				} else if (progress <= 4) {
					this._theVO.color = 0x8E1114;
				} else {
					this._theVO.color = 0x530B0D;
				}
			} else {
				this._theVO.color = 0xF2F1E1;
			}
			
			drawBackground();
			drawBorder();
		}
		
		public function showStatus():void 
		{
			if (cha != null && cha.parent != null) 
			{
				this.removeChild(cha);
			}
			if (stripe != null && stripe.parent != null) 
			{
				this.removeChild(stripe);
			}
			if (unbeginDot != null && unbeginDot.parent != null) 
			{
				this.removeChild(unbeginDot);
			}
			if (this._theVO.status == "COMPLETED") 
			{
				cha = new Cha();
				addChild(cha);
			} else if (this._theVO.status == "RUNNING") {
				stripe = new Stripe();
				stripe.x = 0;
				addChild(stripe);
			} else {
				//unbeginDot = new UnBeginDot();
				//addChild(unbeginDot);
			}
			
		}
		
		public function calcStatus():void 
		{
			tempArr = CellVO.getDateString(this._theVO.nowDate);
			tempYearStr = tempArr[0];
			tempMouthStr = tempArr[1];
			tempDateStr = tempArr[2];
			
			nowDateStr = tempYearStr + tempMouthStr + tempDateStr;

			
			tempArr = CellVO.getDateString(this._theVO.endDate);
			tempYearStr = tempArr[0];
			tempMouthStr = tempArr[1];
			tempDateStr = tempArr[2];
			
			endDateStr = tempYearStr + tempMouthStr + tempDateStr;
			
			tempArr = CellVO.getDateString(this._theVO.startDate);
			tempYearStr = tempArr[0];
			tempMouthStr = tempArr[1];
			tempDateStr = tempArr[2];
			
			startDateStr = tempYearStr + tempMouthStr + tempDateStr;
			
			if (this._theVO.comletedDate != null) 
			{
				this._theVO.status = "COMPLETED";
			} else {
				if (SelfDateUtil.manyDayNum(startDateStr, nowDateStr) < 0)
				{
					this._theVO.status = "UNBEGINNING";
				} else {
					this._theVO.status = "RUNNING";
				}
			}
		}
		
		public function calcProgress():void 
		{
			this._theVO.dueTime = SelfDateUtil.manyDayNum(startDateStr, endDateStr);
			this._theVO.leftTime = SelfDateUtil.manyDayNum(nowDateStr, endDateStr);
			
			trace("due", this._theVO.dueTime);
			trace("left",this._theVO.leftTime);
			if (this._theVO.dueTime != 0) 
			{
				progress = 1 - (this._theVO.leftTime * 1.0 / this._theVO.dueTime);
			} else if(this._theVO.leftTime == 0){
				progress = 1;
			}

			trace("progress", progress);
			
		}
		
		public function setCompleted():void 
		{
			this._theVO.status = "COMPLETED";
			showStatus();
			//drawBorder(1);
		}
		
		private function drawBackground(statusFlag:Number = 0):void 
		{
			var sprBackground:Shape = new Shape();			
			sprBackground.graphics.beginFill(this._theVO.color);
			//var tempNumber:Number = this.progress - int(this.progress);
			//var tempWidth:Number = _tiWidth * tempNumber;
			
			sprBackground.graphics.drawRect(0, 0, _tiWidth, _tiHeight);
			sprBackground.graphics.endFill();
			addChild(sprBackground);
			if (statusFlag == 1) 
			{
				var stripe :Stripe = new Stripe();
				stripe.x = 0;
				addChild(stripe);
			}
		}
		
		private function drawBorder(statusFlag:Number = 0):void {
			//draw border
			borderShape = new Shape();
			borderShape.graphics.lineStyle(1, 0x000000, 1, true, LineScaleMode.NONE);
			borderShape.graphics.moveTo(0, 0);
			borderShape.graphics.lineTo(_tiWidth,0);
			borderShape.graphics.lineTo(_tiWidth,_tiHeight);
			borderShape.graphics.lineTo(0,_tiHeight);
			borderShape.graphics.lineTo(0, 0);
			addChild(borderShape);
			//add filter
			//var dropShadow:DropShadowFilter = new DropShadowFilter(1,0,0x080808,0.8,4,4,0.4,1); 
			//var filtersArray:Array = new Array(dropShadow); 
			//borderShape.filters = filtersArray;	
			if (statusFlag != 0) 
			{
				borderShape = new Shape();
				borderShape.graphics.lineStyle(1, 0xFFFFFF, 1, true, LineScaleMode.NONE);
				borderShape.graphics.moveTo(0, 0);
				borderShape.graphics.lineTo(_tiWidth - 1, 0);
				borderShape.graphics.lineTo(_tiWidth - 1, _tiHeight - 1);
				borderShape.graphics.lineTo(0,_tiHeight - 1);
				borderShape.graphics.lineTo(0, 0);
				addChild(borderShape);
			}
		}
		
		private function addTextField(cellText:String):void 
		{
			//text field init
			textField = new TextField();
			textField.selectable = true;
			
			//content type email / password / normal

			var tempTextFormat:TextFormat = Robot_TextFormater.getTextFormat(Robot_TextFormater.CONTENTBAR_MATCHCOMP);
			_textSize = tempTextFormat.size.toString();
			
			//textField.autoSize = TextFieldAutoSize.LEFT;
			textField.autoSize = TextFieldAutoSize.NONE;
			
			//textField.maxChars = Math.floor((_tiWidth - 10) / _textSize * 2);
			//trace(textField.maxChars);
			textField.multiline = false;
			textField.type = TextFieldType.DYNAMIC;

			
			textField.border = true;
			
			
			
			if (this._theVO.comletedDate == null && this._theVO.leftTime <= this._theVO.dueTime) {
				textField.text = SelfDateUtil.manyDayNum(nowDateStr, endDateStr).toString();
			} else {
				textField.text = cellText;
			}
			if (this._theVO.lable != null) 
			{
				textField.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.TABBAR_TEXT));
			} else {
				if (this._theVO.status != "UNBEGINNING") 
				{
					textField.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.CONTENTBAR_MATCHCOMP));
				} else {
					textField.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.CONTENTBAR_MATCHCONTENT));
				}
			}
			
			
			textField.width = _tiWidth - 10;
			textField.height = _textSize + 4;
			textField.y = (_tiHeight - textField.height) / 2;
			textField.x = (_tiWidth - textField.width) / 2;
			addChild(textField);
			
			//init text style
		}
		//public function getDays():Number {
			//
		//}
		
		public function get tiWidth():Number 
		{
			return _tiWidth;
		}
		
		public function set tiWidth(value:Number):void 
		{
			_tiWidth = value;
		}
		
		public function get tiHeight():Number 
		{
			return _tiHeight;
		}
		
		public function set tiHeight(value:Number):void 
		{
			_tiHeight = value;
		}
		
		public function get theVO():CellVO 
		{
			return _theVO;
		}
		
		public function set theVO(value:CellVO):void 
		{
			_theVO = value;
		}
		
		public function get textSize():Number 
		{
			return _textSize;
		}
		
		public function set textSize(value:Number):void 
		{
			_textSize = value;
		}
		
		
	}

}