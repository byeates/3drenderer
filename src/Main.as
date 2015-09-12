package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	[SWF(frameRate="60", width="700", height="500", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		public var cube:Object3D;
		public var wall:Object3D;
		public var floor:Object3D;

		// =============================
		// PROTECTED
		// =============================
		protected var _renderer:Renderer;
		protected var _canvas:BitmapData;
		protected var _isMouseDown:Boolean;
		
		// =============================
		// PRIVATE
		// =============================
        // list of key presses
        private static var _keys:Object;

		// =============================
		// CONST
		// =============================
		private static const GRID_LINE_WIDTH:int = 1;
		private static const GRID_LINE_COLOR:int = 0x333333;
		private static const GRID_COLUMN_SIZE:int = 25;
		private static const GRID_ROW_SIZE:int = 25;
		private static const MOVE_PIXELS_BY:Number = 0.1;
		private static const SECONDS_MS:int = 1000;
		
		private var _beginTime:Number;
		private var _frames:int;

		private var _models:Vector.<Object3D> = new Vector.<Object3D>();

		private var models:Object =
		{
				cube: "../../../models/cube_uv.txt"
		};

		private var modelData:Object = {};

		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Main()
		{
			loadModels();

			stage.scaleMode = StageScaleMode.SHOW_ALL;

			_canvas = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );
			
			// comment this out if grid lines are not wanted
			createGrid();
            _keys = {};

			//addChild( new Bitmap( _canvas ) );

			_renderer = new Renderer( _canvas );
			_renderer.sprite = this;

			addEventListener( Event.ENTER_FRAME, update );
            stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
            stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			var cubeMesh:MeshData = new CubeMesh();
			cubeMesh.setUVData( Textures.getMap( "brick" ) );

			cube = new Object3D( cubeMesh );
			cube.addLightSource( new Vector3D( 0, 0, 1 ) );
			
			var planeMesh:MeshData = new PlaneMesh();
			planeMesh.setUVData( Textures.getMap( "floor" ) );
			
			cube.scale( 50, 50, 1 );
			cube.translate( 0, 0, 2000 );
			cube.updateTransformVertices();
			
			wall = new Object3D( planeMesh );
			wall.translate( 0, 0, 2000 );
			wall.scale( stage.stageWidth, stage.stageHeight, 1 );
			wall.updateTransformVertices();

			floor = new Object3D( planeMesh );
			floor.translate( 0, 0, 2000 );
			floor.scale( stage.stageWidth, stage.stageHeight, 1 );
			floor.rotationX = 90;
			floor.updateTransformVertices();
			
			//_renderer.renderObject( floor );
			//_renderer.renderObject( wall );
			//_renderer.renderObject( cube );
			_beginTime = getTimer();
		}

		protected function loadModels():void
		{
			for ( var model:String in models )
			{
				var loader:URLLoader = new URLLoader()
				//loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener( Event.COMPLETE, function(e:Event):void
				{
					// string of vertex information
					modelData[ model ] = parseModel( String( e.currentTarget.data ) );

					var object:Object3D = new Object3D( modelData[ model ] );
					object.scale( 50, 50, 1 );
					object.translate( 0, 0, 2000 );
					object.updateTransformVertices();

					_renderer.renderObject( object );

					_models.push( object );

				});
				loader.load( new URLRequest( models[ model ] ) );
			}
		}

		protected function parseModel( data:String ):MeshData
		{
			var modelData:Array = data.split( "\n" );
			var vertices:Vector.<Vector3D> = parseVertices( modelData[1] );
			var triangles:Vector.<Vector.<VertexData>>;

			triangles = createTrisFromData( modelData, vertices );

			var mesh:CustomMesh = new CustomMesh();
			mesh.createMesh( vertices, triangles );
			mesh.setUVData( null );

			return mesh;
		}

		protected function parseVertices( unparsedData:String ):Vector.<Vector3D>
		{
			var splitData:Array;
			unparsedData = unparsedData.replace( /.*VERTICES.*\[(.*)\]/gm, "$1" );
			splitData = unparsedData.replace(/[\r\n]+/g, "").split("),");

			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();
			for ( var i:int=0; i < splitData.length; ++i )
			{
				var vec:String = splitData[i].replace( /.*Vector\(+(.*)\)+/g, "$1" );
				var cords:Array = vec.split( "," );
				vertices.push( new Vector3D( cords[0], cords[1], cords[2] ) );
			}
			return vertices;
		}

		protected function createTrisFromData( modelData:Array, vertices:Vector.<Vector3D> ):Vector.<Vector.<VertexData>>
		{
			var triangles:Vector.<Vector.<VertexData>> = new Vector.<Vector.<VertexData>>();
			var indices:Array = modelData[0].replace( /.*\[(.*.)\]/gm, "$1" ).split("|");
			indices[0] = indices[0].replace( /INDICES\:([\r\n]+)?/gm , "");

			for ( var i:int; i < indices.length; ++i )
			{
				var tri:Array = indices[i].replace( /\s+/g, "" ).split(",");

				// TODO: check to see if the vertexdata was already create, if so clone it, otherwise
				// create a new one
				/*triangles.push(
					new <VertexData>
					[

					]);*/
			}

			return triangles;
		}
		
		protected function onKeyDown( e:KeyboardEvent ):void
        {
            _keys[ e.keyCode ] = true;
        }
        protected function onKeyUp( e:KeyboardEvent ):void
        {
            _keys[ e.keyCode ] = false;
        }
		
		protected function onMouseDown( e:MouseEvent ):void
		{
			_isMouseDown = true;
		}
		
		protected function onMouseUp( e:MouseEvent ):void
		{
			_isMouseDown = false;
		}

		protected function update(event:Event):void
		{
            var doRedraw:Boolean;
			_frames++;
			
            for ( var key:String in _keys )
            {
                if ( _keys[ key ] === true )
                {
                    switch( int(key) )
                    {
                        case Keyboard.DOWN:
							if ( _isMouseDown )
							{
								Camera.instance.rotationY -= MOVE_PIXELS_BY;
							}
							else
							{
                            	Camera.instance.y -= MOVE_PIXELS_BY;
							}
                            doRedraw = true;
                            break;

                        case Keyboard.UP:
							if ( _isMouseDown )
							{
								Camera.instance.rotationY += MOVE_PIXELS_BY;
							}
							else
							{
								Camera.instance.y += MOVE_PIXELS_BY;
							}
                            doRedraw = true;
                            break;

                        case Keyboard.LEFT:
							if ( _isMouseDown )
							{
								Camera.instance.rotationX -= MOVE_PIXELS_BY;
							}
							else
							{
								Camera.instance.x -= MOVE_PIXELS_BY;
							}
                            doRedraw = true;
                            break;

                        case Keyboard.RIGHT:
							if ( _isMouseDown )
							{
								Camera.instance.rotationX += MOVE_PIXELS_BY;
							}
							else
							{
								Camera.instance.x += MOVE_PIXELS_BY;
							}
                            doRedraw = true;
                            break;

						case Keyboard.W:
							_renderer.addAmbience();
							doRedraw = true;
							break;

						case Keyboard.S:
							_renderer.addAmbience(-0.1);
							doRedraw = true;
							break;

						case Keyboard.A:
							_renderer.rotateLight(cube);
							doRedraw = true;
							break;

						case Keyboard.D:
							_renderer.rotateLight( cube, 1 );
							doRedraw = true;
							break;
						
						case Keyboard.EQUAL:
							Camera.PD += MOVE_PIXELS_BY * 300;
							break;
						
						case Keyboard.MINUS:
							Camera.PD -= MOVE_PIXELS_BY * 300;
							break;
						
						case Keyboard.NUMPAD_1:
							resetCamera();
							break;
                    }
                }
            }
			
			// display frame count
			var currentTime:Number = getTimer();
			if ( currentTime - _beginTime >= SECONDS_MS )
			{
				//*trace( "FRAMES: " + _frames, "setPixel calls: " + _renderer.setPixelCount,
					//"Using vector data:  " + _renderer.useBitData );//*
				
				_frames = 0;
				_beginTime = currentTime;
			}
			_renderer.setPixelCount = 0;
			
			//cube.rotationY += 5;
			//cube.updateTransformVertices();
			
			//floor.updateTransformVertices();
			//wall.updateTransformVertices();

			redraw();
			for ( var i:int; i < _models.length; ++i )
			{
				_models[i].updateTransformVertices();
				_models[i].rotationY += 5;
				_renderer.renderObject( _models[i] );
			}

			//Camera.instance.rotationX += 0.1;
        }

		private function resetCamera():void
		{
			Camera.instance.x = 0;
			Camera.instance.y = 0;
			Camera.instance.z = 0;
			Camera.instance.rotationX = 0;
			Camera.instance.rotationY = 0;
			Camera.instance.rotationZ = 0;
		}

		private function redraw():void
		{
			this.graphics.clear();
			//_renderer.renderObject( floor );
			//_renderer.renderObject( wall );
			//_renderer.renderObject( cube );
			//_renderer.renderObject()
		}
		
		private function createGrid():void
		{
			var grid:Sprite = new Sprite();
			grid.graphics.lineStyle(GRID_LINE_WIDTH, GRID_LINE_COLOR);
			
			var columns:int = stage.stageWidth / GRID_COLUMN_SIZE;
			var rows:int = stage.stageWidth / GRID_ROW_SIZE;
			
			for ( var i:int = 0; i < columns; ++i )
			{
				grid.graphics.drawRect( i*GRID_COLUMN_SIZE, 0, GRID_LINE_WIDTH, stage.stageHeight );
			}
			
			for ( i = 0; i < rows; ++i )
			{
				grid.graphics.drawRect( 0, i*GRID_ROW_SIZE, stage.stageWidth, GRID_LINE_WIDTH );
			}
			
			_canvas.draw( grid )
		}
	}
}