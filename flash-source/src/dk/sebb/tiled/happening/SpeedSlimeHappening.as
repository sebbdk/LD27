package dk.sebb.tiled.happening
{
	import dk.sebb.tiled.mobs.creatures.Slime;
	
	import flash.filters.ColorMatrixFilter;
	
	public class SpeedSlimeHappening extends MonsterHappening
	{
		public function SpeedSlimeHappening()
		{
			super();
			monsterTypes = [Slime];
			spawnMultiplier = 2;
			speedMultiplier = 2;
		}
	}
}