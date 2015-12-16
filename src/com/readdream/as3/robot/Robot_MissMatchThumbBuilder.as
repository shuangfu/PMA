package com.readdream.as3.robot 
{
	import com.readdream.as3.miss.matchthumb.Miss_MatchThumb_abstract;
	import com.readdream.as3.miss.Miss_MatchThumb;
	import com.readdream.as3.vo.Vo_Match;
	/**
	 * ...
	 * @author fs
	 */
	public class Robot_MissMatchThumbBuilder
	{
		
		public function Robot_MissMatchThumbBuilder() 
		{
			
		}
		public static function getMissMatchThumbs(dataArr:Array):Array {
			trace("there has " + dataArr.length +" Miss_MatchThumbs");
			var miss_MatchThumbArr:Array = new Array();
			for (var temp:int = 0; temp < dataArr.length; temp++)
			{
				var imgURLArr:Array;
				var tempObj:Object = dataArr[temp];
				imgURLArr = tempObj.picture.split(",");
				var vo:Vo_Match = new Vo_Match();
				vo.picture = imgURLArr;
				vo.matchIcon = tempObj.matchicon;
				vo.matchTitle = tempObj.matchtitle;
				vo.matchComp = tempObj.matchcomp;
				vo.matchType = tempObj.matchtype;
				vo.matchFrom = tempObj.matchfrom;
				vo.matchApplyUsers = tempObj.matchapplyusers;
				vo.matchContent = tempObj.matchcontent;
				vo.matchInformation1 = tempObj.matchinformation1;
				vo.matchInformation2 = tempObj.matchinformation2;
				vo.matchInformation3 = tempObj.matchinformation3;
				vo.matchInformation4 = tempObj.matchinformation4;
				vo.matchInformation5 = tempObj.matchinformation5;
				vo.matchImportant = tempObj.important;
				var tempMatchComp:Miss_MatchThumb_abstract = Robot_MatchThumbFactory.getMatchThumb(vo);
				
				miss_MatchThumbArr.push(tempMatchComp);
			}
			return miss_MatchThumbArr;
		}
		
	}

}