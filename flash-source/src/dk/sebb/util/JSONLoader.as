package dk.sebb.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class JSONLoader extends EventDispatcher
	{
		protected var loader:URLLoader;
		protected var path:String;
		public var data:Object;
		
		public function JSONLoader(path:String) {
			this.path = path;
		}
		
		public function load():void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onJSONLoaded);
			loader.load(new URLRequest(path));
		}
		
		public function onJSONLoaded(evt:Event):void {
			loader.removeEventListener(Event.COMPLETE, onJSONLoaded);

			data = JSON.parse(evt.target.data);
			dispatchEvent(evt);
		}
	}
}