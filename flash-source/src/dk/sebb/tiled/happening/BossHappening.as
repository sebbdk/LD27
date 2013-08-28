package dk.sebb.tiled.happening
{
	import dk.sebb.tiled.Level;
	import dk.sebb.tiled.mobs.creatures.NPC;
	
	import flash.filters.ColorMatrixFilter;
	
	public class BossHappening extends MonsterHappening
	{	
		public function BossHappening() {
			monsterTypes = [NPC];
			amount = 1;
			health = 20;
			
			var matrix:Array = new Array();
			matrix=matrix.concat([0,0,0,0,-40]);// red
			matrix=matrix.concat([0,1.5,0,0,-40]);// green
			matrix=matrix.concat([0,0,0,0,-40]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha
			filters.push(new ColorMatrixFilter(matrix));
		}
	}
}