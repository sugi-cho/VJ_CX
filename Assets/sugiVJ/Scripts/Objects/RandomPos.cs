using UnityEngine;
using System.Collections;

public class RandomPos : MonoBehaviour
{
	public float radiusMax = 120f;
	CameraPosition cPos;
	// Use this for initialization
	void Start ()
	{
		cPos = GetComponent<CameraPosition> ();
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (cPos.moving && MidiJack.GetKnob (1) < AudioInput.DeltaLevel)
			SetCamera ();
	}

	void SetCamera ()
	{
		Camera cam = Camera.main;
		var pos = Random.insideUnitSphere * radiusMax;
		pos.y *= 0.5f;
		cam.transform.position = pos;
		cam.transform.LookAt (Vector3.zero);
	}
}
