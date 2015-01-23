using UnityEngine;
using System.Collections;

public class GradientTexture : MonoBehaviour
{
	public Gradient gradient;
	public Texture2D output;
	public Material[] targetMats;
	public Renderer[] targetRenderers;
	public string targetPropName;
	public bool
		setToGlobalProp,
		updateTex;

	void UpdateTexture ()
	{
		for (float i = 0; i < 1f; i += 1f/255f) {
			Color c = gradient.Evaluate ((int)(i * 256f));
			output.SetPixel ((int)(i * 256f), 0, c);
		}
		output.Apply ();
	}
	void Awake ()
	{
		output = new Texture2D (256, 1, TextureFormat.ARGB32, false);
		output.filterMode = FilterMode.Bilinear;
		output.wrapMode = TextureWrapMode.Clamp;
	}
	// Use this for initialization
	void Start ()
	{
		UpdateTexture ();
		foreach (var mat in targetMats)
			mat.SetTexture (targetPropName, output);
		foreach (var r in targetRenderers)
			r.material.SetTexture (targetPropName, output);
		if (setToGlobalProp)
			Shader.SetGlobalTexture (targetPropName, output);
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (!updateTex)
			return;
		UpdateTexture ();
		foreach (var mat in targetMats)
			mat.SetTexture (targetPropName, output);
		foreach (var r in targetRenderers)
			r.material.SetTexture (targetPropName, output);
		if (setToGlobalProp)
			Shader.SetGlobalTexture (targetPropName, output);
	}
}
