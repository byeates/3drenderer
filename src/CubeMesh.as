/**
 * Created by bennett on 5/16/2015.
 */
package
{
import flash.display.Bitmap;

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
                    new VertexData( -1, -1,  1 ),
                    new VertexData( -1,  1, -1 )
                ]);
            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    new VertexData( -1,  1,  1 ),
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
                    new VertexData( -1, -1, -1 ),
                    new VertexData(  1,  1, -1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    new VertexData( -1, 1, -1 ),
                    triangles[4][2],
                    triangles[4][1]
                ]);

            // =============================
            // RIGHT FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    new VertexData(  1, -1,  1 ),
                    new VertexData(  1, -1, -1 ),
                    new VertexData(  1,  1,  1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    new VertexData( 1, 1, -1 ),
                    triangles[6][2],
                    triangles[6][1]
                ]);

            // =============================
            // TOP FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    new VertexData( -1, -1, -1 ),
                    new VertexData(  1, -1, -1 ),
                    new VertexData( -1, -1,  1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    new VertexData( 1, -1, 1 ),
                    triangles[8][2],
                    triangles[8][1]
                ]);

            // =============================
            // BOTTOM FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    new VertexData( -1, 1,  1 ),
                    new VertexData(  1, 1,  1 ),
                    new VertexData( -1, 1, -1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    new VertexData( 1, 1, -1 ),
                    triangles[10][2],
                    triangles[10][1]
                ]);
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
