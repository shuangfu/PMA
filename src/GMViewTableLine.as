package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author fs
	 */
	public class GMViewTableLine extends MovieClip 
	{
		private var forClick:Sprite;
		public var pn:String;
		public function GMViewTableLine(projectName1:String,stationName1:String,delayDays1:String,dutyMan1:String,stageName1:String,process1:String) 
		{
			super();
			pn = projectName1;
			//trace("stst",stationName1);
			(stationName as TextField).text = stationName1;
			(delayDays as TextField).text = delayDays1;
			(dutyMan as TextField).text = dutyMan1;
			(stageName as TextField).text = stageName1;
			(process as TextField).text = process1;
			(projectName as TextField).text = projectName1;
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