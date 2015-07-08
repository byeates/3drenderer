package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	
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
		public var ambience:Number = 0.1;
		public var lightRotation:Number = 0;
		
		public var setPixelCount:Number = 0;
		
		public var bitData:Vector.<uint>;
		
		public var useBitData:Boolean;
		
		private var _beginTime:Number;
		// =============================
		// CONST
		// =============================
		protected static const ROTATE_AMOUNT:int = 5;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Renderer( canvas:BitmapData )
		{
			this.canvas = canvas;
			bitData = new Vector.<uint>( canvas.width * canvas.height, true );
		}

		public function cull( object:Object3D ):Vector.<Vector.<VertexData>>
        {
			var triangles:Vector.<Vector.<VertexData>> = new Vector.<Vector.<VertexData>>;
			for ( var i:int; i < object.triangles.length-1; i += 2 )
			{
				var triangle:Vector.<VertexData> = object.triangles[i];
				var v0:Vector3D = triangle[0].clone().vector;
				var v1:Vector3D = triangle[1].clone().vector;
				var v2:Vector3D = triangle[2].clone().vector;

				var n:Vector3D = v1.subtract( v0 ).crossProduct( v2.subtract( v0 ) );

				if ( n.z > 0 )
				{
					triangles.push( triangle );
					triangles.push( object.triangles[i+1] );
				}
			}
			return triangles;
        }
		
		public function addAmbience( value:Number=0.1 ):void
		{
			ambience += value;
		}

		public function rotateLight( object:Object3D, dir:int=-1 ):void
		{
			var light:Vector3D = object.currentLight;
			var x:Number, y:Number, z:Number = 0;
			if ( dir < 0 )
			{
				lightRotation -= ROTATE_AMOUNT;
				x = Math.cos( lightRotation * Math.PI / 180 );
				y = Math.sin( lightRotation * Math.PI / 180 );
				object.transformCurrentLight( x, y, z );
			}
			else
			{
				lightRotation += ROTATE_AMOUNT;
				y = Math.sin( lightRotation * Math.PI / 180 );
				x = Math.cos( lightRotation * Math.PI / 180 );
				object.transformCurrentLight( x, y, z );
			}
		}
		
		public function clear():void
		{
            canvas.fillRect( canvas.rect, 0 );
        }

        public function renderObject( object:Object3D ):void
        {
			var triangles:Vector.<Vector.<VertexData>> = cull( object );
			_beginTime = getTimer();
			for ( var i:int=0; i < triangles.length; ++i )
			{
				render( triangles[i], object );
			}
			trace( "RENDERED SHAPE: " + ( getTimer() - _beginTime ));
			bitData = new Vector.<uint>( canvas.width * canvas.height, true );
		}
		
		protected function render( triangle:Vector.<VertexData>, object3d:Object3D ):void
		{
			// not a triangle
			if ( triangle.length != 3 )
			{
				return;
			}
			
			var order:Vector.<VertexData> = new Vector.<VertexData>();
			order.push( triangle[0] );
			order.push( triangle[1] );
			order.push( triangle[2] );
			
			triangle.sort( sortByHeight );
			
			// lighting
			var a:Vector3D = object3d.getLocalVector( triangle[0] );
			var b:Vector3D = object3d.getLocalVector( triangle[1] );
			var c:Vector3D = object3d.getLocalVector( triangle[2] );
			
			a.normalize();
			b.normalize();
			c.normalize();
			
			var aDot:Number = Math.max( object3d.getLights().dotProduct( a ), ambience );
			var bDot:Number = Math.max( object3d.getLights().dotProduct( b ), ambience );
			var cDot:Number = Math.max( object3d.getLights().dotProduct( c ), ambience );
			
			var gl_ab:Number = aDot;
			var gl_ac:Number = aDot;
			
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
			
			var gl_stepab:Number = ( bDot - aDot ) / div_ab;
			var gl_stepac:Number = ( cDot - aDot ) / div_ac;
			
			var stepY:int = triangle[2].y < sy ? -1 : 1;
			
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
			
			while( sy != triangle[2].y )
			{
				sx += acstepX;
				sy += stepY;
				
				cvd.red += acstepRed;
				cvd.green += acstepGreen;
				cvd.blue += acstepBlue;
				
				endX += abstepX;
				endY += stepY;
				
				bvd.red += abstepRed;
				bvd.green += abstepGreen;
				bvd.blue += abstepBlue;
				
				// uv steps
				uvleft.x += uvstepleft.x;
				uvleft.y += uvstepleft.y;
				
				uvright.x += uvstepright.x;
				uvright.y += uvstepright.y;

				// global light step
				gl_ab += gl_stepab;
				gl_ac += gl_stepac;
				
				// rounding this for the loop
				var dist:int = endX < sx ? Math.floor( endX - sx ) : Math.ceil( endX - sx );
				var it:int = dist > 0 ? 1 : -1;
				var dir:int = it;
				var w:int = dist * dir;

				// global light step across
				var gl_current:Number = gl_ac;
				var gl_step:Number = (gl_ab - gl_ac) / w;
				
				// steps across
				var rx:Number = (bvd.red - cvd.red) / w;
				var gx:Number = (bvd.green - cvd.green) / w;
				var bx:Number = (bvd.blue - cvd.blue) / w;
				
				var xvd:VertexData = new VertexData();
				xvd.red = cvd.red;
				xvd.green = cvd.green;
				xvd.blue = cvd.blue;
				
				// steps across uv
				var uvx:Number = (uvright.x - uvleft.x) / w;
				var uvy:Number = (uvright.y - uvleft.y) / w;
				var uv:Point = new Point( uvleft.x, uvleft.y );
				
				var tsx:int = Math.round( sx );
				
				var i:int = 0;
				while( i != dist )
				{
                    var color:Number = triangle[0].getUVPixel( uv.x, uv.y );
					
					if ( useBitData )
					{
						bitData[ int( sy * canvas.width + sx + i ) ] = applyLight( color, gl_current );
					}
					else
					{
						canvas.setPixel( tsx + i, sy, applyLight( color, gl_current ) );
					}
					
					setPixelCount++;
					i += it;
					
					xvd.red += rx;
					xvd.green += gx;
					xvd.blue += bx;
					
					uv.x += uvx;
					uv.y += uvy;

					gl_current += gl_step;
				}

				if ( !firstPass && ((stepY < 0 && sy <= triangle[1].y) || (stepY > 0 && sy >= triangle[1].y)))
				{
					var h:Number = triangle[2].y - triangle[1].y != 0 ? triangle[2].y - triangle[1].y : 1;
                    h *= stepY;
					abstepX = ( triangle[2].x - triangle[1].x ) / h;
					firstPass = true;

                    // this is altered, it's really b-c step
					abstepRed = ( triangle[2].red - bvd.red ) / h;
					abstepGreen = ( triangle[2].green - bvd.green ) / h;
					abstepBlue = ( triangle[2].blue - bvd.blue ) / h;

					uvstepright = new Point( (triangle[2].u - triangle[1].u ) / h, (triangle[2].v - triangle[1].v) / h );
					uvright = new Point( triangle[1].u, triangle[1].v );

					gl_stepab = (cDot - bDot) / h;
				}
			}
			
			
			triangle[0] = order[0];
			triangle[1] = order[1];
			triangle[2] = order[2];
			
			if ( useBitData )
			{
				renderBitData();
			}
 		}
		
		protected function renderBitData():void
		{
			canvas.setVector( canvas.rect, bitData );
		}

        /** applyLight - returns color multiplied by ambient light */
		protected function applyLight( color:uint, strength:Number ):uint
		{
			// clamp
			if ( strength > 1 )
			{
				strength = 1;
			}
			if ( strength < 0 )
			{
				strength = 0;
			}

			var rgb:Vector3D = toRGB( color );
			// red
			rgb.x *= strength;

			// green
			rgb.y *= strength;

			// blue
			rgb.z *= strength;

			return (int(rgb.x) << 16) + (int(rgb.y) << 8) + int(rgb.z);
		}
		
		/** applyAmbience - returns color multiplied by ambient light */
		protected function applyAmbience( color:uint ):uint
		{
			var rgb:Vector3D = toRGB( color );
			// red
			rgb.x *= ambience;
			
			// green
			rgb.y *= ambience;
			
			// blue
			rgb.z *= ambience;
			
			return (int(rgb.x) << 16) + (int(rgb.y) << 8) + int(rgb.z);
		}
		
		/** sorting method for returning vector ordered by y position low to high */
		protected function sortByHeight( a:VertexData, b:VertexData ):Number
		{
			return a.y - b.y;
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