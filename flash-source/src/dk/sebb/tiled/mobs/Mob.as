package dk.sebb.tiled.mobs
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import dk.sebb.tiled.Level;
	
	public class Mob extends MovieClip
	{
		public var hasPerspective:Boolean;
		public var animator:MovieClip;
		
		public function Mob()
		{
			super();
		} 
		
		public function update():void {
			if(hasPerspective && parent) {
				for(var c:int = parent.numChildren-1; c >= 0; c--) {
					var child:DisplayObject = parent.getChildAt(c);
					if(child != this && child is Mob) {
						if(child.y > this.y && parent.getChildIndex(this) > c) {
							parent.swapChildren(this, child);
						}
						
						if(child.y < this.y && parent.getChildIndex(this) < c) {
							parent.swapChildren(this, child);
						}
					}
				}
			}
		}
		
		public function unload():void {
			if(parent) {
				parent.removeChild(this);
			}
			
			Level.data.removeMob(this);
		}
	}
}