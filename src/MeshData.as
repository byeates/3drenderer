package
{
import flash.display.Bitmap;

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
			_uvmap = new Vector.<VertexData>();
		}
		
		public function setUVData( texture:Bitmap ):void
		{
			//should be implemented by sub classes 
		}
	}
}