package dk.sebb.tiled.happening
{
	import dk.sebb.tiled.mobs.creatures.Slime;
	
	import flash.filters.ColorMatrixFilter;
	
	public class SpeedSlimeHappening extends MonsterHappening
	{
		public function SpeedSlimeHappening()
		{
			super();
			trace('Speed slime happening!!!');
			monsterTypes = [Slime];
			spawnMultiplier = 2;
			speedMultiplier = 2;
			
			var matrix:Array = new Array();
			matrix=matrix.concat([1.5,0,0,0,-40]);// red
			matrix=matrix.concat([0,0,0,0,-40]);// green
			matrix=matrix.concat([0,0,0,0,-40]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha
			filters.push(new ColorMatrixFilter(matrix));
		}
	}
}