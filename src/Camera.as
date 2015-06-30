package
{
	import flash.geom.Matrix;
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
		// PRIVATE
		// =============================
		private static var _instance:Camera;
		
		// =============================
		// CONST
		// =============================
		public static const FOV	:Number = 60;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Camera( pvt:privateclass )
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
		
		public function toCamera( objectT:Matrix3D ):Matrix3D
		{
			var mat:Matrix3D = new Matrix3D();
			mat.prependRotation( instance.rotationX, Vector3D.X_AXIS );
			mat.prependRotation( instance.rotationY, Vector3D.Y_AXIS );
			mat.prependRotation( instance.rotationZ, Vector3D.Z_AXIS );
			mat.appendTranslation( instance.x, instance.y, instance.z );
			mat.invert();
			mat.prepend( objectT );
			
			// translate in to viewport
			mat.appendScale( 50, 50, 1 );
			mat.appendTranslation( 350, 250, 0 );
			return mat;
		}
		
		//1) take the transpose of the camera rotation
		//2) append that against the objects transformation (in world coordinates)
		//3) add the negation of the camera's position
		public static function get transform():Matrix3D
		{
			var mat:Matrix3D = new Matrix3D();
			mat.prependRotation( instance.rotationX, Vector3D.X_AXIS );
			mat.prependRotation( instance.rotationY, Vector3D.Y_AXIS );
			mat.prependRotation( instance.rotationZ, Vector3D.Z_AXIS );
			
			mat.appendTranslation( -instance.x, -instance.y, -instance.z );
			return mat;
		}
		
		public static function get instance():Camera
		{
			return _instance ||= new Camera( new privateclass );
		}
	}
}

class privateclass {}