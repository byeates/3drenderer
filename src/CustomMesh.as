/**
 * Created by: byeates
 * Date: 8/24/15
 */
package
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Vector3D;

	public class CustomMesh extends MeshData
	{
		public function CustomMesh()
		{
			super();
		}

		public function createMesh( sharedVerts:Vector.<Vector3D>, tris:Vector.<Vector.<VertexData>> ):void
		{
			this.triangles = tris;

			for ( var i:int; i < sharedVerts.length; ++i )
			{
				for ( var j:int = 0; j < tris.length; ++j )
				{
					for each ( var vertex:* in tris[j] )
					{
						if ( vertex.x == sharedVerts[i].x && vertex.y == sharedVerts[i].y && vertex.z == sharedVerts[i].z )
						{
							sharedVertices[ vertex.vector ] = vertex.vector.clone();
						}
					}
				}
			}
		}

		override public function setUVData( texture:Bitmap ):void
		{
			var bmd:BitmapData = new BitmapData( 300, 300, false, 0xFF0000 );
			bmd.fillRect( bmd.rect, 0xFF0000 );
			var bitmap:Bitmap = new Bitmap( bmd );

			for (var i:int = 0; i < triangles.length-1; i += 2)
			{
				// setting a random color for now
				triangles[i][0].setColorData( Math.random(), Math.random(), Math.random() );
				triangles[i][1].setColorData( Math.random(), Math.random(), Math.random() );
				triangles[i][2].setColorData( Math.random(), Math.random(), Math.random() );
				triangles[i+1][0].setColorData( Math.random(), Math.random(), Math.random() );
				// set uv map
				triangles[i][0].setUV( bitmap );
				triangles[i][1].setUV( bitmap, 1, 0 );
				triangles[i][2].setUV( bitmap, 0, 1 );
				triangles[i+1][0].setUV( bitmap, 1, 1 );
			}
		}
	}
}
