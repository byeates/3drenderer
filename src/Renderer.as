package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
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
		
		public function render( triangle:Vector.<VertexData> ):void
		{
			// not a triangle
			if ( triangle.length != 3 )
			{
				return;
			}
			
			var firstPass:Boolean;
			triangle.sort( sortByHeight );
			
			var sx:Number = triangle[0].x;
			var sy:Number = triangle[0].y;
			var endX:Number = sx;
			var endY:Number = sy;
			var acheight:Number = triangle[2].y - sy;
			var abheight:Number = triangle[1].y - sy;
			
			var acstepX:Number = ( triangle[2].x - sx ) / (triangle[2].y - sy > 0 ? triangle[2].y - sy : 1);
			var abstepX:Number = (triangle[1].x - sx ) / (triangle[1].y - sy > 0 ? triangle[1].y - sy : 1);			
			
			// a to c vertex steps
			var acstepRed:Number = (triangle[2].red - triangle[0].red) / acheight;
			var acstepGreen:Number = (triangle[2].green - triangle[0].green) / acheight;
			var acstepBlue:Number = (triangle[2].blue - triangle[0].blue) / acheight;
			
			var cvd:VertexData = new VertexData();
			cvd.red = triangle[0].red;
			cvd.green = triangle[0].green;
			cvd.blue = triangle[0].blue;
			
			// ac to b vertex steps
			var abstepRed:Number = (triangle[1].red - triangle[0].red) / abheight;
			var abstepGreen:Number = (triangle[1].green - triangle[0].green) / abheight;
			var abstepBlue:Number = (triangle[1].blue - triangle[0].blue) / abheight;
			
			var bvd:VertexData = new VertexData();
			bvd.red = triangle[0].red;
			bvd.green = triangle[0].green;
			bvd.blue = triangle[0].blue;
			
			while( sy < triangle[2].y )
			{
				sx += acstepX;
				sy += 1;
				
				cvd.red += acstepRed;
				cvd.green += acstepGreen;
				cvd.blue += acstepBlue;
				
				endX += abstepX;
				endY += 1;
				
				bvd.red += abstepRed;
				bvd.green += abstepGreen;
				bvd.blue += abstepBlue;
				
				// rounding this for the loop
				var dist:int = Math.ceil(endX - sx);
				var w:Number = sx + dist;
				
				// steps across
				var rx:Number = (bvd.red - cvd.red) / w; 
				var gx:Number = (bvd.green - cvd.green) / w; 
				var bx:Number = (bvd.blue - cvd.blue) / w;
				
				var xvd:VertexData = new VertexData();
				xvd.red = cvd.red;
				xvd.green = cvd.green;
				xvd.blue = cvd.blue;
				
				var i:int = 0;
				while( i < dist )
				{
					// setting this statically to red for now
					canvas.setPixel( sx + i, sy, toUint( xvd ) );
					++i;
					
					xvd.red += rx;
					xvd.green += gx;
					xvd.blue += bx;
				}
				
				if ( sy >= triangle[1].y && !firstPass )
				{
					var h:Number = triangle[2].y - triangle[1].y > 0 ? triangle[2].y - triangle[1].y : 1;
					abstepX = ( triangle[2].x - triangle[1].x ) / h;
					firstPass = true;
					abstepRed = ( triangle[2].red - triangle[1].red ) / h;
					abstepGreen = ( triangle[2].green - triangle[1].green ) / h;
					abstepBlue = ( triangle[2].blue - triangle[1].blue ) / h;
				}
			}
		}
		
		/** sorting method for returning vector ordered by y position low to high */
		protected function sortByHeight( a:VertexData, b:VertexData ):Number
		{
			return a.y - b.y;
		}
		
		protected function toUint( vertex:VertexData ):uint
		{
			var r:Number = ( vertex.red * 255 ) << 16;
			var g:Number = ( vertex.green * 255 ) << 8;
			var b:Number = vertex.blue * 255;
			return r + g + b;
		}
	}
}

class RGB
{
	// 0-255 rgb values
	public var red:uint;
	public var blue:uint;
	public var green:uint;
	
	public function RGB( red:uint=0, green:uint=0, blue:uint=0 )
	{
		this.red = red;
		this.blue = blue;
		this.green = green;
	}
	
	public function toUint():uint
	{
		return red << 16 | green << 8 | blue;
	}
}