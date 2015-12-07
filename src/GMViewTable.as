package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author fs
	 */
	public class GMViewTable extends MovieClip 
	{
		public var pn:String;
		private var forClick:Sprite;
		public function GMViewTable(overViewTableVO:Object,tableClickHandler) 
		{
			super();
			for (var i:int = 0; i < (overViewTableVO["lineArr"] as Array).length; i++) 
			{
				var tableLine:GMViewTableLine = new GMViewTableLine(overViewTableVO["lineArr"][i]["projectName"],overViewTableVO["lineArr"][i]["stationName"], overViewTableVO["lineArr"][i]["delayDays"], overViewTableVO["lineArr"][i]["dutyMan"], overViewTableVO["lineArr"][i]["stageName"], overViewTableVO["lineArr"][i]["process"] + "%");
				addChild(tableLine);
				tableLine.addEventListener(MouseEvent.CLICK,tableClickHandler)
				tableLine.x = 0;
				tableLine.y = 25 + i * 25;
			}
			
		}
		
	}

}