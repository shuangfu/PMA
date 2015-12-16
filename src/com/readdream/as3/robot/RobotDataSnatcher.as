package com.readdream.as3.robot 
{
	import com.adobe.serialization.json.JSON;
	/**
	 * ...
	 * @author fs
	 */
	public class RobotDataSnatcher 
	{
		private var urlStr:String;
		private var sendObj:Array;
		private var receiveObj:Array;
		private var callBackFunc:Function;
		public function RobotDataSnatcher(urlStr:String,callBackFunc:Function,sendObj:Array = null) 
		{
			this.callBackFunc = callBackFunc;
			this.sendObj = callBackFunc;
			this.urlStr = urlStr;
			var jsonString : String = JSON.encode(sendObj);
			
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.json = jsonString;
			var urlRequest:URLRequest = new URLRequest(urlStr); //接收数据。         
			urlRequest.method = URLRequestMethod.POST;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.load(urlRequest);//这里是你要获取JSON的路径
			urlLoader.addEventListener(Event.COMPLETE, decodeJSONHandler);
		}
		private function decodeJSONHandler(event:Event):void {
			var receiveObj:Array = JSON.decode(URLLoader(event.target).data );
         //获取数组中存储的数据
			//for (var i=0; i<jsonArray.length; i++) {
				//trace( jsonArray[i].type );
			//}
			callBackFunc.call(receiveObj);
		}
	}

}