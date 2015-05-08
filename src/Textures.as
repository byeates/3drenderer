package
{
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class Textures
	{
		// EMBED IMAGES
		[Embed(source="/../textures/brick.jpeg")]
		private static var brickClass:Class;
		
		// LIST OF BITMAPS
		protected static var maps:Object =
		{
			brick: new brickClass()
		}
		
		public static function getMap( name:String ):Bitmap
		{
			return maps[ name ];
		}
	}
}