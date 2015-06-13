package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class VertexData
	{
		public var vector:Vector3D;
		
		// values 0-1 (representing 0-255)
		public var red:Number;
		public var green:Number;
		public var blue:Number;
		
		public var u:Number;
		public var v:Number;
		
		public var uvMap:BitmapData;
		public var clamp:Boolean;
		
		public function VertexData( x:Number=0, y:Number=0, z:Number=0 )
		{
			vector = new Vector3D( x, y, z );
		}
		
		public function setUV( map:Bitmap, u:Number=0, v:Number=0 ):void
		{
			this.u = u;
			this.v = v;
			uvMap = map.bitmapData;
		}
		
		public function setColorData( red:Number=1, green:Number=1, blue:Number=1 ):void
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
		}
		
		/** returns a copy of this vertex instance */
		public function clone(cloneVector:Boolean=true):VertexData
		{
			var vertex:VertexData = new VertexData( x, y, z );
			vertex.u = this.u;
			vertex.v = this.v;
			vertex.uvMap = uvMap;
			vertex.clamp = this.clamp;
			vertex.setColorData( red, green, blue );

			if ( !cloneVector )
			{
				vertex.vector = this.vector;
			}

			return vertex;
		}
		
		public function set x( val:Number ):void
		{
			vector.x = val;
		}
		
		public function set y( val:Number ):void
		{
			vector.y = val;
		}
		
		public function set z( val:Number ):void
		{
			vector.z = val;
		}
		
		public function get x():Number
		{
			return vector.x;
		}
		
		public function get y():Number
		{
			return vector.y;
		}
		
		public function get z():Number
		{
			return vector.z;
		}
		
		/** returns pixel data without alpha */
		public function getUVPixel( up:Number, vp:Number, pixelType:String="getPixel" ):Number
		{
			if ( clamp )
			{
				if ( up > 1 )
				{
					up = 1;
				}
				if ( vp > 1 )
				{
					vp = 1;
				}
			}
			else
			{
				if ( up > 1 )
				{
					up %= 1;
				}
				if ( vp > 1 )
				{
					vp %= 1;
				}
			}
			return uvMap[ pixelType ]( uvMap.width * up, uvMap.height * vp );
		}
	}
}