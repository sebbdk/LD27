package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import Anim.Counter;
	import Anim.Gameover;
	
	import dk.sebb.tiled.Level;
	import dk.sebb.util.Key;
	
	[SWF(backgroundColor="#999999", frameRate="60", height="600", width="800", quality="HIGH")]
	public class Main extends Sprite
	{
		public var levelindex:int = -1;
		public var level:Level;
		public var levels:Array = [
			'../levels/test_level/'
		];
	
		public static var healthbar:MovieClip;
		public static var gameOver:MovieClip;
		public static var counter:MovieClip;
		
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
			
			gameOver = new Anim.Gameover();
			gameOver.x = stage.stageWidth/2;
			gameOver.y = stage.stageHeight/2;
			gameOver.scaleX = 4;
			gameOver.scaleY = 4;
			gameOver.useHandCursor = true;
			gameOver.buttonMode = true;
			gameOver.visible = false;
			gameOver.addEventListener(MouseEvent.CLICK, restartLevel);
			addChild(gameOver);
			
			healthbar = new MovieClip();
			healthbar.y = 90;
			healthbar.x = stage.stageWidth - 220;
			addChild(healthbar);
			
			counter = new Anim.Counter();
			counter.x = stage.stageWidth - counter.width - 20;
			counter.y = 20;
			addChild(counter);
		} 
		
		public function restartLevel(evt:Event):void {
			gameOver.visible = false;
			level.unload();
			level.load(levels[levelindex]);
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