package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author fs
	 */
	public class Conv extends MovieClip 
	{
		private var _convData:Object;

		public function Conv() 
		{
			super();

		}
		
		public function get convData():Object 
		{
			return _convData;
		}
		
		public function set convData(value:Object):void 
		{
			_convData = value;
		}
	}

}