package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
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
		public var square:Object3D;
		
		// =============================
		// PROTECTED
		// =============================
		protected var _renderer:Renderer;
		protected var _canvas:BitmapData;
		
		// =============================
		// PRIVATE
		// =============================
		
		// =============================
		// CONST
		// =============================
		private static const GRID_LINE_WIDTH:int = 1;
		private static const GRID_LINE_COLOR:int = 0x333333;
		private static const GRID_COLUMN_SIZE:int = 25;
		private static const GRID_ROW_SIZE:int = 25;
		private static const MOVE_PIXELS_BY:int = 5;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Main()
		{
			_canvas = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );
			
			// comment this out if grid lines are not wanted
			createGrid();
			
			addChild( new Bitmap( _canvas ) );
			
			_renderer = new Renderer( _canvas );
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			
			var mesh:MeshData = new CubeMesh();
			mesh.setUVData( Textures.getMap( "brick" ) );
						
			square = new Object3D( mesh );
			square.scale( 75, 75, 1 );
			square.translate( stage.stageWidth/2, stage.stageHeight/2, 0 );
			_renderer.renderObject( square );
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
            switch( event.keyCode )
            {
                case Keyboard.DOWN:
                    square.rotationX += MOVE_PIXELS_BY;
                    break;

                case Keyboard.UP:
                    square.rotationX -= MOVE_PIXELS_BY;
                    break;

                case Keyboard.LEFT:
                    square.rotationY -= MOVE_PIXELS_BY;
                    break;

                case Keyboard.RIGHT:
                    square.rotationY += MOVE_PIXELS_BY;
                    break;

            }
            square.updateTransformVertices();
            redraw();
        }

		private function redraw():void
		{
			_renderer.clear();
			_renderer.renderObject( square );
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