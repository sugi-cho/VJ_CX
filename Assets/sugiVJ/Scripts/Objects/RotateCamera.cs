using UnityEngine;
using System.Collections;

[RequireComponent(typeof(CameraPosition))]
public class RotateCamera : MonoBehaviour
{
	public float velocity = 0;
	CameraPosition cPos;

	void Start ()
	{
		cPos = GetComponent<CameraPosition> ();
	}
	void Update ()
	{
		if (cPos.moving)
			Camera.main.transform.RotateAround (Vector3.zero, Vector3.up, velocity * Time.deltaTime * MidiJack.GetKnob (2) * 10f);
	}
}
