using UnityEngine;
using System.Collections;

public class SetVector2Material : MonoBehaviour {
	public Renderer targetRenderer;
	public string propName = "_P";
	Material m;
	Vector3 point;
	void Awake(){
		point = transform.position;
		m = targetRenderer.material;
		m.SetVector(propName, point);
	}
	
	void OnDestroy(){
		if(m != null)
			Destroy(m);
	}
}
