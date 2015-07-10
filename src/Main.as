package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
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

		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Main()
		{
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
			
			_renderer.renderObject( floor );
			_renderer.renderObject( wall );
			_renderer.renderObject( cube );
			_beginTime = getTimer();
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
				/*trace( "FRAMES: " + _frames, "setPixel calls: " + _renderer.setPixelCount, 
					"Using vector data:  " + _renderer.useBitData );*/
				
				_frames = 0;
				_beginTime = currentTime;
			}
			_renderer.setPixelCount = 0;
			
			cube.rotationY += 5;
			cube.updateTransformVertices();
			
			floor.updateTransformVertices();
			wall.updateTransformVertices();
			redraw();

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
			_renderer.renderObject( floor );
			_renderer.renderObject( wall );
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