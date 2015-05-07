package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class VertexData
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
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
			this.x = x;
			this.y = y;
			this.z = z;
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