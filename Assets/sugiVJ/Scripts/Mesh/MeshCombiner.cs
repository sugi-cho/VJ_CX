using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class MeshCombiner : MonoBehaviour
{
	public static void Combine (GameObject go)
	{
		go.AddComponent<MeshCombiner> ().CombineMesh ();
		DestroyImmediate (go.GetComponent<MeshCombiner> ());
	}
	public Material m;
	public bool autoCombine = true;
	int count = 0;
	
	void Start ()
	{
		if (autoCombine)
			CombineMesh ();
	}
	
	void CombineMesh ()
	{
		if (m == null) {
			m = GetComponentInChildren<MeshFilter> ().renderer.sharedMaterial;
		}
		CombineInstance[] cis = GetComponentsInChildren<MeshFilter> ().Select (b => {
			CombineInstance instance = new CombineInstance ();
			instance.mesh = b.sharedMesh;
			instance.transform = b.transform.localToWorldMatrix;
			b.gameObject.SetActive (false);
			return instance;
		}).ToArray ();
		
		Debug.Log (cis.Length);
		
		List<CombineInstance> list = new List<CombineInstance> ();
		int vertsCount = 0;
		
		for (int i = 0; i < cis.Length; i++) {
			CombineInstance ci = cis [i];
			if (ci.mesh == null)
				continue;
			vertsCount += ci.mesh.vertexCount;
			
			if (vertsCount > 65000) {
				AddChildMesh (list.ToArray ());
				vertsCount = ci.mesh.vertexCount;
				list.Clear ();
			}
			
			list.Add (ci);
		}
		AddChildMesh (list.ToArray ());
	}
	
	void AddChildMesh (CombineInstance[] cis)
	{
		Mesh mesh = new Mesh ();
		mesh.CombineMeshes (cis);
		GameObject go = new GameObject ("mesh");
		go.transform.parent = transform;
		go.AddComponent<MeshFilter> ().mesh = mesh;
		go.AddComponent<MeshRenderer> ().material = m;
		
		#if UNITY_EDITOR
		AssetDatabase.CreateAsset (mesh, "Assets/" + name + "_combined_" + count.ToString ("00") + ".asset");
		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();
		count++;
		#endif
	}
}
