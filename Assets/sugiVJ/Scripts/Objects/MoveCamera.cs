using UnityEngine;
using System.Collections;

[RequireComponent(typeof(CameraPosition))]
public class MoveCamera : MonoBehaviour
{
	public float velocity = 0;
	public Vector3 toPos;
	CameraPosition cPos;
	
	void Start ()
	{
		cPos = GetComponent<CameraPosition> ();
	}
	void Update ()
	{
		if (cPos.moving) {
			Transform ct = Camera.main.transform;
			Vector3 fromTo = toPos - ct.position;

			ct.position += Vector3.ClampMagnitude (fromTo, velocity * Time.deltaTime) * MidiJack.GetKnob (2) * 10f;
		}
	}
}
