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
		
		// =============================
		// PROTECTED
		// =============================
        private var _x:Number;
        private var _y:Number;
        private var _z:Number;

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
			for ( var i:int; i < mesh.triangles.length; ++i )
			{
                for ( var j:int=0; j < mesh.triangles[i].length; ++i )
                {
                    mesh.triangles[i][j].x *=   scaleX;
                    mesh.triangles[i][j].y *= scaleY;
                    mesh.triangles[i][j].z *= scaleZ;
                }
			}
		}

        public function get x():Number
        {
            return _x;
        }

        public function set x(value:Number):void
        {
            _x = value;
        }

        public function get y():Number
        {
            return _y;
        }

        public function set y(value:Number):void
        {
            _y = value;
        }

        public function get z():Number
        {
            return _z;
        }

        public function set z(value:Number):void
        {
            _z = value;
        }
    }
}