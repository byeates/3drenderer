package
{
	import flash.geom.Vector3D;
	
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class SquareMesh extends MeshData
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
		
		// =============================
		// PRIVATE
		// =============================
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function SquareMesh()
		{
			super();
			this.triangles = new Vector.<Vector.<Vector3D>>();
			
			// top tri
			triangles.push
			(
				new <Vector3D>
				[
					new Vector3D( -1, -1, 0 ),
					new Vector3D(  1, -1, 0 ),
					new Vector3D( -1,  1, 0 )
				]
			);
			
			// bottom tri
			triangles.push
			(
				new <Vector3D>
				[
					new Vector3D(  1, -1, 0 ),
					new Vector3D(  1,  1, 0 ),
					new Vector3D( -1,  1, 0 )
				]
			);
			
			
			/*var a:VertexData = new VertexData( 50, 50, 0 );
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
			cb.setUV( Textures.getMap( "brick" ), 1, 1 );*/
		}
	}
}