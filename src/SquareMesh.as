package
{
	
	/**
	 * ...
	 * @author Bennett Yeates
	 * 
	 * */
	public class SquareMesh extends MeshData
	{
		protected static const VERTICES:int = 4;
		
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function SquareMesh( uvmap:Vector.<VertexData>=null )
		{
			super();
			evalMap( uvmap );
			
			// top tri
			triangles.push
			(
				new <VertexData>
				[
					new VertexData( -1, -1, 0 ),
					new VertexData(  1, -1, 0 ),
					new VertexData( -1,  1, 0 )
				]
			);
			
			// bottom tri
			triangles.push
			(
				new <VertexData>
				[
					triangles[0][1],
					triangles[0][2],
					new VertexData( 1, 1, 0 )
				]
			);
		}
		
		override protected function evalMap(map:Vector.<VertexData>):void
		{
			if ( !map || map.length != VERTICES ) { return; }
			
			triangles[0][0].uvMap = map[0].uvMap;
			triangles[0][0].u = map[0].u;
			triangles[0][0].u = map[0].u;
			
			triangles[0][1].uvMap = map[1].uvMap;
			triangles[0][1].u = map[1].u;
			triangles[0][1].u = map[1].u;
			
			triangles[0][2].uvMap = map[2].uvMap;
			triangles[0][2].u = map[2].u;
			triangles[0][2].u = map[2].u;
			
			triangles[1][2].uvMap = map[3].uvMap;
			triangles[1][2].u = map[3].u;
			triangles[1][2].u = map[3].u;
		}
	}
}