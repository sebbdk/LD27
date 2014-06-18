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
	import Anim.StartGame;
	
	import dk.sebb.tiled.Level;
	import dk.sebb.util.Key;
	
	[SWF(backgroundColor="#999999", frameRate="60", height="600", width="800", quality="HIGH")]
	public class Main extends Sprite
	{
		public var levelindex:int = -1;
		public var level:Level;
		public var levels:Array = [
			'../../levels/level01/'
		];
	
		public static var healthbar:MovieClip;
		public static var gameOver:MovieClip;
		public static var counter:MovieClip;
		public static var starSplash:MovieClip;
		
		public static var UI:MovieClip;
		
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
			
			counter = new Anim.Counter();
			counter.x = stage.stageWidth - counter.width - 20;
			counter.y = 20;
			
			starSplash = new StartGame();
			starSplash.x = stage.stageWidth/2;
			starSplash.y = stage.stageHeight/2;
			starSplash.scaleX = 4;
			starSplash.scaleY = 4;
			starSplash.useHandCursor = true;
			starSplash.buttonMode = true;
			starSplash.addEventListener(MouseEvent.CLICK, restartLevel);

			UI = new MovieClip();
			UI.addChild(counter);
			UI.addChild(healthbar);
			addChild(UI);
			UI.visible = false;
			
			addChild(starSplash);
		} 
		
		public function restartLevel(evt:Event):void {
			starSplash.visible = false;
			gameOver.visible = false;
			UI.visible = true;
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