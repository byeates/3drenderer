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
		}
	}
}