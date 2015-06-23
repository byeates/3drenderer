package
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
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
		
		public function get transform():Matrix3D
		{
			var mat:Matrix3D = new Matrix3D();
			mat.appendTranslation( x, y, z );
			mat.prependRotation( rotationX, Vector3D.X_AXIS );
			mat.prependRotation( rotationY, Vector3D.Y_AXIS );
			mat.prependRotation( rotationZ, Vector3D.Z_AXIS );
			return mat;
		}
	}
}