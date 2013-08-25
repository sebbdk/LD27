package dk.sebb.util
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class Key
	{
		private static var heldKeys:Array = [];
		private static var keyUpRecord:Array = [];
		private static var keyDownRecord:Array = [];
		
		private static var keyMap:Array = [];
		
		public static var stage:Stage;
		public static var _instance:Key;
		
		public static function get instance():Key {
			if(!_instance) {
				throw new Error('The KeyMap Class has not been initiated with a stage reference!');
			}
			
			return _instance;
		}
		
		public static function init(_stage:Stage):void {
			if(!_instance) {//ignore multiple calls
				stage = _stage;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				_instance = new Key();
			}
		}
		
		public static function isDown(keyCode:int):Boolean {
			return heldKeys[keyCode] === true;
		}
		
		private static function onKeyDown(evt:KeyboardEvent):void {
			heldKeys[evt.keyCode] = true;
			
			//record when the key was pressed down
			var myDate:Date = new Date();
			var currentTime:int = Math.round(myDate.getTime());
			keyDownRecord[currentTime] = evt.keyCode;
		}
		
		private static function onKeyUp(evt:KeyboardEvent):void {
			heldKeys[evt.keyCode] = false;
			
			//record when the key was pressed up
			var myDate:Date = new Date();
			var currentTime:int = Math.round(myDate.getTime());
			keyUpRecord[currentTime] = evt.keyCode;
		}
	}
}