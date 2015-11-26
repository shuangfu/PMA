package 
{
	import com.adobe.serialization.json.JSON;  
   
 import flash.display.Sprite;  
 import flash.events.Event;  
 import flash.net.URLLoader;  
 import flash.net.URLRequest;  
	/**
	 * ...
	 * @author fs
	 */
	public class GetJSON 
	{
		
		public function GetJSON() 
		{
			var loader:URLLoader = new URLLoader();  
   
		   loader.load(new URLRequest( "http://127.0.0.1:8010/getData" ));//这里是你要获取JSON的路径  
		   loader.addEventListener(Event.COMPLETE, decodeJSON);  
		}
		 private function decodeJSON(evt:Event):void {  
		   var persons:Object = JSON.decode( URLLoader( evt.target ).data );  
		   //在这里，就可以通过操作数组来应用数据了，很方便  
		   trace( persons["tableHeadArr"][0]);  
		   
		  }  
		
	}

}