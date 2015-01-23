using UnityEngine;
using UnityEditor;
using System.Collections;


public class CreateCursor
{

	[MenuItem("sugi.cho/Create/CursorMesh")]
	public static void CreateMesh ()
	{
		Mesh m = new Mesh ();
		Vector3[] vertices = new Vector3[]{
			Vector3.left,Vector3.right,
			Vector3.down,Vector3.up,
			Vector3.back,Vector3.forward
		};
		int[] indeces = new int[]{
			0,1,2,3,4,5
		};
		m.vertices = vertices;
		m.SetIndices (indeces, MeshTopology.Lines, 0);

		AssetDatabase.CreateAsset (m, "Assets/Cursor.asset");
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();

		Selection.activeObject = m;
	}
}
