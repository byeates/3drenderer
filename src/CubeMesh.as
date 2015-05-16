/**
 * Created by bennett on 5/16/2015.
 */
package
{
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
					new VertexData( -1, -1, 0 ),
					new VertexData(  1, -1, 0 ),
					new VertexData( -1,  1, 0 )
				]);

			// bottom tri
			triangles.push(
				new <VertexData>
				[
					triangles[0][1],
					triangles[0][2],
					new VertexData( 1, 1, 0 )
				]);

			// =============================
			// BACK FACE
			// =============================
			triangles.push(
				new <VertexData>
				[
					new VertexData( -1, -1, -1 ),
					new VertexData(  1, -1, -1 ),
					new VertexData( -1,  1, -1 )
				]);

			// bottom tri
			triangles.push(
				new <VertexData>
				[
					triangles[2][1],
					triangles[2][2],
					new VertexData( 1, 1, -1 )
				]);

			// =============================
			// LEFT FACE
			// =============================
			triangles.push(
				new <VertexData>
				[
					new VertexData( -1, -1, -1 ),
					new VertexData( -1, -1,  0 ),
					new VertexData( -1,  1, -1 )
				]);

			// bottom tri
			triangles.push(
				new <VertexData>
				[
					triangles[4][1],
					triangles[4][2],
					new VertexData( -1, 1, 0 )
				]);

			// =============================
			// LEFT FACE
			// =============================
			triangles.push(
                new <VertexData>
                [
					new VertexData( -1, -1, -1 ),
					new VertexData( -1, -1,  0 ),
					new VertexData( -1,  1, -1 )
				]);

			// bottom tri
			triangles.push(
				new <VertexData>
				[
					triangles[4][1],
					triangles[4][2],
					new VertexData( -1, 1, 0 )
				]);

            // =============================
            // RIGHT FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    new VertexData( 1, -1, -1 ),
                    new VertexData( 1, -1,  0 ),
                    new VertexData( 1,  1, -1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    triangles[8][1],
                    triangles[8][2],
                    new VertexData( 1, 1, 0 )
                ]);

            // =============================
            // TOP FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    new VertexData( -1, -1, 0 ),
                    new VertexData( 1, -1,  0 ),
                    new VertexData( -1,  -1, -1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    triangles[10][1],
                    triangles[10][2],
                    new VertexData( 1, -1, -1 )
                ]);

            // =============================
            // TOP FACE
            // =============================
            triangles.push(
                new <VertexData>
                [
                    new VertexData( -1, 1, 0 ),
                    new VertexData( 1,  1,  0 ),
                    new VertexData( -1,  1, -1 )
                ]);

            // bottom tri
            triangles.push(
                new <VertexData>
                [
                    triangles[12][1],
                    triangles[12][2],
                    new VertexData( 1, 1, -1 )
                ]);
		}
	}
}
