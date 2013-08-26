package dk.sebb.tiled
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import dk.sebb.tiled.layers.Layer;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.Bullet;
	import dk.sebb.tiled.mobs.Mob;
	import dk.sebb.tiled.mobs.creatures.NPC;
	import dk.sebb.tiled.mobs.creatures.Player;
	import dk.sebb.tiled.mobs.creatures.Slime;
	import dk.sebb.util.AStar;
	import dk.sebb.util.Cell;
	import dk.sebb.util.Key;
	import dk.sebb.util.SMath;
	import dk.sebb.util.ShakeEffect;
	
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	import net.hires.debug.Stats;
	
	public class Level extends MovieClip
	{
		public var debug:ShapeDebug;
		public var lastFrameTime:Number = 0;
		
		public static var data:LevelData;
		public static var space:Space = new Space(new Vec2(0, 0));
		public static var lua:LuaInterface = new LuaInterface();
		public static var infoBox:InfoBox = new InfoBox();
		public static var player:Player;

		public static var screenShake:ShakeEffect;
		
		public static var timer:Timer = new Timer(1000, 10);
		public var itteration:int = 1;
		
		public static var kills:int = 0;
		
		public static var instance:Level;
		
		public static var lastShot:int;
		
		public var firstTime:Boolean = true;
		
		public static var settings:Object = {
			debug:false,
			pause:false
		};
		
		public function Level() {			
			screenShake = new ShakeEffect();
			
			scaleX = 3;
			scaleY = 3;
			
			instance = this;
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerDone);
		}
		
		private function onTimer(evt:TimerEvent):void {
			var text:TextField  = Main.counter.getChildByName('counter') as TextField;
			text.text = String(10 - timer.currentCount);
		}
		
		private function onTimerDone(evt:TimerEvent):void {
			spawnRandomMonsters(5 * ((itteration/2) + 1));
			timer.reset();
			timer.start();
			screenShake.start(30, 2, 50);
			itteration++;
			
			var text:TextField  = Main.counter.getChildByName('round') as TextField;
			text.text = String('Round ' + SMath.zeroPad(itteration, 3));
		}
		
		public function spawnRandomMonsters(amount:int):void {
			var x:int = 0;
			while(x <= amount) {
				var randX:int = Math.round(Math.random()*10) + 3;
				var randY:int = Math.round(Math.random()*10) + 3;
				
				if(AStar.getInstance().getCellFromCoords(Vec2.get(randX, randY)).cellType === Cell.CELL_FILLED) {
					continue;
				}
				
				var type:int = Math.round(Math.random() * 1);
				 
				switch(type) {
					case 0:
						var npc:NPC = new NPC(new TMXObject());
						npc.body.position.x = randX*32 + 16;
						npc.body.position.y = randY*32 + 16;
						data.addMob(npc);
						addChild(npc);
						break;
					case 1:
						var slime:Slime = new Slime(new TMXObject());
						slime.body.position.x = randX*32 + 16;
						slime.body.position.y = randY*32 + 16;
						data.addMob(slime);
						addChild(slime);
						break;					
				}
				
				x++;
			}
		}
		
		public function load(levelpath:String):void {
			unload();

			space.clear();
			data = new LevelData(levelpath);
			data.addEventListener(Event.COMPLETE, onLevelLoaded);
			data.load();
		}
		
		public function onLevelLoaded(evt:Event):void {
			
			//add layers!
			for each(var layer:Layer in data.tmxLoader.layers) {
				//layer.displayObject.alpha = 0.5;
				addChild(layer.displayObject);
			}
			
			if(firstTime) {
				firstTime = false;
				return;
			}
			
			//setup player
			player = player ? player:new Player();
			if(data.spawns[0]) {
				player.body.position = data.spawns[0];
				data.addMob(player);
			}
			player.health = 4;
			
			//setup mobs
			for each(var mob:Mob in data.mobs) {
				addChild(mob);
			}
			
			//setup info box
			parent.addChild(infoBox);
			
			//debug?
			if(settings.debug && !debug) {
				debug = new ShapeDebug(512, 512); //width/height not really important
				addChild(debug.display);
			}
			
			//debug
			if(settings.debug) {
				parent.addChild(new Stats());
			}
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			//start the game!
			addEventListener(Event.ENTER_FRAME, run);
			settings.pause = false;
			
			
			//Set AStar map with oure map
			AStar.getInstance().map = data.collisionLayer.map;
			
			//start timer
			var text:TextField  = Main.counter.getChildByName('counter') as TextField;
			text.text = String(10 - timer.currentCount);
			timer.reset();
			timer.start();
			
			//reset score
			kills = 0;
			itteration = 0;
		}
		
		public function unload():void {
			settings.pause = true;
			if(stage) {
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			}
			
			removeEventListener(Event.ENTER_FRAME, run);
			removeChildren();
			
			if(data) {
				data.unload();
				data = null;
			}
		}
		
		public function onKeyUp(evt:KeyboardEvent):void {
			if(evt.keyCode === Keyboard.SPACE) {//activate or infobox continue
				if(infoBox.hasConvo) {
					infoBox.convoNext();
				} else {//else just check mobs
					for each(var mob:Mob in data.mobs) {
						if(mob is NPC && NPC(mob).playerInProximity && NPC(mob).object.onActivate) {
							Level.lua.doString(NPC(mob).object.onActivate);
							return;
						}
					}
				}
			}
	
		}
		
		public static function pause():void {
			settings.pause = true;
			timer.stop();
			for each(var mob:Mob in data.mobs) {
				mob.stop();
				if(mob.animator) {
					mob.animator.stop();
				}
			}
		}
		
		public static function unPause():void {
			timer.start();
			settings.pause = false;
		}
		
		public function run(evt:Event = null):void {
			var deltaTime:Number = (getTimer() - lastFrameTime) / (1000/30);
			if(!settings.pause && deltaTime > 1) {
				//FIXX ME!
				space.step((1/30) * deltaTime, 10, 10);
				
				for each(var mob:Mob in data.mobs) {
					mob.update();
				}
				
				//move "camera" onto player
				x = (-(player.body.position.x * scaleX) + stage.stageWidth/2) + screenShake.offSetX;
				y = (-(player.body.position.y * scaleY) + stage.stageHeight/2) + screenShake.offSetY;
					
				//update parallax
				for each(var layer:Layer in data.parallaxLayers) {
					var playerRatioX:Number = (player.body.position.x * scaleX) / (layer.displayObject.width * scaleX);
					layer.displayObject.x = ((this.width/2) * playerRatioX) * layer.offsetX;
					
					var playerRatioY:Number = (player.body.position.y * scaleY) / (layer.displayObject.height * scaleY);
					layer.displayObject.y = ((this.height/2) * playerRatioY) * layer.offsetY;
				}
				
				if(debug) {
					debug.clear();
					debug.draw(space);
				}
				
				//fire buttons etc
				isDownCheck();
			}
			if(deltaTime > 1) {
				lastFrameTime = getTimer();
			}
		}
		
		public function isDownCheck():void {
			if(getTimer() - lastShot > 100) {
				if(Key.isDown(Keyboard.UP)) {
					var b:Bullet = new Bullet();
					b.body.group = player.body.group;
					b.body.position.setxy(player.body.position.x, player.body.position.y - 12);
					b.fire(0, -1);
					addChild(b);
					data.addMob(b);
				}
				
				if(Key.isDown(Keyboard.DOWN)) {
					var b:Bullet = new Bullet();
					b.body.group = player.body.group;
					b.body.position.setxy(player.body.position.x, player.body.position.y - 12);
					b.fire(0, 1);
					addChild(b);
					data.addMob(b);
				}
				
				if(Key.isDown(Keyboard.LEFT)) {
					var b:Bullet = new Bullet();
					b.body.group = player.body.group;
					b.body.position.setxy(player.body.position.x, player.body.position.y - 12);
					b.fire(-1, 0);
					addChild(b);
					data.addMob(b)
				}
				
				if(Key.isDown(Keyboard.RIGHT)) {
					var b:Bullet = new Bullet();
					b.body.group = player.body.group;
					b.body.position.setxy(player.body.position.x, player.body.position.y - 12);
					b.fire(1, 0);
					addChild(b);
					data.addMob(b);
				}
				
				lastShot = getTimer();
			}
		}

	}
}