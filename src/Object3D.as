package
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
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
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _z:Number = 0;
		protected var _rotationX:Number = 0;
		protected var _rotationY:Number = 0;
		protected var _rotationZ:Number = 0;
        protected var _width:Number = 0;
        protected var _height:Number = 0;
        protected var _depth:Number = 0;
        protected var _scaleX:Number = 0;
        protected var _scaleY:Number = 0;
        protected var _scaleZ:Number = 0;
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
			
            setWidthAndHeight();
            updateTransformVertices();
		}
		
		/** translate - move the transformation matrix */
		public function translate( xval:Number, yval:Number, zval:Number ):void
		{
			_x = xval;
			_y = yval;
			_z = zval;
            updateTransformVertices();
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
		
		/** updateTransformVertices - updates the vertices according to the transform */
		public function updateTransformVertices():void
		{
			//var pivot:Vector3D = new Vector3D( _x + _width/2, _y + _height/2, _z + _depth/2 );
			populateTransformVertices();
			_transform.identity();
			_transform.appendScale( _scaleX, _scaleY, _scaleZ );
			_transform.appendTranslation( _x, _y, _z );
			_transform.prependRotation( _rotationX, Vector3D.X_AXIS );
			_transform.prependRotation( _rotationY, Vector3D.Y_AXIS );
			_transform.prependRotation( _rotationZ, Vector3D.Z_AXIS );
			
			for ( var i:int; i < _transformVertices.length; ++i ) 
			{
				for ( var j:int = 0; j < _transformVertices[i].length; ++j ) 
				{
					var vertex:VertexData = _transformVertices[i][j];
					vertex.vector = _transform.transformVector( vertex.vector );
					vertex.vector.x = Math.round( vertex.vector.x );
					vertex.vector.y = Math.round( vertex.vector.y );
					vertex.vector.z = Math.round( vertex.vector.z );
				}
			}
		}
		
		/** returns the list of vertex data according to the transforms */
		public function get triangles():Vector.<Vector.<VertexData>>
		{
			return _transformVertices;
		}
		
		public function get rotationX():Number
		{
			return _rotationX;
		}
		
		public function set rotationX(value:Number):void
		{
			_rotationX = value%360;
		}
		
		public function get rotationY():Number
		{
			return _rotationY;
		}
		
		public function set rotationY(value:Number):void
		{
			_rotationY = value%360;
		}
		
		public function get rotationZ():Number
		{
			return _rotationZ;
		}
		
		public function set rotationZ(value:Number):void
		{
			_rotationZ = value%360;
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