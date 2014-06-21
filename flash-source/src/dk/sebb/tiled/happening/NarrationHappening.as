package dk.sebb.tiled.happening
{
	import dk.sebb.tiled.Level;
	
	public class NarrationHappening implements IHappening
	{
		public var conversations:Array = [
			'convo02',
			null,
			'convo03'
		];
		
		public function NarrationHappening() {}
		
		public function load(itteration:int, level:Level):void {
			if(conversations[itteration]) {
				Level.infoBox.convo(conversations[itteration], true);
			}
		}
		
		public function unload():void {}
	}
}