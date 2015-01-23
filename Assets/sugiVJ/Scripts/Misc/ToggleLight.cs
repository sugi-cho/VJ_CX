using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Light))]
public class ToggleLight : MonoBehaviour
{
	public KeyCode key;
	public bool defaultVal;

	void Start ()
	{
		light.enabled = defaultVal;
	}
	// Update is called once per frame
	void Update ()
	{
		if (Input.GetKeyDown (key))
			light.enabled = !light.enabled;
	}
}
