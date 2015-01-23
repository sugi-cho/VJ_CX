using UnityEngine;
using System.Collections;

public class SetStartTime2Material : MonoBehaviour {
	public string propName = "_DT";
	Material m;
	// Use this for initialization
	void Start () {
		m = renderer.material;
		m.SetFloat(propName, Time.timeSinceLevelLoad);
	}
	
	// Update is called once per frame
	void OnDestroy () {
		if(m != null)
			Destroy(m);
	}
}
