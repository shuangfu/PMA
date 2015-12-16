package com.readdream.as3.mr 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author fs
	 */
	public class Mr_Lable 
	{
		
		public function Mr_Lable() 
		{
			
		}
		public static function getLable(lableText:String,lableFormat:TextFormat):TextField {
			var returnTF:TextField = new TextField();
			returnTF.text = lableText;
			returnTF.autoSize = TextFieldAutoSize.LEFT;
			returnTF.selectable = false;
			returnTF.setTextFormat(lableFormat);
			returnTF.defaultTextFormat = lableFormat;
			return returnTF;
		}
	}

}