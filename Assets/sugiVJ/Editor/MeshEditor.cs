using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class CubeParticle
{

	[MenuItem("sugi.cho/Create/ParticleMesh")]
	public static void CreateParticleMesh ()
	{
		foreach (var o in Selection.objects) {
			Mesh mesh = (Mesh)o;
			if (mesh != null) {
				var count = 0;
				for (var i = 0; i < 100; i++) {
					count = CreateParticleFromMesh (mesh, count);
				}
			}
		}
	}
	[MenuItem("sugi.cho/Edit/BigBoundMesh")]
	public static void BigBound ()
	{
		foreach (var o in Selection.objects) {
			Mesh mesh = (Mesh)o;
			if (mesh != null) {
				SetBigBounds (mesh);
			}
		}
	}
	[MenuItem("sugi.cho/Create/PointParticle")]
	public static void CreatePointParticles ()
	{
		Mesh mesh = new Mesh ();
		Vector3[] vertices = new Vector3[65000];
		Vector2[] uv = new Vector2[65000];
		int[] indices = new int[65000];
		
		for (int i = 0; i < 65000; i++) {
			float
			x = i % 256f,
			y = i / 256f;
			
			vertices [i] = Random.insideUnitSphere;
			uv [i] = new Vector2 (x / 256f, y / 256f);
			indices [i] = i;
		}
		mesh.vertices = vertices;
		mesh.uv = uv;
		mesh.SetIndices (indices, MeshTopology.Points, 0);
		
		AssetDatabase.CreateAsset (mesh, "Assets/PointParticle256x256.asset");
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
		
		Selection.activeObject = mesh;
	}
	[MenuItem("sugi.cho/Edit/CombineMesh")]
	public static void CombineMesh ()
	{
		GameObject go = Selection.activeGameObject;
		if (go == null)
			return;
		MeshCombiner.Combine (go);
	}
	[MenuItem("sugi.cho/Edit/Randomize Mesh.uv2.y")]
	public static void RandomUV2Y ()
	{
		foreach (var o in Selection.objects) {
			Mesh m = o as Mesh;
			if (m != null) {
				var uv2 = m.uv2;
				var y = Random.value;
				for (var i = 0; i < uv2.Length; i++) {
					uv2 [i].y = y;
				}
				m.uv2 = uv2;
			}
		}
	}
	
	static int CreateParticleFromMesh (Mesh mesh, int count = 0)
	{
		int count0 = count;
		int[] indices0 = mesh.GetIndices (0);

		int 
		vCount = mesh.vertexCount,
		iCount = indices0.Length,
		numParticles = Mathf.NextPowerOfTwo (65000 / vCount / 2);


		float log2 = Mathf.Log (numParticles, 2f);

		int
		numVerts = numParticles * vCount,
		numIndices = numParticles * iCount,
		numX = Mathf.FloorToInt (log2 / 2f),
		numY = (int)log2 - numX;

		numX = (int)Mathf.Pow (2f, numX);
		numY = (int)Mathf.Pow (2f, numY);

		Mesh newMesh = new Mesh ();
		int[] indices = new int[numIndices];

		Vector2[]
		uv1 = new Vector2[numVerts],
		uv2 = new Vector2[numVerts];

		Vector3[]
		vertices = new Vector3[numVerts];
//		normals = new Vector3[numVerts];

		for (int y = 0; y < numY; y++) {
			for (int x = 0; x < numX; x++) {
				int index = x + y * numX;
				for (int i = 0; i < vCount; i++) {
					vertices [index * vCount + i] = mesh.vertices [i];
					uv1 [index * vCount + i] = mesh.uv [i];
					uv2 [index * vCount + i] = new Vector2 ((float)count + 0.5f, Random.value);
					//uv2 [index * vCount + i] = new Vector2 ((float)x / (float)numX, (float)y / (float)numY);
				}
				count++;
				for (int i = 0; i < iCount; i++)
					indices [index * iCount + i] = indices0 [i] + index * vCount;
			}
		}
		newMesh.vertices = vertices;
		newMesh.uv = uv1;
		newMesh.uv2 = uv2;
		newMesh.SetIndices (indices, MeshTopology.Triangles, 0);
		newMesh.RecalculateNormals ();
		SetBigBounds (newMesh);

		AssetDatabase.CreateAsset (newMesh, string.Format ("Assets/{0}_{1}_{2}_particle.asset", mesh.name, count0, count));
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();

		return count;
	}

	static void SetBigBounds (Mesh m)
	{
		m.bounds = new Bounds (Vector3.zero, Vector3.one * 100f);
	}

}
