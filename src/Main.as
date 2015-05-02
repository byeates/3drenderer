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
	[SWF(frameRate=30, width=640, height=480, backgroundColor="#000000")]
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
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function Main()
		{
			_canvas = new BitmapData( stage.stageWidth, stage.stageHeight, false, 0 );
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
	}
}