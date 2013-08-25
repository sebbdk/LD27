package dk.sebb.tiled.layers
{
	import dk.sebb.tiled.TMXLoader;

	public dynamic class ObjectLayer extends Layer
	{
		
		public function ObjectLayer(_layer:XML, _tmxLoader:TMXLoader)
		{
			super(_layer, _tmxLoader);
		}
		
		protected override function parseLayer():void {
			displayObject.removeChildren();
			objects = [];
			
			for each (var object:XML in layer.object) {
				var rectangle:TMXObject = new TMXObject(object);
				rectangle.graphics.lineStyle(2);
				rectangle.graphics.beginFill(0x0099CC, 1);
				rectangle.graphics.drawRect(0, 0, object.attribute("width"), object.attribute("height") );
				rectangle.graphics.endFill();
				rectangle.x = object.attribute("x");
				rectangle.y = object.attribute("y");
				displayObject.addChild(rectangle);
				objects.push(rectangle);
			}
		}
		
		public override function draw():void {}
	}
}