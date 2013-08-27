package dk.sebb.tiled.happening
{
	import dk.sebb.tiled.Level;

	public interface IHappening
	{
		function load(itteration:int, level:Level):void;
		function unload():void;
	}
}