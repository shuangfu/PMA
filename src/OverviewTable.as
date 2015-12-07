package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author fs
	 */
	public class OverviewTable extends MovieClip 
	{
		public var pn:String;
		private var forClick:Sprite;
		public function OverviewTable(overViewTableVO:Object) 
		{
			super();
			pn = overViewTableVO["projectName"];
			(projectName as TextField).text = pn;
			for (var i:int = 0; i < (overViewTableVO["lineArr"] as Array).length; i++) 
			{
				var tableLine:OverViewTableLine = new OverViewTableLine(overViewTableVO["lineArr"][i]["stationName"], overViewTableVO["lineArr"][i]["delayDays"], overViewTableVO["lineArr"][i]["dutyMan"], overViewTableVO["lineArr"][i]["stageName"], overViewTableVO["lineArr"][i]["process"] + "%");
				addChild(tableLine);
				tableLine.x = 0;
				tableLine.y = 50 + i * 25;
			}
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
			forClick = new Sprite();
			forClick.graphics.beginFill(0xff0000,0);
			forClick.graphics.drawRect(0, 0, this.width, this.height);
			forClick.graphics.endFill();
			this.addChild(forClick);
		}
		
	}

}