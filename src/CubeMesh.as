/**
 * Created by bennett on 5/16/2015.
 */
package
{
	import flash.display.Bitmap;
	import flash.geom.Vector3D;

	public class CubeMesh extends MeshData
	{
		/*=========================================================================================
		CONSTRUCTOR
		=========================================================================================*/
		public function CubeMesh()
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

            // =============================
            // LEFT FACE
            // =============================
           triangles.push(
                new <VertexData>
                [
                    new VertexData( -1, -1, -1 ),
                    triangles[0][0].clone(false),
                    new VertexData( -1,  1, -1 )
                ]);
            // bottom tri
           triangles.push(
               new <VertexData>
               [
                   triangles[0][2].clone(false),
                   triangles[2][2],
                   triangles[2][1]
               ]);

            // =============================
            // BACK FACE
            // =============================
			  triangles.push(
                new <VertexData>
                [
                    new VertexData(  1, -1, -1 ),
                    triangles[2][0].clone(false),
                    new VertexData(  1,  1, -1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    triangles[2][2].clone(false),
                    triangles[4][2],
                    triangles[4][1]
                ]);

            // =============================
            // RIGHT FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    triangles[0][1].clone(false),
                    triangles[4][0].clone(false),
                    triangles[1][0].clone(false)
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    triangles[4][2].clone(false),
                    triangles[6][2],
                    triangles[6][1]
                ]);

            // =============================
            // TOP FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    triangles[2][0].clone(false),
                    triangles[4][0].clone(false),
                    triangles[0][0].clone(false)
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    triangles[0][1].clone(false),
                    triangles[8][2],
                    triangles[8][1]
                ]);

            // =============================
            // BOTTOM FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    triangles[0][2].clone(false),
                    triangles[1][0].clone(false),
                    triangles[2][2].clone(false)
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    triangles[4][2].clone(false),
                    triangles[10][2],
                    triangles[10][1]
                ]);

			// store shared vertices object coordinates in lookup
			sharedVertices[ triangles[0][0].vector ] = triangles[0][0].vector.clone();
			sharedVertices[ triangles[0][1].vector ] = triangles[0][1].vector.clone();
			sharedVertices[ triangles[0][2].vector ] = triangles[0][2].vector.clone();
			sharedVertices[ triangles[1][0].vector ] = triangles[1][0].vector.clone();
			sharedVertices[ triangles[2][0].vector ] = triangles[2][0].vector.clone();
			sharedVertices[ triangles[2][2].vector ] = triangles[2][2].vector.clone();
			sharedVertices[ triangles[4][0].vector ] = triangles[4][0].vector.clone();
			sharedVertices[ triangles[4][2].vector ] = triangles[4][2].vector.clone();
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
