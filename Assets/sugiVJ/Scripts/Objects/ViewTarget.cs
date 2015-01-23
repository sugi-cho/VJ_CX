using UnityEngine;
using System.Collections;

public class ViewTarget : MonoBehaviour
{
	public float viewDistance = 5f;
	// Use this for initialization
	void Start ()
	{
		tag = MainController.Tags.viewTarget;
	}
}
