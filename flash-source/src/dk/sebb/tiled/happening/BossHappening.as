package dk.sebb.tiled.happening
{
	import flash.filters.ColorMatrixFilter;
	
	import dk.sebb.tiled.mobs.creatures.NPC;
	
	public class BossHappening extends MonsterHappening
	{	
		public function BossHappening() {
			monsterTypes = [NPC];
			amount = 3;
			health = 40;
			
			var matrix:Array = new Array();
			matrix=matrix.concat([0,0,0,0,-40]);// red
			matrix=matrix.concat([0,1.5,0,0,-40]);// green
			matrix=matrix.concat([0,0,0,0,-40]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha
				
			filters.push(new ColorMatrixFilter(matrix));
		}
	}
}