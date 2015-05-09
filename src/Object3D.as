package
{
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class Object3D
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		public var mesh:MeshData;
		public var vertexData:Vector.<VertexData>;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		// =============================
		// PROTECTED
		// =============================
		
		// =============================
		// PRIVATE
		// =============================
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Object3D( mesh:MeshData, vertices:Vector.<VertexData> )
		{
			this.mesh = mesh;
			this.vertexData = vertices;
		}
		
		public function scale( scaleX:Number, scaleY:Number, scaleZ:Number ):void
		{
			for ( var i:int; i < mesh.vertices.length; ++i )
			{
				mesh[i].x *= scaleX;
				mesh[i].y *= scaleY;
				mesh[i].z *= scaleZ;
			}
		}
	}
}