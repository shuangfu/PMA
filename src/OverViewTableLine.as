package 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author fs
	 */
	public class OverViewTableLine extends MovieClip 
	{

		public function OverViewTableLine(stationName1:String,delayDays1:String,dutyMan1:String,stageName1:String,process1:String) 
		{
			super();
			//trace("stst",stationName1);
			(stationName as TextField).text = stationName1;
			(delayDays as TextField).text = delayDays1;
			(dutyMan as TextField).text = dutyMan1;
			(stageName as TextField).text = stageName1;
			(process as TextField).text = process1;
		}
		
	}

}