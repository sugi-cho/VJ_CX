using UnityEngine;
using System.Collections;

public class Time2Die : MonoBehaviour {
	public float destroyTime = 300f;
	// Use this for initialization
	public void DestroyAt(float t){
		CancelInvoke("DestroyObject");
		Invoke("DestroyObject", t);
	}
	
	void Start () {
		DestroyAt(destroyTime);
	}
	void DestroyObject(){
		Destroy(gameObject);
	}
}
