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
		public var ambient:Vector3D = new Vector3D( 1, 1, 1 );
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Renderer( canvas:BitmapData )
		{
			this.canvas = canvas;
		}
		
		public function addAmbience( value:Number=0.1 ):void
		{
			ambient.x += value;
			ambient.y += value;
			ambient.z += value;
		}
		
		public function clear():void
		{
			canvas.fillRect( canvas.rect, 0 );
		}
		
		public function renderObject( object:Object3D ):void
		{
			object.updateTransformVertices();
			for ( var i:int; i < object.triangles.length; ++i )
			{
				render( object.triangles[i] );
			}
		}
		
		protected function render( triangle:Vector.<VertexData>, sort:Boolean=true ):void
		{
			// not a triangle
			if ( triangle.length != 3 )
			{
				return;
			}
			
			triangle.sort( sortByHeight );
			
			var firstPass:Boolean;
			
			var sx:Number = triangle[0].x;
			var sy:Number = triangle[0].y;
			var endX:Number = sx;
			var endY:Number = sy;
			var acheight:Number = triangle[2].y - sy;
			var abheight:Number = triangle[1].y - sy;
			
			var acstepX:Number = ( triangle[2].x - sx ) / (triangle[2].y - sy != 0 ? triangle[2].y - sy : 1);
			var abstepX:Number = (triangle[1].x - sx ) / (triangle[1].y - sy != 0 ? triangle[1].y - sy : 1);			
			
			var div_ac:Number = acheight == 0 ? 1 : acheight;
			var div_ab:Number = abheight == 0 ? 1 : abheight;
			
			// a to c vertex steps
			var acstepRed:Number = (triangle[2].red - triangle[0].red) / div_ac;
			var acstepGreen:Number = (triangle[2].green - triangle[0].green) / div_ac;
			var acstepBlue:Number = (triangle[2].blue - triangle[0].blue) / div_ac;
			
			var cvd:VertexData = new VertexData();
			cvd.red = triangle[0].red;
			cvd.green = triangle[0].green;
			cvd.blue = triangle[0].blue;
			
			// ac to b vertex steps
			var abstepRed:Number = (triangle[1].red - triangle[0].red) / div_ab;
			var abstepGreen:Number = (triangle[1].green - triangle[0].green) / div_ab;
			var abstepBlue:Number = (triangle[1].blue - triangle[0].blue) / div_ab;
			
			var bvd:VertexData = new VertexData();
			bvd.red = triangle[0].red;
			bvd.green = triangle[0].green;
			bvd.blue = triangle[0].blue;
			
			var uvstepleft:Point = new Point( (triangle[2].u - triangle[0].u) / div_ac, (triangle[2].v - triangle[0].v) / div_ac );
			var uvleft:Point = new Point( triangle[0].u, triangle[0].v ); 
			
			var uvstepright:Point = new Point( (triangle[1].u - triangle[0].u) / div_ab, (triangle[1].v - triangle[0].v) / div_ab );
			var uvright:Point = new Point( triangle[0].u, triangle[0].v );
			
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
				
				// uv steps
				uvleft.x += uvstepleft.x;
				uvleft.y += uvstepleft.y;
				
				uvright.x += uvstepright.x;
				uvright.y += uvstepright.y;
				
				// rounding this for the loop
				var dist:int = Math.ceil(endX - sx);
				var w:Number = sx + dist;
				var it:int = dist > 0 ? 1 : -1;
				var dir:int = it;
				
				//trace( "DIST: " + dist, "AB STEP: " + abstepX );
				
				// steps across
				var rx:Number = (bvd.red - cvd.red) / w; 
				var gx:Number = (bvd.green - cvd.green) / w; 
				var bx:Number = (bvd.blue - cvd.blue) / w;
				
				var xvd:VertexData = new VertexData();
				xvd.red = cvd.red;
				xvd.green = cvd.green;
				xvd.blue = cvd.blue;
				
				// steps across uv
				var div:int = Math.abs( dist );
				var uvx:Number = (uvright.x - uvleft.x) / div;
				var uvy:Number = (uvright.y - uvleft.y) / div;
				var uv:Point = new Point( uvleft.x, uvleft.y );
				
				var i:int = 0;
				while( i != dist )
				{
					// setting this statically to red for now
					var color:Number = triangle[0].getUVPixel( uv.x, uv.y );
					canvas.setPixel( sx + i, sy, toUint( xvd ) );
					//trace( "SETTING PIXEL: " + ( sx + i ), sy, "DIST: " + dist );
					i += it;
					
					xvd.red += rx;
					xvd.green += gx;
					xvd.blue += bx;
					
					uv.x += uvx * dir;
					uv.y += uvy;
				}
				
				if ( sy >= triangle[1].y && !firstPass )
				{
					var h:Number = triangle[2].y - triangle[1].y > 0 ? triangle[2].y - triangle[1].y : 1;
					abstepX = ( triangle[2].x - triangle[1].x ) / h;
					firstPass = true;
					abstepRed = ( triangle[2].red - triangle[1].red ) / h;
					abstepGreen = ( triangle[2].green - triangle[1].green ) / h;
					abstepBlue = ( triangle[2].blue - triangle[1].blue ) / h;
					
					uvstepright = new Point( (triangle[2].u - triangle[1].u) / h, (triangle[2].v - triangle[1].v) / h );
					uvright = new Point( triangle[1].u, triangle[1].v );
				}
			}
		}
		
		/** applyAmbience - returns color multiplied by ambient light */
		protected function applyAmbience( color:uint ):uint
		{
			var rgb:Vector3D = toRGB( color );
			// red
			rgb.x *= ambient.x;
			
			// green
			rgb.y *= ambient.y;
			
			// blue
			rgb.z *= ambient.z;
			
			return (int(rgb.x) << 16) + (int(rgb.y) << 8) + int(rgb.z);
		}
		
		/** sorting method for returning vector ordered by y position low to high */
		protected function sortByHeight( a:VertexData, b:VertexData ):Number
		{
			return a.y - b.y;
		}
		
		/** sorting method for returning vector ordered by y position low to high */
		protected function sortByWidth( a:VertexData, b:VertexData ):Number
		{
			return a.x - b.x;
		}
		
		protected function toRGB( color:uint ):Vector3D
		{
			var r:Number = color >> 16 & 0xFF;
			var g:Number = color >> 8 & 0xFF;
			var b:Number = color & 0xFF;
			return new Vector3D( r, g, b );
		}
		
		protected function toUint( vertex:VertexData ):uint
		{
			var r:Number = ( vertex.red * 255 ) << 16;
			var g:Number = ( vertex.green * 255 ) << 8;
			var b:Number = vertex.blue * 255;
			return r + g + b;
		}
		
		protected function getWidth( triangle:Vector.<VertexData> ):Number
		{
			triangle.sort( sortByWidth );
			return triangle[2].x - triangle[0].x;
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