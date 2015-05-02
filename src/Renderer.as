package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class Renderer extends Sprite
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		public var canvas:BitmapData;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Renderer( canvas:BitmapData )
		{
			this.canvas = canvas;
		}
		
		public function render( triangle:Vector.<Vector3D> ):void
		{
			// not a triangle
			if ( triangle.length != 3 )
			{
				return;
			}
			
			//canvas.fillRect( canvas.rect, 0 );
			
			var firstPass:Boolean;
			triangle.sort( sortByHeight );
			
			var sx:Number = triangle[0].x;
			var sy:Number = triangle[0].y;
			var height:Number = triangle[2].y - sy;
			
			var sstepX:Number = ( triangle[2].x - sx ) / height;
			var endstepX:Number = (triangle[1].x - sx )/(triangle[1].y - sy);
			
			var endX:Number = sx;
			var endY:Number = sy;
			while( sy < triangle[2].y )
			{
				sx += sstepX;
				sy += 1;
				
				endX += endstepX;
				endY +=1;

				// rounding this for the loop
				var dist:int = Math.ceil(endX - sx);
				while( dist != 0 )
				{
					// setting this statically to red for now
					canvas.setPixel( sx + dist, sy, 0xFF0000 );
					dist += dist < 0 ? 1 : -1;
				}
				
				if ( sy >= triangle[1].y && !firstPass )
				{
					endstepX = ( triangle[2].x - triangle[1].x )/( triangle[2].y - triangle[1].y );
					firstPass = true;
				}
			}
		}
		
		/** sorting method for returning vector ordered by y position low to high */
		protected function sortByHeight( a:Vector3D, b:Vector3D ):Number
		{
			return a.y - b.y;
		}
	}
}