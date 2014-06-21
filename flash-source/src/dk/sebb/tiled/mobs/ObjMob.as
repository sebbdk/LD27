package dk.sebb.tiled.mobs
{
	import flash.display.Shape;
	
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.creatures.Player;
	
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
	
	public class ObjMob extends PhysMob
	{
		public var color:uint;
		public var object:TMXObject; 
		public var onEnterListener:InteractionListener;
		public var onLeaveListener:InteractionListener;
		public static var collisionType:CbType = new CbType();
		public static var group:InteractionGroup = new InteractionGroup(true);
		
		public var playerIsTouching:Boolean;
		
		public function ObjMob(object:TMXObject, isSensor:Boolean = false, type:BodyType=null, color:uint=0x00FFFF)
		{
			super(type);
			var cbType:CbType = new CbType();
			
			this.color = color;
			this.object = object;
			body = new Body(BodyType.STATIC, new Vec2(0, 0));
			body.cbTypes.add(collisionType);
			body.cbTypes.add(cbType);
			body.group = group;
			
			poly = new Polygon(Polygon.box(object.width, object.height));
			poly.sensorEnabled = isSensor;
			body.shapes.add(poly);

			draw();
			
			if(poly.sensorEnabled) {
				onEnterListener = new InteractionListener(CbEvent.BEGIN, 
					InteractionType.SENSOR,
					cbType,
					Player.collisionType,
					onPlayerEnter);
				
				Level.space.listeners.add(onEnterListener);
				
				onLeaveListener = new InteractionListener(CbEvent.END, 
					InteractionType.SENSOR,
					cbType,
					Player.collisionType,
					onPlayerExit);
				
				Level.space.listeners.add(onLeaveListener);
			}
		}
		
		
		private function onPlayerEnter(collision:InteractionCallback):void {
			if(object.onEnter) {
				Level.lua.doString(object.onEnter);
			}
			
			playerIsTouching = true;
			
			if(object.onActivate) {
				Level.player.exclamation.visible = true;
			}
		}
		
		private function onPlayerExit(collision:InteractionCallback):void {
			if(object.onExit) {
				Level.lua.doString(object.onExit);
			}
			
			playerIsTouching = false;
			
			if(object.onActivate) {
				Level.player.exclamation.visible = false;
			}
		}
		
		public function draw():void {
			var rectangle:Shape = new Shape();
			rectangle.graphics.beginFill(color, 1);
			rectangle.graphics.drawRect(0, 0, width, height );
			rectangle.graphics.endFill();
			addChild(rectangle);
		}
	}
}