using UnityEngine;
using System.Collections;

public class ParticleTarget : MonoBehaviour
{
	public RenderTexture targetTex;
	public TargetAndKey[] targets;

	RenderTexture rt;
	Material mat;

	// Use this for initialization
	void Start ()
	{
		targetTex = Extentions.CreateRenderTexture (256, 256);
		targetTex.filterMode = FilterMode.Point;
		rt = Extentions.CreateRenderTexture (256, 256);
		rt.filterMode = FilterMode.Point;
	}
	void OnDestroy ()
	{
		Extentions.ReleaseRenderTexture (rt);
		Extentions.ReleaseRenderTexture (targetTex);
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (Input.anyKeyDown) 
			foreach (var	t in targets) 
				if (Input.GetKeyDown (t.key))
					mat = t.mat;
		if (mat == null)
			return;

		Graphics.Blit (targetTex, rt);
		Graphics.Blit (rt, targetTex, mat);
		Shader.SetGlobalTexture ("_TargetTex", targetTex);
	}

	[System.Serializable]
	public class TargetAndKey
	{
		public string name = "shape01";
		public KeyCode key;
		public Material mat;
	}
}
