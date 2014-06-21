package dk.sebb.tiled.mobs
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Timer;
	
	import Anim.PlayerBullet;
	
	import Graph.Whitesplosion;
	
	import dk.sebb.tiled.Level;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.dynamics.InteractionGroup;
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
		
		public static var group:InteractionGroup = new InteractionGroup(true);
		
		public var directionX:int = 0;
		public var directionY:int = 0;
		
		public var originX:int = 0;
		public var originY:int = 0;		
		
		public var speed:Number = 0;
		public var lifeSpan:int = 700;
		public var maxDistance:int = 96;
		
		public static var pool:Array = [];
		public static var poolLimit:int = 80;
		
		public var explosion:MovieClip = new Graph.Whitesplosion();
		public var bullet:MovieClip = new Anim.PlayerBullet();

/**
 * Do not call new instave directly
 * Instead call the static getBullet method
 */
		public function Bullet(evil:Boolean = false) {
			//set up graphic
			addChild(bullet);
			this.scaleX = 1.5;
			this.scaleY = 1.5;
			
			//setup physics body
			body = new Body(BodyType.DYNAMIC, new Vec2(0, 0));
			poly = new Polygon(Polygon.box(width, height));
			poly.sensorEnabled = true;
			body.shapes.add(poly);
			body.allowRotation = false;
			body.cbTypes.add(collisionType);
			body.cbTypes.add(localCollisionType);
			
			body.group = group;

			//add explosion
			explosion.scaleX = 0.5;
			explosion.scaleY = 0.5;
			explosion.alpha = 0;
			addChild(explosion);
			
			
			//setup interaction listener
			onCollisionListener = new InteractionListener(CbEvent.ONGOING, 
				InteractionType.ANY,
				localCollisionType,
				ObjMob.collisionType,
				onCollision);
			Level.space.listeners.add(onCollisionListener);
			
			onCollisionListener = new InteractionListener(CbEvent.ONGOING, 
				InteractionType.ANY,
				localCollisionType,
				ObjMob.collisionType,
				onCollision);
			Level.space.listeners.add(onCollisionListener);
			
			
			//prepare lifespan timer
			lifeTimer = new Timer(lifeSpan, 1);
			lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLifeSpanOver);
			
			
			var matrix:Array = new Array();
			matrix=matrix.concat([2,0,0,0,-80]);// red
			matrix=matrix.concat([0,0,0,0,-40]);// green
			matrix=matrix.concat([0,0,0,0,-40]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha
			this.filters.push(new ColorMatrixFilter(matrix));
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
		public function fire(originX:Number, originY:Number, directionX:int, directionY:int, speed:Number = 150):void {
			this.directionX = directionX; 
			this.directionY = directionY;
			this.originX = originX;
			this.originY = originY;
			this.speed = speed;
			
			bullet.visible = true;
			body.position.setxy(originX, originY);
			body.rotation = Math.atan2(directionY*-1, directionX*-1);
			
			lifeTimer.reset();
			lifeTimer.delay = lifeSpan;
			lifeTimer.start();
			
			//Level.screenShake.start(5, 2, 5);
		}

/**
 * Maintain a speed
 * @return void
 */
		public override function update():void {
			x = body.position.x;
			y = body.position.y;
			rotation = body.rotation * 180 / Math.PI;
			
			body.velocity.setxy(directionX*speed, directionY*speed);
		}

/**
 * Reduce enemy health and unload it self!
 * @param  collision InteractionCallback
 * @return void
 */
		private function onCollision(collision:InteractionCallback):void {
			body.space = null;
			bullet.visible = false;
			explosion.alpha = 1;
			explosion.scaleX = explosion.scaleY = 0.2;
			body.velocity.setxy(0,0);
			explosion.x = -3 + (6 * Math.random());
			explosion.y = -3 + (6 * Math.random());

			var scale:Number = 0.6 + 0.4 * Math.random();
			explosion.scaleX = explosion.scaleY = 0.1;
			TweenLite.to(explosion, 0.1, {scaleX:scale, scaleY:scale});
			TweenLite.to(explosion, 0.4, {alpha:0, complete:function():void {
				unload();
			}});
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