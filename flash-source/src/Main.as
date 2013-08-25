package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import dk.sebb.tiled.Level;
	import dk.sebb.util.Key;
	
	[SWF(backgroundColor="#999999", frameRate="60", height="800", width="1200", quality="HIGH")]
	public class Main extends Sprite
	{
		public var levelindex:int = -1;
		public var level:Level;
		public var levels:Array = [
			'../levels/test_level/'/////MAKE MORE LEVELS!
		];
	
/**
 * Load the first level right away!
 */
		public function Main()
		{
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			Key.init(stage);
			level = new Level();
			addChild(level);
			
			loadNextLevel();
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		} 

/**
 * Loads the next level
 * @return void
 */
		public function loadNextLevel():void {
			if(levels[levelindex+1]) {
				levelindex++;
				level.unload();
				level.load(levels[levelindex]);
			}
		}
/**
 * Loads the previous level
 * @return void
 */		
		public function loadPrevLevel():void {
			if(levels[levelindex-1]) {
				levelindex--;
				level.unload();
				level.load(levels[levelindex]);
			}
		}

/**
 * handle keyboard input, we want to be abel to swap levels with shift+arrows
 * @param  evt KeyboardEvent
 * @return void
 */
		public function onKeyUp(evt:KeyboardEvent):void {
			if(evt.keyCode === Keyboard.RIGHT && evt.shiftKey) {
				loadNextLevel();
			}
			
			if(evt.keyCode === Keyboard.LEFT && evt.shiftKey) {
				loadPrevLevel();
			}		
		}
	}
}