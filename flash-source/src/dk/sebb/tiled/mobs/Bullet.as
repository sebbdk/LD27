package dk.sebb.tiled.mobs
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Anim.PlayerBullet;
	
	import dk.sebb.tiled.Level;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class Bullet extends PhysMob
	{
		public static var collisionType:CbType = new CbType();
		public var localCollisionType:CbType = new CbType();
		public var onCollisionListener:InteractionListener;
		public var lifeTimer:Timer
		
		public var directionX:int = 0;
		public var directionY:int = 0;
		public var speed:Number = 0;
		public var lifeSpan:int = 5000;
		
		public static var pool:Array = [];
		public static var poolLimit:int = 80;

/**
 * Do not call new instave directly
 * Instead call the static getBullet method
 */
		public function Bullet() {
			//set up graphic
			addChild(new Anim.PlayerBullet());
			
			//setup physics body
			body = new Body(BodyType.DYNAMIC, new Vec2(0, 0));
			poly = new Polygon(Polygon.box(width, height));
			body.shapes.add(poly);
			body.allowRotation = false;
			body.cbTypes.add(collisionType);
			body.cbTypes.add(localCollisionType);
			
			//setup interaction listener
			onCollisionListener = new InteractionListener(CbEvent.ONGOING, 
				InteractionType.ANY,
				localCollisionType,
				ObjMob.collisionType,
				onCollision);
			Level.space.listeners.add(onCollisionListener);
			
			//prepare lifespan timer
			lifeTimer = new Timer(lifeSpan, 1);
			lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLifeSpanOver);
		}

/**
 * Returns a bullet from the pool or instantiates a new on request
 * This is done to main tain a maximum amount of bullets on screen
 * @return Bullet
 */
		public static function getBullet():Bullet {
			if(pool.length < poolLimit) {
				pool.push(new Bullet());
				return Bullet(pool[pool.length-1]);
			} else {
				pool.push(pool.shift());
				Bullet(pool[pool.length-1]).unload();
				return Bullet(pool[pool.length-1]);
			}
			
			return null;
		}

/**
 * Fires the bullet in a direction and speed!
 * @param  directionX Int
 * @param  directionY Int
 * @param  speed      Number
 * @return void
 */
		public function fire(directionX:int, directionY:int, speed:Number = 150):void {
			this.directionX = directionX; 
			this.directionY = directionY;
			this.speed = speed;
			
			body.rotation = Math.atan2(directionY*-1, directionX*-1);
			
			lifeTimer.reset();
			lifeTimer.delay = lifeSpan;
			lifeTimer.start();
		}

/**
 * Maintain a speed
 * @return void
 */
		public override function update():void {
			super.update();
			body.velocity.setxy(directionX*speed, directionY*speed);
		}

/**
 * Reduce enemy health and unload it self!
 * @param  collision InteractionCallback
 * @return void
 */
		private function onCollision(collision:InteractionCallback):void {
			unload();
		}

/**
 * Remove the bullet after some time
 * @param  evt TimerEvent
 * @return void
 */
		public function onLifeSpanOver(evt:TimerEvent):void {
			unload();
		}
		
	}
}