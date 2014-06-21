package dk.sebb.tiled.mobs
{
	import dk.sebb.tiled.layers.TMXObject;
	
	import nape.phys.BodyType;
	
	public class DetectorMob extends ObjMob
	{
		public function DetectorMob(object:TMXObject, isSensor:Boolean=false, type:BodyType=null, color:uint=0x00FFFF)
		{
			super(object, isSensor, type, color);
			body.group = Bullet.group;
		}
	}
}