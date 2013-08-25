/**
 * Should be rerwitten to be not so static for better resuabillety
 * 
 * Also more comments
 */

package dk.sebb.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import nape.geom.Vec2;

	public class AStar
	{
		public var map:Array = new Array();
		
		public const MAX_ITERATIONS:uint = 2000;
		private var originCell:Cell;
		private var destinationCell:Cell;
		private var currentCell:Cell;
		
		private var openList:Array;
		private var closedList:Array;
		
		public static var cellSize:int = 32;
		
		private var bmpdata:BitmapData;
		
		public static var instance:AStar;
		
		public function AStar() {
			if(instance) {
				throw new Error("Cant instantiate any more Mapmodel, use static getinstance function instead.");
			}
			bmpdata = new BitmapData(700, 700, false, 0x0);
			instance = this;
		}
		
		public static function getInstance():AStar {
			if(!instance) {
				instance = new AStar();
			}
			return instance;
		}
		
		public function getCellFromCoords(pos:Vec2):Cell {
			return getCell(Math.floor(pos.x/cellSize), Math.floor(pos.y/cellSize));
		}
		
		public function setPointFromCoords(x:Number,y:Number, type:uint = 1):void {
			x = Math.floor((x)/cellSize);
			y = Math.floor((y)/cellSize);
			
			if(map[x] == null){
				map[x] = new Array();
			}
			
			var cell:Cell = new Cell();
			cell.cellType = type;
			cell.x = x;
			cell.y = y;
			
			map[x][y] = cell;
		}
		
		public function drawScaled(obj:DisplayObject, thumbWidth:Number, thumbHeight:Number):BitmapData {
			var m:Matrix = new Matrix();
			m.scale(thumbWidth / 700, thumbHeight / 700);
			var bmp:BitmapData = new BitmapData(thumbWidth, thumbHeight, false);
			bmp.draw(obj, m);
			return bmp;
		}
		
		private function setCell(c:Cell):void {
			map[c.x] = (map[c.x]) ? map[c.x]:new Array();
			map[c.x][c.y] = c;
		}
		
		private function getCell(x:int, y:int):Cell {
			if(map[x] != null && map[x][y] != null) {
				//Time hack... rework later with a handler function THIS IS BAD FOR REUSABILLETY! GAAAH!!
				//FIX AS SOON AS POSSIBLE BLAAAH!
				//This make smy soul acke...
				if(!(map[x][y] is Cell)) {
					var c:Cell = new Cell();
					c.cellType = Cell.CELL_FILLED;
					c.x = x;
					c.y = y;
					setCell(c)
				}
				return map[x][y];
			} else {//Fix this too btw we should not alter the original array ...
				var ec:Cell = new Cell();
				ec.x = x;
				ec.y = y;
				setCell(ec)
				return ec;
			}
		}
		
		private function reset():void {
			openList = new Array();
			closedList = new Array();
			
			currentCell = originCell;
			closedList.push(originCell);
		}
		
		
		//error returns path that does not work?! when the path is blocked
		public function findPath(from:Vec2, to:Vec2, multiply:Boolean = true):Array {
			reset();
			
			currentCell = getCell(from.x, from.y);
			Cell(currentCell).parentCell = getCell(from.x, from.y);
			originCell = getCell(from.x, from.y);
			destinationCell = getCell(to.x, to.y);
			
			//run until we either reach max iterations or we have solved the path
			var c:int = 0;
			var solved:Boolean = false;
			while(!solved && c < MAX_ITERATIONS) {
				solved = nextStep();
				c++;
			}
			
			var solutionPath:Array = new Array();
			var count:int = 0;
			var cellPointer:Object = closedList[closedList.length - 1];
			while(cellPointer != originCell) {
				if(count++ > 800) {//prevent a hang in case something goes awry
					trace("i am hanging!");
					return null
				};
				
				if(multiply) {
					solutionPath.push(new Vec2(cellPointer.x*cellSize + cellSize/2, cellPointer.y*cellSize + cellSize/2));				
				} else {
					solutionPath.push(new Vec2(cellPointer.x, cellPointer.y));				
				}
				
				cellPointer = cellPointer.parentCell;					
			}
			
			solutionPath.reverse();
			
			/*
			trace('Solution path:');
			for each(var cell:Cell in solutionPath) {
				trace(cell.x, cell.y);
			}
			*/
			
			return solutionPath;
		}
		
		private function nextStep():Boolean {
			if(currentCell == destinationCell) {
				closedList.push(destinationCell);
				return true;
			}
			
			//place current cell into openList
			openList.push(currentCell);	
			
			//adjacent tiles
			var adjacentCells:Array = new Array();
			var arryPtr:Cell;			
			
			//get the adjacent tiles
			for(var xx:int = -1; xx <= 1; xx++) {				
				for(var yy:int = -1; yy <= 1; yy++) {
					if(!(xx == 0 && yy == 0)) {	
						arryPtr = getCell(currentCell.x + xx, currentCell.y + yy);
						if(arryPtr.cellType != Cell.CELL_FILLED && closedList.indexOf(arryPtr) == -1) {
							adjacentCells.push(arryPtr);
						}
					}
				}						
			}
			
			var g:int;
			var h:int;
			
			//choose the tile with the lowest F score
			for each(var cell:Cell in adjacentCells) {
				g = currentCell.g + 1;
				h = Math.abs(cell.x - destinationCell.x) + Math.abs(cell.y - destinationCell.y);
				
				if(openList.indexOf(cell) == -1) { //is cell already on the open list? - no									
					
					cell.f = g + h;
					cell.parentCell = currentCell;
					cell.g = g;					
					openList.push(cell);
					
				} else { //is cell already on the open list? - yes
					
					if(cell.g < currentCell.parentCell.g) {
						
						currentCell.parentCell = cell;
						currentCell.f = cell.g + h;
						
					}
				}
			}
			
			//Remove current cell from openList and add to closedList.
			var indexOfCurrent:int = openList.indexOf(currentCell);
			closedList.push(currentCell);
			openList.splice(indexOfCurrent, 1);
			
			//Take the lowest scoring openList cell and make it the current cell.
			openList.sortOn("f", Array.NUMERIC | Array.DESCENDING);	
			
			if(openList.length == 0) return true;
			
			currentCell = openList.pop();
			
			//trace(currentCell.x, currentCell.y);
			
			return false;
		}
	}
}