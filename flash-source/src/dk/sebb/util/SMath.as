/**
 * Change to use Points instead of Vec2
 */

package dk.sebb.util
{
	import nape.geom.Vec2;

	public class SMath
	{
		public function SMath()
		{
		}
		
		public static function zeroPad(number:int, width:int):String {
			var ret:String = ""+number;
			while( ret.length < width )
				ret="0" + ret;
			return ret;
		}
		
		public static function randomRadiusPoint(radius:Number, vec:Vec2 = null):Vec2
		{
			var randomAngle:Number = Math.random() * (Math.PI * 2);
			return CPAngle(randomAngle, radius, vec);
		}
		
		public static function CPAngle(angle:Number, radius:Number, vec:Vec2 = null):Vec2 {
			var newX:Number = radius*Math.cos(angle);
			var newY:Number = radius*Math.sin(angle);
			
			if(vec) {
				vec.setxy(newX, newY);
				return vec;
			}
			
			return Vec2.get(newX, newY);
		}
		
		public static function getAngle(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2(dy,dx);
		}
	}
}