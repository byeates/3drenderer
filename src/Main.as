package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	[SWF(frameRate=30, width=700, height=500, backgroundColor="#000000")]
	public class Main extends Sprite
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		
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
		private static const GRID_LINE_COLOR:int = 0xCCCCCC;
        private static const GRID_COLUMN_SIZE:int = 25;
        private static const GRID_ROW_SIZE:int = 25;

		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Main()
        {
			_canvas = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );

            // comment this out if you grid lines are not wanted
            createGrid();

			addChild( new Bitmap( _canvas ) );
			
			_renderer = new Renderer( _canvas );
			
			// list of 3d vectors, x, y, and color
			var tri1:Vector.<Vector3D> = new <Vector3D>
			[
				new Vector3D( 50, 50, 0xFF0000 ),
				new Vector3D( 150, 100, 0x00FF00 ),
				new Vector3D( 50, 150, 0xFF0000 )
			];
			_renderer.render( tri1 );

			// list of 3d vectors, x, y, and color
			var tri2:Vector.<Vector3D> = new <Vector3D>
			[
				new Vector3D( 150, 50, 0xFF0000 ),
				new Vector3D( 200, 100, 0x00FF00 ),
				new Vector3D( 150, 150, 0xFF0000 )
			];

			_renderer.render( tri2 );
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