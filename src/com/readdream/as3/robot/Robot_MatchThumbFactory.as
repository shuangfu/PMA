package com.readdream.as3.robot
{
	import com.readdream.as3.miss.contentbar.Miss_ContentBar;
	import com.readdream.as3.miss.matchthumb.Miss_MatchThumb_abstract;
	import com.readdream.as3.miss.matchthumb.Miss_MatchThumb_Abstract;
	import com.readdream.as3.miss.matchthumb.Miss_MatchThumb_Big;
	import com.readdream.as3.miss.matchthumb.Miss_MatchThumb_Small;
	import com.readdream.as3.miss.Miss_Button;
	import com.readdream.as3.vo.Vo_Match;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	
	/**
	 * ...
	 * @author evstar
	 */
	public class Robot_MatchThumbFactory extends Sprite    
	{
		public var btn:Miss_Button;
		
		public function Robot_MatchThumbFactory()
		{
			
		}
		public static function getMatchThumb(vo:Vo_Match):Miss_MatchThumb_Abstract {
			var bmpData:BitmapData = new BitmapData(1, 1);
			var returnValue:Miss_MatchThumb_Abstract;
			if (vo.matchImportant == 1) {
				returnValue = new Miss_MatchThumb_Big(vo);
				returnValue.scrollRect = new Rectangle(0, 0, 480, 400);
				//btn = tempThumb_small.btnCheckIn;
				bmpData.draw(returnValue);
			} else {
				returnValue = new Miss_MatchThumb_Small(vo);
				returnValue.scrollRect = new Rectangle(0, 0, 240, 200);
				//btn = tempThumb_small.btnCheckIn;
				bmpData.draw(returnValue);
			}
			return returnValue;
		}
	}

}