using UnityEngine;
using System.Collections;

public class LookTarget : MonoBehaviour {
	public Transform target;
	public string targetName;
	// Use this for initialization
	void Start () {
		Vector3 pos = transform.position;
		pos.z = 0;
		transform.LookAt(pos, transform.up);
	}
	
}
