using UnityEngine;
using System.Collections;

public class SetTransformPos2Material : MonoBehaviour {
	public string propName = "_CP";
	public Vector4 vector;
	Material m;
	// Use this for initialization
	void Start () {
		m = renderer.material;
		Vector3 vec = transform.InverseTransformPoint(vector.x, vector.y, vector.z);
		vector.x = vec.x; vector.y = vec.y; vector.z = vec.z;
		m.SetVector(propName, vector);
	}
	
	// Update is called once per frame
	void OnDestroy () {
		if(m != null)
			Destroy(m);
	}
}
