package
{
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class Camera
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		// transformation properties
		public var x			:Number;
		public var y			:Number;
		public var z			:Number;
		public var rotationX	:Number;
		public var rotationY	:Number;
		public var rotationZ	:Number;
		
		// =============================
		// CONST
		// =============================
		public static const FOV	:Number = 60;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Camera()
		{
			// 0 transformation properties
			x = y = z = rotationX = rotationY = rotationZ = 0;
		}
		
		public function translate( x:Number, y:Number, z:Number ):void
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
	}
}