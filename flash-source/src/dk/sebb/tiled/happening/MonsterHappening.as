package dk.sebb.tiled.happening
{
	
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.layers.TMXObject;
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
		protected var maxSpawn:int = 10;
		
		public function MonsterHappening()
		{
			super();
		}
		
		public function load(itteration:int, level:Level):void {
			var amount:int = this.amount !== -1 ? this.amount:(5 * ((itteration/2) + 1)) * spawnMultiplier;
			amount = amount > maxSpawn ? maxSpawn:amount;
			
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
				
				if(Vec2.distance(mob.body.position, Level.player.body.position) < 32) {
					continue;
				}
				
				mob.animator.filters = filters.length > 0 ? filters:mob.filters;
				mob.portal.filters = filters.length > 0 ? filters:mob.filters;
				mob.speed *= speedMultiplier;
				mob.health = health != -1 ? health:mob.health;
				mob.maxHealth = mob.health;
				
				Level.data.addMob(mob);
				level.addChild(mob);
				
				x++;
			}
		}

		public function unload():void {}
	}
}