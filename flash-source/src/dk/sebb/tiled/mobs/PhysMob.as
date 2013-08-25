package dk.sebb.tiled.mobs
{
	import flash.display.MovieClip;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	public class PhysMob extends Mob
	{
		public var body:Body;
		public var poly:Polygon;
		public var animator:MovieClip;

		public function PhysMob(type:BodyType = null)
		{
			super();
			body = new Body(type || BodyType.DYNAMIC, new Vec2(50, 50));
		}
		
		public override function update():void {
			x = body.position.x;
			y = body.position.y - height;
			rotation = body.rotation * 180 / Math.PI;
			super.update();
		} 
	}
}