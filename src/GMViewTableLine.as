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
		private var _theVO:Object = new Object();
		public function GMViewTableLine(projectName1:String,stationName1:String,delayDays1:String,dutyMan1:String,stageName1:String,process1:String) 
		{
			super();
			
			if (Number(process1) < 0) {
				this._theVO.color = 0x93FF93;
				} else if (Number(process1) < 50) {
					this._theVO.color = 0x71BAEB;
				} else if (Number(process1) < 100) 
				{
					this._theVO.color = 0xF3AE0D;
				} else if (Number(process1) <= 200) 
				{
					this._theVO.color = 0xFF7575;
				} else if (Number(process1) <= 300) {
					this._theVO.color = 0xD81C23;
				} else if (Number(process1) <= 400) {
					this._theVO.color = 0x8E1114;
				} else {
					this._theVO.color = 0x530B0D;
				}

				(delayDays as TextField).background = true;
				(delayDays as TextField).backgroundColor = this._theVO.color;
				(stationName as TextField).background = true;
				(stationName as TextField).backgroundColor = this._theVO.color;
				trace("延期");

			//trace("stst",stationName1);
			(stationName as TextField).text = stationName1;
			(delayDays as TextField).text = delayDays1;
			(dutyMan as TextField).text = dutyMan1;
			(stageName as TextField).text = stageName1;
			
			(process as TextField).text = process1 + "%";
			
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