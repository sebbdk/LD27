/**
 * TODO: Clean up, move away from using Nape's Vec2 class
 */

package dk.sebb.util
{
	import nape.geom.Vec2;

	public class Cell
	{
		public static var CELL_FREE:uint = 0;
		public static var CELL_FILLED:uint = 1;
		public static var CELL_EDGE:uint = 14;
		public static var CELL_ORIGIN:uint = 2;
		public static var CELL_DESTINATION:uint = 3;
		public static var CELL_CREATURE:uint = 4;
		
		public var cellType:uint = CELL_FREE;	
		public var parentCell:Object = null;
		public var g:int = 0;
		public var f:int = 0;
		public var x:int = 0;
		public var y:int = 0;
		
		public var name:String;
		
		public var isPath:Boolean;
		
		private var _inhabitans:Array = [];
		
		public function Cell(_cellType:uint = 0, _x:int = 0, _y:int = 0) {
			cellType = _cellType;
			x = _x;
			y = _y;
			super();
		}
		
		public function getNomalizedPointPosition(cellSize:Number):Vec2 {
			return new Vec2(getNormalizedX(cellSize), getNormalizedY(cellSize));
		}
		
		public function getNormalizedX(cellSize:Number):Number {
			return x*cellSize+(cellSize/2);
		}
		
		public function getNormalizedY(cellSize:Number):Number {
			return y*cellSize-(cellSize/2);
		}
	}
}