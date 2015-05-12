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
        protected var _x:Number;
        protected var _y:Number;
        protected var _z:Number;
        protected var _width:Number;
        protected var _height:Number;
        protected var _depth:Number;
        protected var _scaleX:Number;
        protected var _scaleY:Number;
        protected var _scaleZ:Number;

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

            setWidthAndHeight();
        }

        private function setWidthAndHeight():void
        {
            var minX:Number = int.MAX_VALUE;
            var maxX:Number = 0;
            var minY:Number = int.MAX_VALUE;
            var maxY:Number = 0;

            for ( var i:int; i < mesh.triangles.length; ++i )
            {
                for ( var j:int=0; j < mesh.triangles[i].length; ++j )
                {
                    minX = mesh.triangles[i][j].x < minX ? mesh.triangles[i][j].x : minX;
                    minY = mesh.triangles[i][j].y < minY ? mesh.triangles[i][j].y : minY;
                    maxX = mesh.triangles[i][j].x > maxX ? mesh.triangles[i][j].x : maxX;
                    maxY = mesh.triangles[i][j].y > maxY ? mesh.triangles[i][j].y : maxY;
                }
            }

            _width = maxX - minX;
            _height = maxY - minY;
        }
		
		public function scale( scaleX:Number, scaleY:Number, scaleZ:Number ):void
		{
            _scaleX = scaleX;
            _scaleY = scaleY;
            _scaleZ = scaleZ;

			for ( var i:int; i < mesh.triangles.length; ++i )
			{
                for ( var j:int=0; j < mesh.triangles[i].length; ++j )
                {
                    mesh.triangles[i][j].x *= scaleX;
                    mesh.triangles[i][j].y *= scaleY;
                    mesh.triangles[i][j].z *= scaleZ;
                }
			}

            setWidthAndHeight();
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

        public function get width():Number
        {
            return _width;
        }

        public function set width(value:Number):void
        {
            _width = value;
        }

        public function get height():Number
        {
            return _height;
        }

        public function set height(value:Number):void
        {
            _height = value;
        }

        public function get depth():Number
        {
            return _depth;
        }

        public function set depth(value:Number):void
        {
            _depth = value;
        }
    }
}