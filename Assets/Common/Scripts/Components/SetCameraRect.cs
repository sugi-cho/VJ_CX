using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Camera))]
public class SetCameraRect : MonoBehaviour
{
	public int cameraNum = 0;
//	[HideInInspector]
	//public Vector2 rectRate;
	[HideInInspector]
	public float
		camHight = 1f,
		offsetY = 0,
		angle = 90f,
		fov = 36f;
	
	bool edit;
	
	public void SetCameraProp (float cH, float oY, float a, float f, int numCams)
	{
		//rectRate = rate;
		camHight = cH;
		offsetY = oY;
		angle = a;
		fov = f;
		
		if (cameraNum < numCams) {
			camera.enabled = true;
			SetCameraProp (numCams);
		} else {
			camera.rect = Rect.MinMaxRect (0.5f, 0.5f, 0.5f, 0.5f);
			camera.enabled = false;
		}
	}
	// Use this for initialization
	void SetCameraProp (int numCams)
	{
		Rect rect = camera.rect;
		rect.width = 1f / (float)numCams;
		rect.height = camHight;
		rect.x = (float)cameraNum / (float)numCams;

		rect.y = offsetY;
		camera.rect = rect;
		camera.fieldOfView = fov;
		
		transform.rotation = Quaternion.Euler (0, angle * (float)cameraNum, 0);
	}
}