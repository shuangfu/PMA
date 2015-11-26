package 
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	/**
	 * ...
	 * @author fs
	 */
	public class NewCell extends MovieClip 
	{
		private var _lable:String;
		private var _projectBelong:String;
		private var _stationBelong:String;
		private var _percent:Number;
		private var _statusFlag:String;
		
		private var _tiWidth:Number;
		private var _tiHeight:Number;
		private var _textSize:Number;
		private var borderShape:Shape;
		private var textField:TextField;
		private var dateText:String;
		
		
		var cha :Cha;
		var stripe :Stripe;
		private var _theVO:NewCellVO;

		public function NewCell(_theVO:NewCellVO, _tiWidth:Number = 80, _tiHeight:Number = 25) 
		{
			super();
			this._tiWidth = _tiWidth;
			this._tiHeight = _tiHeight;
			this._theVO = _theVO;
			trace("init Cell:", _theVO.projectBelong, "|", _theVO.stationBelong, "|", _theVO.stageNum);
			drawBackground(this._theVO.statusFlag);
			drawBorder(this._theVO.statusFlag);
			addTextField(_theVO.lable);
			drawStatus(this._theVO.statusFlag);
		}
		
 		private function drawStatus(statusFlag:String):void {
			if (statusFlag == "COMPLETED") 
			{
				cha = new Cha();
				addChild(cha);
			} else if (statusFlag == "RUNNING") {
				stripe = new Stripe();
				stripe.x = 0;
				addChild(stripe);
			} else {
				//unbeginDot = new UnBeginDot();
				//addChild(unbeginDot);
			}
		}
		private function addTextField(cellText:String):void 
		{
			textField = new TextField();
			textField.selectable = false;
			

			var tempTextFormat:TextFormat = Robot_TextFormater.getTextFormat(Robot_TextFormater.CONTENTBAR_MATCHCOMP);
			_textSize = tempTextFormat.size.toString();
			
			textField.autoSize = TextFieldAutoSize.NONE;
			
			textField.multiline = false;
			textField.type = TextFieldType.DYNAMIC;
			textField.border = false;

			textField.text = cellText;
			
			if (this._theVO.statusFlag == "TEXT") 
			{
				textField.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.TABBAR_TEXT));
			} else {
				textField.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.CONTENTBAR_MATCHCONTENT));
			}
			if (Number(this._theVO.percent) >= 1) 
			{
				textField.setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.CONTENTBAR_MATCHCOMP));
			}
						
			textField.width = _tiWidth - 10;
			textField.height = _textSize + 4;
			textField.y = (_tiHeight - textField.height) / 2;
			textField.x = (_tiWidth - textField.width) / 2;
			addChild(textField);
		}
		private function drawBackground(statusFlag:String):void 
		{
			var sprBackground:Shape = new Shape();			
			var tempColor:Number;
			if (this._theVO.statusFlag != "TEXT") {
				if (this._theVO.statusFlag == "UNBEGINNING") 
				{
					tempColor = 0xFFF9C1;
				}else {
					if (this._theVO.percent < 0) {
					tempColor = 0xF2F1E1;
					} else if (this._theVO.percent < 0.5) {
						tempColor = 0x71BAEB;
					} else if (this._theVO.percent < 1){
						tempColor = 0xF3AE0D;
					} else if (this._theVO.percent <= 2) {
						tempColor = 0xFF7575;
					} else if (this._theVO.percent <= 3) {
						tempColor = 0xD81C23;
					} else if (this._theVO.percent <= 4) {
						tempColor = 0x8E1114;
					} else {
						tempColor = 0x530B0D;
					}
				}
			
			} else {
				tempColor = 0xECF3F3;
			}
			sprBackground.graphics.beginFill(tempColor);
			//var tempNumber:Number = this.progress - int(this.progress);
			//var tempWidth:Number = _tiWidth * tempNumber;
			
			sprBackground.graphics.drawRect(0, 0, _tiWidth, _tiHeight);
			sprBackground.graphics.endFill();
			addChild(sprBackground);
		}

		public function drawBorder(statusFlag:String):void {
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
			
		}
		public function get theVO():NewCellVO 
		{
			return _theVO;
		}
		
		public function set theVO(value:NewCellVO):void 
		{
			_theVO = value;
		}
		
	}

}