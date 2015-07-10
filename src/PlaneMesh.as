package
{
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class PlaneMesh extends MeshData
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
		public function PlaneMesh()
		{
			super();
			
			// =============================
			// FRONT FACE
			// =============================
			// top tri
			triangles.push(
				new <VertexData>
				[
					new VertexData( -1, -1, 1 ),
					new VertexData(  1, -1, 1 ),
					new VertexData( -1,  1, 1 )
				]);
			
			// bottom tri
			triangles.push(
				new <VertexData>
				[
					new VertexData( 1, 1, 1 ),
					triangles[0][2],
					triangles[0][1]
				]);
			
			// store shared vertices object coordinates in lookup
			sharedVertices[ triangles[0][0].vector ] = triangles[0][0].vector.clone();
			sharedVertices[ triangles[0][1].vector ] = triangles[0][1].vector.clone();
			sharedVertices[ triangles[0][2].vector ] = triangles[0][2].vector.clone();
			sharedVertices[ triangles[1][0].vector ] = triangles[1][0].vector.clone();
		}
		
		override public function setUVData( texture:Bitmap ):void
		{
			for (var i:int = 0; i < triangles.length-1; i += 2)
			{
				// setting a random color for now
				triangles[i][0].setColorData( Math.random(), Math.random(), Math.random() );
				triangles[i][1].setColorData( Math.random(), Math.random(), Math.random() );
				triangles[i][2].setColorData( Math.random(), Math.random(), Math.random() );
				triangles[i+1][0].setColorData( Math.random(), Math.random(), Math.random() );
				// set uv map
				triangles[i][0].setUV( texture );
				triangles[i][1].setUV( texture, 1, 0 );
				triangles[i][2].setUV( texture, 0, 1 );
				triangles[i+1][0].setUV( texture, 1, 1 );
			}
		}
	}
}