using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class CameraController : MonoBehaviour
{
	public CameraPosition current;
	public KeyCode randomKey;
	Dictionary<KeyCode,CameraPosition> camPosMap = new Dictionary<KeyCode, CameraPosition> ();
	// Use this for initialization
	void Start ()
	{
		foreach (var cp in GetComponentsInChildren<CameraPosition>()) {
			camPosMap.Add (cp.key, cp);
		}
		if (current == null)
			current = GetComponentInChildren<CameraPosition> ();
		SetPosition (current);
	}

	// Update is called once per frame
	void Update ()
	{
		if (Input.anyKeyDown) {
			if (Input.GetKeyDown (randomKey))
				SetPosition (camPosMap.Values.ToArray () [Random.Range (0, camPosMap.Count)]);
			foreach (var k in camPosMap.Keys) {
				if (Input.GetKeyDown (k)) {
					if (current == camPosMap [k])
						current.moving = !current.moving;
					else
						SetPosition (camPosMap [k]);
				}
			}
		}

	}

	void SetPosition (CameraPosition cPos)
	{
		current.moving = false;
		current = cPos;
		current.moving = true;
		Transform ct = Camera.main.transform;
		ct.position = cPos.Position ();
		ct.rotation = cPos.Rotation ();
	}
}
