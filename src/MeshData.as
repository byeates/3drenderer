package
{
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
		
		protected function evalMap( map:Vector.<VertexData> ):void
		{
			//should be implemented by sub classes 
		}
		
		/** evaluates and sets the uv map */
		public function set uvmap( map:Vector.<VertexData> ):void
		{
			this._uvmap = map;
			evalMap( map );
		}
	}
}