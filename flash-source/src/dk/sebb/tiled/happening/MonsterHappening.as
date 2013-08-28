package dk.sebb.tiled.happening
{
	
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.layers.TMXObject;
	import dk.sebb.tiled.mobs.PhysMob;
	import dk.sebb.tiled.mobs.creatures.NPC;
	import dk.sebb.tiled.mobs.creatures.Slime;
	import dk.sebb.util.AStar;
	import dk.sebb.util.Cell;
	
	import nape.geom.Vec2;

	public class MonsterHappening implements IHappening
	{
		public var monsterTypes:Array = [
			NPC,
			Slime
		];
		
		protected var spawnMultiplier:Number = 1;
		protected var speedMultiplier:Number = 1;
		protected var filters:Array = [];
		protected var amount:int = -1;
		protected var health:int = -1;
		
		public function MonsterHappening()
		{
			super();
		}
		
		public function load(itteration:int, level:Level):void {
			var amount:int = amount !== -1 ? amount:(5 * ((itteration/2) + 1)) * spawnMultiplier;
			var x:int = 0;
			while(x <= amount) {
				var randX:int = Math.round(Math.random()*10) + 3;
				var randY:int = Math.round(Math.random()*10) + 3;
				
				if(AStar.getInstance().getCellFromCoords(Vec2.get(randX*32+5, randY*32+5)).cellType === Cell.CELL_FILLED) {
					continue;
				}
				
				var type:int = Math.round(Math.random() * (monsterTypes.length-1));
				var mob:NPC = new monsterTypes[type](new TMXObject());
				mob.body.position.x = randX*32 + 16;
				mob.body.position.y = randY*32 + 16;
				mob.filters = filters;;
				mob.speed *= speedMultiplier;
				mob.health = health != -1 ? health:mob.health;
				Level.data.addMob(mob);
				level.addChild(mob);
				
				x++;
			}
		}
		public function unload():void {}
	}
}