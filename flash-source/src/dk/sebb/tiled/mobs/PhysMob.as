package dk.sebb.tiled.mobs
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class PhysMob extends Mob
	{
		public var body:Body;
		public var poly:Polygon;

		public function PhysMob(type:BodyType = null)
		{
			super();
			body = new Body(type || BodyType.DYNAMIC, new Vec2(50, 50));
		}
		
		public override function update():void {
			x = body.position.x;
			y = body.position.y - (animator ? animator.height:0);
			rotation = body.rotation * 180 / Math.PI;
			super.update();
		} 
		
		public override function unload():void {
			super.unload();
			body.space = null;
		}
	}
}