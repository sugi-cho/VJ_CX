using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Camera))]
public class VertToPosTex : MonoBehaviour
{
	public RenderTexture
		posTex,
		colTex;
	public Mesh[] meshes;
	public KeyCode key;
	
	RenderBuffer[] rbs;
	MeshFilter targetFilter;
	int count = 0;

	void Start ()
	{
		posTex = Extentions.CreateRenderTexture (256, 256);
		posTex.filterMode = FilterMode.Point;
		colTex = Extentions.CreateRenderTexture (256, 256);
		colTex.filterMode = FilterMode.Point;

		Shader.SetGlobalTexture ("_VertPosTex", posTex);
		Shader.SetGlobalTexture ("_VertColTex", colTex);

		rbs = new RenderBuffer[2]{posTex.colorBuffer,colTex.colorBuffer};
		targetFilter = GetComponentInChildren<MeshFilter> ();

		InvokeRepeating ("Change", 0.3f, 0.3f);
	}
	void OnDestroy ()
	{
		Extentions.ReleaseRenderTexture (posTex);
		Extentions.ReleaseRenderTexture (colTex);
	}
	
	// Update is called once per frame
	void Change ()
	{
		targetFilter.sharedMesh = meshes [count = (count + 1) % meshes.Length];
	}

	void OnPreRender ()
	{
		Graphics.SetRenderTarget (rbs, posTex.depthBuffer);
	}
	void OnPostRender ()
	{
		Graphics.SetRenderTarget (null);
	}
}
