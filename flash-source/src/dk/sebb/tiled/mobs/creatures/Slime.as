package dk.sebb.tiled.mobs.creatures
{
	import Anim.Slime;
	
	import dk.sebb.tiled.layers.TMXObject;
	
	public class Slime extends NPC
	{
		public function Slime(object:TMXObject)
		{
			super(object);
			speed += Math.random()*20;
		}
		
		public override function draw():void {
			animator = new Anim.Slime();
			addChild(animator);
		}
	}
}