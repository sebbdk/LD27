package dk.sebb.tiled.mobs.creatures
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.Bullet;
	
	public class BulletDrone extends NPC
	{
		public var fireTimer:Timer = new Timer(3000);
		
		public function BulletDrone(object:TMXObject, colRect:Rectangle=null)
		{
			super(object, colRect);
			fireTimer.addEventListener(TimerEvent.TIMER, shootBullet);
			fireTimer.start();
		}
		
		public override function unload():void {
			super.unload();
			fireTimer.removeEventListener(TimerEvent.TIMER, shootBullet);
		}
		
		public function shootBullet(evt:Event):void {
			var b:Bullet = new Bullet(true);
			b.body.group = body.group;
			b.body.position.setxy(body.position.x, body.position.y);
			b.fire(0, -1);
			Level.instance.addChild(b);
			Level.data.addMob(b);
			
			var b2:Bullet = new Bullet(true);
			b2.body.group = body.group;
			b2.body.position.setxy(body.position.x, body.position.y);
			Level.instance.addChild(b2);
			Level.data.addMob(b2);
			
			var b3:Bullet = new Bullet(true);
			b3.body.group = body.group;
			b3.body.position.setxy(body.position.x, body.position.y);
			b3.fire(-1, 0);
			Level.instance.addChild(b3);
			Level.data.addMob(b3);
			
			var b4:Bullet = new Bullet(true);
			b4.body.group = body.group;
			b4.body.position.setxy(body.position.x, body.position.y);
			b4.fire(1, 0);
			Level.instance.addChild(b4);
			Level.data.addMob(b4);
		}
	}
}
