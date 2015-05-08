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
		private static const MOVE_PIXELS_BY:int = 10;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		private var tri1:Vector.<VertexData>;
		private var tri2:Vector.<VertexData>;
		
		public function Main()
		{
			_canvas = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );
			
			// comment this out if you grid lines are not wanted
			createGrid();
			
			addChild( new Bitmap( _canvas ) );
			
			_renderer = new Renderer( _canvas );
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			
			// top tri
			var a:VertexData = new VertexData( 50, 50, 0 );
			var b:VertexData = new VertexData( stage.stageWidth-25 - 50, 150, 0 );
			var c:VertexData = new VertexData( 50, 300, 0 );
			
			a.setColorData( 1, 0, 0 );
			b.setColorData( 1, 0, 0 );
			c.setColorData( 0, 0, 1 );
			
			a.setUV( Textures.getMap( "brick" ) );
			b.setUV( Textures.getMap( "brick" ), 1, 0 );
			c.setUV( Textures.getMap( "brick" ), 0, 1 );
			
			// bottom tri
			var ab:VertexData = new VertexData( stage.stageWidth-25 - 50, 150, 0 );
			var bb:VertexData = new VertexData( 50, 300, 0 );
			var cb:VertexData = new VertexData( stage.stageWidth-25 - 50, 400, 0 );
			
			ab.setColorData( 1, 0, 0 );
			bb.setColorData( 1, 0, 0 );
			cb.setColorData( 0, 0, 1 );
			
			ab.setUV( Textures.getMap( "brick" ), 1, 0 );
			bb.setUV( Textures.getMap( "brick" ), 0, 1 );
			cb.setUV( Textures.getMap( "brick" ), 1, 1 );
			
			// list of 3d vectors, x, y, z, and color
			tri1 = new <VertexData>[ a, b, c ];
			tri2 = new <VertexData>[ ab, bb, cb ];
			_renderer.render( tri1 );
			_renderer.render( tri2 );
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch( event.keyCode )
			{
				case Keyboard.DOWN:
					tri1[1].y += MOVE_PIXELS_BY;
					tri2[0].y += MOVE_PIXELS_BY;
					redraw();
					break;
				
				case Keyboard.UP:
					tri1[1].y -= MOVE_PIXELS_BY;
					tri2[0].y -= MOVE_PIXELS_BY;
					redraw();
					break;
				
				case Keyboard.LEFT:
					tri1[0].x -= MOVE_PIXELS_BY;
					tri2[2].x += MOVE_PIXELS_BY;
					redraw();
					break;
				
				case Keyboard.RIGHT:
					tri1[0].x += MOVE_PIXELS_BY;
					tri2[2].x -= MOVE_PIXELS_BY;
					redraw();
					break;
				
				case Keyboard.W:
					_renderer.addAmbience();
					redraw();
					break;
				
				case Keyboard.S:
					_renderer.addAmbience( -0.1 );
					redraw();
					break;
					
			}
		}
		
		private function redraw():void
		{
			_renderer.clear();
			_renderer.render( tri1 );
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