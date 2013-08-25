package dk.sebb.tiled.layers
{
	import flash.display.Sprite;

	public dynamic class TMXObject extends Sprite
	{
		public var object:XML;

		public var display:String = "true";
		public var type:String;
		
		public function TMXObject(_object:XML = null) {
			object = _object ? _object:new XML();
			parseProperties();
		}
		
		public function parseProperties():void {
			if(object.attribute("name")[0]) {
				name = object.attribute("name")[0];
			}
			
			//parse layer properties
			if(object.properties) {
				for each (var property:XML in object.properties.children()) {
					var pname:String = property.attribute("name");
					var pvalue:String = property.attribute("value");
					this[pname] = pvalue;
				}
			}
			
			if(display === "false") {
				visible = false;
			}
		}
	}
}