package 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author fs
	 */
	public class StageInfoPanel extends MovieClip 
	{
		
		public function StageInfoPanel() 
		{
			super();
			
		}
		public function setProgressColor():void {
			//(progress as TextField).border = true;
			(progress as TextField).setTextFormat(Robot_TextFormater.getTextFormat(Robot_TextFormater.STATUSBAR_LOGINTEXT));
			(progress as TextField).defaultTextFormat = Robot_TextFormater.getTextFormat(Robot_TextFormater.STATUSBAR_LOGINTEXT);
		}
	}

}