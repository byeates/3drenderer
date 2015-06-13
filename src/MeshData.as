package
{
	import flash.display.Bitmap;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class MeshData
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		/** list of vertices for polygons */
		public var triangles:Vector.<Vector.<VertexData>>;
		public var sharedVertices:Dictionary;

		// =============================
		// PROTECTED
		// =============================	
		/** uv map associated with this mesh */
		protected var _uvmap:Vector.<VertexData>;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function MeshData()
		{
			triangles = new Vector.<Vector.<VertexData>>();
			sharedVertices = new Dictionary();
			_uvmap = new Vector.<VertexData>();
		}
		
		public function setUVData( texture:Bitmap ):void
		{
			//should be implemented by sub classes 
		}

		public function lookup( vector:Vector3D ):Vector3D
		{
			return null;
		}
	}
}