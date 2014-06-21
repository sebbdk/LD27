package dk.sebb.tiled.mobs.creatures
{
	import flash.geom.Rectangle;
	
	import Anim.Slime;
	
	import dk.sebb.tiled.layers.TMXObject;
	
	public class Slime extends NPC
	{
		public function Slime(object:TMXObject)
		{
			super(object, new Rectangle(0, 0, 8, 8));
			speed = 20 + Math.random()*10;
			health = 1;
		}
		
		public override function draw():void {
			animator = new Anim.Slime();
			addChild(animator);
		}
	}
}