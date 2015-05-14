package
{
	import flash.geom.Matrix3D;
	
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
		
		// =============================
		// PROTECTED
		// =============================
        protected var _width:Number;
        protected var _height:Number;
        protected var _depth:Number;
        protected var _scaleX:Number;
        protected var _scaleY:Number;
        protected var _scaleZ:Number;
		protected var _transform:Matrix3D;
		protected var _transformVertices:Vector.<Vector.<VertexData>>;

		// =============================
		// PRIVATE
		// =============================
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Object3D( mesh:MeshData )
		{
			_transform = new Matrix3D();
			this.mesh = mesh;
			populateTransformVertices();
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
		
		/** scale - scale the transformation matrix */
		public function scale( scaleX:Number, scaleY:Number, scaleZ:Number ):void
		{
            _scaleX = scaleX;
            _scaleY = scaleY;
            _scaleZ = scaleZ;
			_transform.appendScale( _scaleX, _scaleY, _scaleZ );			
			
            setWidthAndHeight();
			updateTransformVertices();
		}
		
		/** translate - move the transformation matrix */
		public function translate( xval:Number, yval:Number, zval:Number ):void
		{
			updateTranslation( xval, yval, zval );
		}
		
		/** populateTransformVertices - creates the list of vertex data based on the mesh */
		protected function populateTransformVertices():void
		{
			_transformVertices = new Vector.<Vector.<VertexData>>;
			for ( var i:int; i < mesh.triangles.length; ++i ) 
			{
				_transformVertices.push( new Vector.<VertexData> );
				
				for ( var j:int = 0; j < mesh.triangles[i].length; ++j ) 
				{
					_transformVertices[i].push( mesh.triangles[i][j].clone() );
				}
			}
		}
		
		/** after a transformation, we repopulate the list of vertex data */
		protected function updateTranslation( xval:Number, yval:Number, zval:Number ):void
		{
			for ( var i:int; i < _transformVertices.length; ++i ) 
			{
				for ( var j:int = 0; j < _transformVertices[i].length; ++j ) 
				{
					var vertex:VertexData = _transformVertices[i][j];
					vertex.vector.x += xval;
					vertex.vector.y += yval;
					vertex.vector.z += zval;
				}
			}
		}
		
		/** updateTransformVertices - updates the vertices according to the transform */
		protected function updateTransformVertices():void
		{
			for ( var i:int; i < _transformVertices.length; ++i ) 
			{
				for ( var j:int = 0; j < _transformVertices[i].length; ++j ) 
				{
					var vertex:VertexData = _transformVertices[i][j];
					vertex.vector = _transform.transformVector( vertex.vector );
				}
			}
		}
		
		/** returns the list of vertex data according to the transforms */
		public function get triangles():Vector.<Vector.<VertexData>>
		{
			return _transformVertices;
		}

        public function get x():Number
        {
            return _transform.position.x;
        }

        public function set x(value:Number):void
        {
			_transform.position.x = value;
        }

        public function get y():Number
        {
			return _transform.position.y;
        }

        public function set y(value:Number):void
        {
			_transform.position.y = value;
        }

        public function get z():Number
        {
            return _transform.position.z;
        }

        public function set z(value:Number):void
        {
			_transform.position.z = value;
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