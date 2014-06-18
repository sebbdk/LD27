package dk.sebb.tiled.mobs.creatures
{
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import Anim.Battery;
	import Anim.Twirl;
	
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.mobs.Bullet;
	import dk.sebb.tiled.mobs.TileMob;
	import dk.sebb.util.AStar;
	import dk.sebb.util.Cell;
	import dk.sebb.util.Key;
	
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
	
	public class Player extends TileMob
	{
		public var vaultForce:Vec2 = Vec2.get();
		public static var collisionType:CbType = new CbType();
		public var direction:Vec2 = new Vec2();
		public var currentAnimation:String = "down";
		public var mapPos:Vec2 = new Vec2();
		public var _health:int = 3;
		public var lastHit:int = 0;
		
		public var onBulletListener:InteractionListener;
		
		public function Player()
		{
			super(null, 32, 0x00DD00);
			body = new Body(BodyType.DYNAMIC, new Vec2(0, 0));
			poly = new Polygon(Polygon.box(10,10));
			body.group = new InteractionGroup();
			body.group.ignore = true;
			body.cbTypes.add(collisionType);

			body.shapes.add(poly);
			body.allowRotation = false;
			
			health = 4;
			
			onBulletListener = new InteractionListener(CbEvent.BEGIN, 
				InteractionType.SENSOR,
				collisionType,
				Bullet.collisionType,
				onBullehit);
			
			Level.space.listeners.add(onBulletListener);
		}
		
		private function onBullehit(evt:InteractionCallback):void {
			trace('i was hit!!!!');
		}
		
		public function damage():void {
			if(getTimer() - lastHit > 500) {
				health--;
				lastHit = getTimer();
				Level.screenShake.start(10);
			}
		}
		
		public function get health():int {
			return _health;
		}
		
		public function set health(h:int):void {
			_health = h;
			Main.healthbar.removeChildren();
			for(var c:int = 0; c < _health; c++) {
				var bat:MovieClip = new Anim.Battery();
				bat.scaleX = 4;
				bat.scaleY = 4;
				bat.x = (c*20+bat.width);
				Main.healthbar.addChild(bat);
			}
			
			if(_health <= 0) {
				Level.pause();
				Main.gameOver.visible = true;
				Main.UI.visible = false;
				saveScore();
			}
		}
		
		public function saveScore():void {
			if(ExternalInterface.available) {
				ExternalInterface.call('saveScore', [Level.kills, Level.itteration]);
			}
		}
		
		public override function draw():void {
			animator = new Anim.Twirl();
			addChild(animator);
		}
		
		public override function update():void {
			super.update();
			updateKinematics();
		}
		
		private function updateKinematics():void {
			var currentCell:Cell = AStar.getInstance().getCellFromCoords(Level.player.body.position);
			mapPos = mapPos.setxy(currentCell.x, currentCell.y);
			
			var kx:int = 0;
			var ky:int = 0;
			
			var vel:int = 60;
			
			if(Key.isDown(Keyboard.D)) {
				kx += vel;
			}
			
			if(Key.isDown(Keyboard.A)) {
				kx += -vel;
			}
			
			if(Key.isDown(Keyboard.W)) {
				ky += -vel;
			}
			
			if(Key.isDown(Keyboard.S)) {
				ky += vel;
			}
			
			var vec:Vec2 = body.localVectorToWorld(new Vec2(kx, ky));
			body.force = vec;
			
			body.velocity = vec;
			body.kinematicVel= new Vec2(-kx*3, -ky*3);
			
			var isMoving:Boolean = (ky !== 0 || kx !== 0);

			if(!isMoving && currentAnimation != "") {
				animator.gotoAndStop(currentAnimation);
				MovieClip(animator.getChildAt(0)).gotoAndStop(0);
				currentAnimation = "";
			}

			//set graphics scale
			if(isMoving && kx < 0) {
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
				
				if(vec.x != 0 && currentAnimation != 'sideways') {
					animator.gotoAndStop('sideways');
					currentAnimation = 'sideways';
				} else if(vec.x === 0 && vec.y > 0 && currentAnimation != 'down'){
					animator.gotoAndStop('down');
					currentAnimation = 'down';
				} else if(vec.x === 0 && vec.y < 0 && currentAnimation != 'up') {
					animator.gotoAndStop('up');
					currentAnimation = 'up';
				}
			}
		}
	}
}