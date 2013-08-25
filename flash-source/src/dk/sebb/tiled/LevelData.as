package dk.sebb.tiled
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import dk.sebb.tiled.layers.ImageLayer;
	import dk.sebb.tiled.layers.Layer;
	import dk.sebb.tiled.layers.ObjectLayer;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.Bullet;
	import dk.sebb.tiled.mobs.Mob;
	import dk.sebb.tiled.mobs.ObjMob;
	import dk.sebb.tiled.mobs.PhysMob;
	import dk.sebb.tiled.mobs.TileMob;
	import dk.sebb.tiled.mobs.creatures.NPC;
	import dk.sebb.tiled.mobs.creatures.Slime;
	import dk.sebb.util.JSONLoader;
	
	import nape.geom.Vec2;
	import nape.phys.BodyType;

	public dynamic class LevelData extends EventDispatcher
	{
		public var tmxLoader:TMXLoader;
		public var dataLoader:JSONLoader;
		
		public var parallaxLayers:Array = [];
		public var spawns:Array = [];
		public var mobs:Array = [];
		
		public var basePath:String;
		
		public var collisionLayer:Layer;
		
		public function LevelData(basePath:String) {
			this.basePath = basePath;
			
			tmxLoader = new TMXLoader(basePath + "level.tmx");
			tmxLoader.addEventListener(Event.COMPLETE, onTMXLoaded);
		}
		
		public function load():void {
			tmxLoader.load();
		}
		
		public function unload():void {
			mobs = null;
			spawns = null;
			parallaxLayers = null;
			
			for each(var mob:Mob in mobs) {
				if(mob is PhysMob) {
					PhysMob(mob).body.space = null;
				}
				
				if(mob is Bullet) {
					Bullet(mob).unload();
				}
			}
		}
		
		public function removeMob(mob:Mob):void {
			for(var i:int = 0; i < mobs.length; i++) {
				if(mobs[i] === mob) {
					mobs.splice(i, 1);
					mob.unload();
				}
			}
		}
		
		public function addMob(mob:Mob):void {
			if(mob is PhysMob) {
				PhysMob(mob).body.space = Level.space;
			}
			mobs.push(mob);
		}
		
		public function onTMXLoaded(evt:Event):void {
			tmxLoader.removeEventListener(Event.COMPLETE, onTMXLoaded);
			//get object layers
			for each(var layer:Layer in tmxLoader.layers) {
				if(layer.parallax) {
					parallaxLayers.push(layer);
				}
				
				switch(getQualifiedClassName(layer)) {
					case 'dk.sebb.tiled.layers::ObjectLayer':
						setupObjectLayer(layer as ObjectLayer);
						break;
					case 'dk.sebb.tiled.layers::ImageLayer':
						setupImageLayer(layer as ImageLayer);
						break;
					case 'dk.sebb.tiled.layers::Layer':
						setupLayer(layer);
						break;
				}
			}
			
			if(tmxLoader.data) {
				dataLoader = new JSONLoader(basePath + tmxLoader.data);
				dataLoader.addEventListener(Event.COMPLETE, onDataLoaded);
				dataLoader.load();
			} else {
				dispatchEvent(evt);
			}
		}
		
		public function onDataLoaded(evt:Event):void {
			dataLoader.removeEventListener(Event.COMPLETE, onDataLoaded);

			for(var attr:String in dataLoader.data) {
				this[attr] = dataLoader.data[attr];
			}
			
			dispatchEvent(evt);
		}
		
		/**
		 * Loop's through the obejct layers to set up spawn points, detectors etc
		 * */
		public function setupObjectLayer(layer:ObjectLayer):void {
			if(layer.display === "false") {
				layer.displayObject.visible = false;
			}			
			
			for each(var object:TMXObject in layer.objects) {
				if(object.type) {
					switch(object.type) {
						case 'playerspawn':
							spawns.push(new Vec2(object.x + (object.width/2), object.y + (object.height/2)));
							break;
						case 'detector':
							var objDet:ObjMob = new ObjMob(object, true);
							objDet.body.position.x = object.x + (object.width/2);
							objDet.body.position.y = object.y + (object.height/2);
							addMob(objDet);
							break;
						case 'npc':
							trace("NPC found! now create it!");
							var npc:NPC = new NPC(object);
							npc.body.position.x = object.x + (object.width/2);
							npc.body.position.y = object.y + (object.height/2);
							addMob(npc);
							break;
						case 'slime':
							trace("slime found! now create it!");
							var slime:NPC = new Slime(object);
							slime.body.position.x = object.x + (object.width/2);
							slime.body.position.y = object.y + (object.height/2);
							addMob(slime);
							break;
						case 'obj':
							trace("Object mob found, create it!");
							var obj:ObjMob = new ObjMob(object);
							obj.body.position.x = object.x + (object.width/2);
							obj.body.position.y = object.y + (object.height/2);
							addMob(obj);
							break;
						default:
							trace("unknow  object type (" + object.type + ") found in level!");
							break;
					}
				}
			}
		}
		
		/**
		 * Loops through the image layers to set them up with parallax etc
		 * */
		public function setupImageLayer(layer:ImageLayer):void {}
		
		/**
		 * handles collision layers or other tiles with settings on them
		 * */
		public function setupLayer(layer:Layer):void {
			if(layer.display === "false") {
				layer.displayObject.visible = false;
			}
			
			if(layer.name === 'function') {
				collisionLayer = layer;
			}
			
			if(layer.functional && layer.functional === "true") { //create phys objects for the tiles in functinal layers
				for (var spriteForX:int = 0; spriteForX < tmxLoader.mapWidth; spriteForX++) {
					for (var spriteForY:int = 0; spriteForY < tmxLoader.mapHeight; spriteForY++) {
						var tileGid:int = int(layer.map[spriteForX][spriteForY]);
						if(TileSet.tiles[tileGid]) {
							var tileMob:PhysMob = new TileMob(BodyType.STATIC);
							tileMob.body.position.x = 32 * spriteForX + 16;
							tileMob.body.position.y = 32 * spriteForY + 16;
							tileMob.hasPerspective = layer.perspective && layer.perspective === "true";
							addMob(tileMob);
						}
					}
				}
			} else if(layer.perspective && layer.perspective === "true") {//create objects for tiles in perspective layers
				
				for each(var object:TMXObject in layer.objects) {
					var mob:Mob = new Mob();
					mob.x = object.x;
					mob.y = object.y;
					object.x = 0;
					object.y = -64;
					mob.addChild(object);
					mob.hasPerspective = true;
					addMob(mob);
				}
				
							
			}
		}
		
	}
}