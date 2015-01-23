using UnityEngine;
using System.Collections;

public class ShaderMainCameraPos : MonoBehaviour
{
	Vector3 p;
	float mDown0, mDown1;
	// Update is called once per frame
	void Update ()
	{
		Screen.showCursor = false;
		p = Input.mousePosition;
		p.z = 30f;
		p = Camera.main.ScreenToWorldPoint (p);
//		p += 10f * (Vector3.right * Mathf.Sin (Time.timeSinceLevelLoad * 3f) + Vector3.forward * Mathf.Sin (Time.timeSinceLevelLoad * 4f) + Vector3.up * Mathf.Cos (Time.timeSinceLevelLoad * 5f));

		Shader.SetGlobalVector ("_MainCameraPos", Camera.main.transform.position);
		Shader.SetGlobalVector ("_MainCameraCenterPos", Camera.main.transform.position + Camera.main.transform.forward * 10f);
		Shader.SetGlobalVector ("_MousePos", p);
		Shader.SetGlobalFloat ("_MouseDownTime0", Input.GetMouseButton (0) ? mDown0 += Time.deltaTime : mDown0 = 0);
		Shader.SetGlobalInt ("_MouseButton0", Input.GetMouseButtonDown (0) ? 1 : 0);
		Shader.SetGlobalFloat ("_MouseDownTime1", Input.GetMouseButton (1) ? mDown1 += Time.deltaTime : mDown1 = 0);
		Shader.SetGlobalInt ("_MouseButton1", Input.GetMouseButtonDown (1) ? 1 : 0);

		Time.timeScale = Input.GetKey (KeyCode.LeftShift) ? 0 : 1f;
	}
}
