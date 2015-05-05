package
{
	
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
		
		public function VertexData( x:Number=0, y:Number=0, z:Number=0 )
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function setColorData( red:Number=1, green:Number=1, blue:Number=1 ):void
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
		}		
	}
}