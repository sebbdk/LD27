package dk.sebb.tiled.mobs.creatures
{
	import flash.display.MovieClip;
	
	import Anim.BlueGuy;
	
	import avmplus.getQualifiedClassName;
	
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.ObjMob;
	import dk.sebb.tiled.mobs.PhysMob;
	import dk.sebb.util.AStar;
	import dk.sebb.util.Cell;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class NPC extends PhysMob
	{
		public var object:TMXObject; 
		
		public var proximityPoly:Polygon;
		public var onEnterListener:InteractionListener;
		public var onLeaveListener:InteractionListener;
		public static var collisionType:CbType = new CbType();

		public var direction:Vec2 = new Vec2();
		public var currentAnimation:String = "";
		
		public var speed:Number = 50;
		public var destination:Vec2;
		
		public var playerInProximity:Boolean = false;
		
		public var path:Array;
		
		public function NPC(object:TMXObject, collWidth:Number = 4, collHeight:Number = 4)
		{
			this.object = object;
			draw();
			
			body = new Body(BodyType.DYNAMIC, new Vec2(0, 0));
			body.allowRotation = false;
			body.cbTypes.add(collisionType);
			body.cbTypes.add(ObjMob.collisionType);
			body.group = ObjMob.group;
			
			poly = new Polygon(Polygon.box(collWidth, collHeight));
			body.shapes.add(poly);
			
			proximityPoly = new Polygon(Polygon.box(collWidth*2, collHeight*2));
			proximityPoly.sensorEnabled = true;
			body.shapes.add(proximityPoly);
			
			onEnterListener = new InteractionListener(CbEvent.BEGIN, 
				InteractionType.SENSOR,
				collisionType,
				Player.collisionType,
				onPlayerEnter);
			
			Level.space.listeners.add(onEnterListener);
			
			onLeaveListener = new InteractionListener(CbEvent.END, 
				InteractionType.SENSOR,
				collisionType,
				Player.collisionType,
				onPlayerExit);
			
			Level.space.listeners.add(onLeaveListener);
			
			hasPerspective = true;
		}
		
		private function onPlayerEnter(collision:InteractionCallback):void {
			trace("YOU ARE TOO CLOSE!!");
			if(object.onEnter) {
				Level.lua.doString(object.onEnter);
			}
			
			playerInProximity = true;
		}
		
		private function onPlayerExit(collision:InteractionCallback):void {
			trace("yes, get out of here you ruffian!");
			if(object.onExit) {
				Level.lua.doString(object.onExit);
			}
			
			playerInProximity = false;
		}
		
		public function draw():void {
			animator = new Anim.BlueGuy();
			addChild(animator);
		}
		
		public function findPath():void {
			var myCell:Cell = AStar.getInstance().getCellFromCoords(body.position);
			var playerCell:Cell = AStar.getInstance().getCellFromCoords(Level.player.body.position);
			var cpos:Vec2 = Vec2.get(myCell.x, myCell.y, true);//!!!!
			
			try {
				if(playerCell && playerCell.cellType === Cell.CELL_FILLED) {
					destination.x += Math.round(Math.random()*6) - 3;
					destination.y += Math.round(Math.random()*6) - 3;
					path = AStar.getInstance().findPath(cpos, destination);
				} else {
					destination = Vec2.get(playerCell.x  + Math.round(Math.random()*2) - 1, playerCell.y  + Math.round(Math.random()*2) - 1, true);
					path = AStar.getInstance().findPath(cpos, destination);
				}
			} catch(err:Error) {
				trace('path error!');
			}
		}
		
		public override function update():void {
			super.update();
			
			var vec:Vec2 = body.localVectorToWorld(new Vec2(0, 0));
			
			//find a new path if the player has changed position
			var playerCell:Cell = AStar.getInstance().getCellFromCoords(Level.player.body.position);
			if(destination && destination.x !== Level.player.mapPos.x && destination.y !== Level.player.mapPos.y) {
				findPath();
			}
			
			if(Vec2.distance(body.position,  Level.player.body.position) < 32) {
				vec = Level.player.body.position.sub(body.position);
				vec.length = 50;
			} else if(path && path.length > 0) {//continue down the current path if we have a path
				if(Vec2.distance(body.position,  path[0]) < 16) {
					path.shift();
				} else {
					vec = path[0].sub(body.position);
					vec.length = 50;
				}
			} else {//else find a path
				findPath();
			}
			
			body.velocity = vec;
			
			var isMoving:Boolean = (body.velocity.x !== 0 || body.velocity.x !== 0);
			if(!isMoving && currentAnimation != "") {
				animator.gotoAndStop(currentAnimation);
				MovieClip(animator.getChildAt(0)).gotoAndStop(0);
				currentAnimation = "";
			}
			
			if(body.velocity.x < 0) {
				this.scaleX = 1;
			} else if(isMoving) {
				this.scaleX = -1;
			}
			
			if(isMoving){
				//set direction
				if(vec.x != 0) {
					direction.x = vec.x > 0 ? 1:-1;
				} else {
					direction.x = 0 
				}
				if(vec.y != 0) {
					direction.y = vec.y > 0 ? 1:-1;
				} else {
					direction.y = 0 
				}
				
				//set animation
				MovieClip(animator.getChildAt(0)).play(); 
				
				if(vec.x != 0 && currentAnimation != 'horizontal') {
					setAnimation('horizontal');
				} else if(vec.x === 0 && vec.y > 0 && currentAnimation != 'vertical'){
					setAnimation('vertical');
				} else if(vec.x === 0 && vec.y < 0 && currentAnimation != 'vertical') {
					setAnimation('vertical');
				}
			}
		}
		
		public function setAnimation(name:String):void {
			try {
				animator.gotoAndStop('vertical');
				currentAnimation = 'vertical';
			} catch(err:Error) {}

		}
	}
}