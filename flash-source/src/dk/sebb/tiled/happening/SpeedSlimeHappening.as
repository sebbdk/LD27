package dk.sebb.tiled.happening
{
	import flash.filters.GlowFilter;
	
	import dk.sebb.tiled.mobs.creatures.Slime;
	
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