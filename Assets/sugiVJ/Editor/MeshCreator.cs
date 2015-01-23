using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class MeshCreator
{
	[MenuItem("sugi.cho/Create/Convert2PointMesh")]
	public static void CreatePointMeshForSkinedMesh ()
	{
		var mesh = Selection.activeObject as Mesh;
		if (mesh != null)
			ConvertMesh (mesh);
		if (Selection.activeGameObject != null) {
			var go = Selection.activeGameObject;
			var mfs = go.GetComponentsInChildren<MeshFilter> ();
			var smrs = go.GetComponentsInChildren<SkinnedMeshRenderer> ();
			int count = 0;

			for (var i = 0; i < mfs.Length; i++) {
				mfs [i].sharedMesh = ConvertMesh (mfs [i].sharedMesh, count, mfs [i].renderer.sharedMaterial.mainTexture as Texture2D);
				count += mfs [i].sharedMesh.vertexCount;
			}
			for (var i = 0; i < smrs.Length; i++) {
				smrs [i].sharedMesh = ConvertMesh (smrs [i].sharedMesh, count, smrs [i].sharedMaterial.mainTexture as Texture2D);
				count += smrs [i].sharedMesh.vertexCount;
			}
		}
	}
	[MenuItem("sugi.cho/Edit/CombinePointMeshes")]
	public static void CombinePointMeshes ()
	{
		var go = Selection.activeGameObject;
		if (go == null)
			return;
		go.transform.position = Vector3.zero;


		var mfs = go.GetComponentsInChildren<MeshFilter> ().ToArray ();
		var vCount = mfs.Select (b => b.sharedMesh.vertexCount).Sum ();
		
		Vector3[] vertices = new Vector3[0];
		Vector2[] uv2 = new Vector2[0];
		Color[] colors = new Color[0];
		int[] indeces = new int[vCount];
		for (var i = 0; i < vCount; i++)
			indeces [i] = i;

		for (int i = 0; i < mfs.Length; i++) {
			var mf = mfs [i];
			var m = mf.mesh;
			var vs = m.vertices.Select (b => mf.transform.TransformPoint (b)).ToArray ();
			vertices = vertices.Concat (vs).ToArray ();
			uv2 = uv2.Concat (m.uv2).ToArray ();
			colors = colors.Concat (m.colors).ToArray ();
		}

		var mesh = new Mesh ();
		mesh.vertices = vertices;
		mesh.uv2 = uv2;
		mesh.colors = colors;
		mesh.SetIndices (indeces, MeshTopology.Points, 0);

		AssetDatabase.CreateAsset (mesh, string.Format ("Assets/{0}_combine.asset", go.name));
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();

		new GameObject ("mesh", typeof(MeshFilter), typeof(MeshRenderer)).GetComponent<MeshFilter> ().mesh = mesh;
	}

	static Mesh ConvertMesh (Mesh original, int count = 0, Texture2D tex2d = null)
	{
		int vCount = original.vertexCount;
		
		Mesh mesh = new Mesh ();
		Vector2[] uv2 = new Vector2[vCount];
		int[] indeces = new int[vCount];
		Color[] colors = new Color[vCount];
		
		for (int i = 0; i < vCount; i++) {
			var x = (i + count) % 256;
			var y = (i + count) / 256;
			
			uv2 [i] = new Vector2 ((float)x / 256f, (float)y / 256f);
			indeces [i] = i;
			Debug.Log (tex2d);
			if (tex2d != null)
				colors [i] = tex2d.GetPixelBilinear (original.uv [i].x, original.uv [i].y);
			else
				colors [i] = Color.white;
		}

		mesh.vertices = original.vertices;
		mesh.tangents = original.tangents;
		mesh.normals = original.normals;
		mesh.uv = original.uv;
		mesh.uv2 = uv2;
		mesh.colors = colors;
		mesh.boneWeights = original.boneWeights;
		mesh.SetIndices (indeces, MeshTopology.Points, 0);
		
		AssetDatabase.CreateAsset (mesh, string.Format ("Assets/{0}_PointMesh.asset", original.name));
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();

		return mesh;
	}
}
