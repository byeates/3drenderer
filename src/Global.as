package
{
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class Global
	{
		/*=========================================================================================
		VARS
		=========================================================================================*/
		// =============================
		// PUBLIC
		// =============================
		/** complete list of object3d instances */
		public static var displayList:Vector.<Object3D> = new Vector.<Object3D>;
		
		/** addChild - add object to the display list */
		public static function addChild( object3d:Object3D ):void
		{
			displayList.push( object3d );
		}
		
		/** removeChild - remove object from the display list */
		public static function removeChild( object3d:Object3D ):void
		{
			displayList.splice( displayList.indexOf( object3d ), 1 );
		}
	}
}