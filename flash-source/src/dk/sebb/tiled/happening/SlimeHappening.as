package dk.sebb.tiled.happening
{
	import dk.sebb.tiled.mobs.creatures.Slime;

	public class SlimeHappening extends MonsterHappening
	{
		public function SlimeHappening()
		{
			super();
			monsterTypes = [Slime];
			spawnMultiplier = 1.5;
		}
	}
}