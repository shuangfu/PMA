package com.readdream.as3.miss.matchthumb 
{
	import com.readdream.as3.vo.Vo_Match;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author fs
	 */
	public class Miss_MatchThumb_Abstract extends Sprite 
	{
		protected var _vo:Vo_Match;
		public function Miss_MatchThumb_Abstract(vo:Vo_Match) 
		{
			this._vo = vo;
		}
		
		public function get vo():Vo_Match 
		{
			return _vo;
		}
		
		public function set vo(value:Vo_Match):void 
		{
			_vo = value;
		}
		
	}

}