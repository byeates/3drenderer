package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	[SWF(frameRate="30", width="700", height="500", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		public var cube:Object3D;
		
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
		private static const MOVE_PIXELS_BY:Number = 1;

		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Main()
		{
			_canvas = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );
			
			// comment this out if grid lines are not wanted
			createGrid();
            _keys = {};

			addChild( new Bitmap( _canvas ) );

			_renderer = new Renderer( _canvas );

			addEventListener( Event.ENTER_FRAME, update );
            stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
            stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			var mesh:MeshData = new CubeMesh();
			mesh.setUVData( Textures.getMap( "brick" ) );

			cube = new Object3D( mesh );
			cube.addLightSource( new Vector3D( 0, 0, 1 ) );
			//cube.scale( 50, 50, 1 );
			cube.translate( 0, 0, -100 );
			cube.updateTransformVertices();
			_renderer.renderObject( cube );
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
            for ( var key:String in _keys )
            {
                if ( _keys[ key ] === true )
                {
                    switch( int(key) )
                    {
                        case Keyboard.DOWN:
							if ( _isMouseDown )
							{
								Camera.instance.y -= MOVE_PIXELS_BY;
							}
							else
							{
                            	Camera.instance.rotationZ -= MOVE_PIXELS_BY;
							}
                            doRedraw = true;
                            break;

                        case Keyboard.UP:
							if ( _isMouseDown )
							{
								Camera.instance.y += MOVE_PIXELS_BY;
							}
							else
							{
								Camera.instance.rotationZ += MOVE_PIXELS_BY;
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
                    }
                }
            }
			
			cube.rotationY += 5;
			cube.updateTransformVertices();
			redraw();
        }

		private function redraw():void
		{
			_renderer.clear();
			_renderer.renderObject( cube );
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