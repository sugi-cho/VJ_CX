using UnityEngine;
using System.Collections;

public class ParticleStop : MonoBehaviour
{
	public bool autoDestuct;
	// Use this for initialization
	void Start ()
	{
		particleSystem.enableEmission = false;
	}

	void Update ()
	{
		if (autoDestuct && particleSystem.particleCount == 0)
			Destroy (gameObject);
	}
}
