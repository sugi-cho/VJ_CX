using UnityEngine;
using System.Collections;

public class MovingPoints : MonoBehaviour
{
	public RenderTexture rt;
	public Material mat;
	public int n = 4;
	// Use this for initialization
	void Start ()
	{
		rt = Extentions.CreateRenderTexture (n, n);
		rt.filterMode = FilterMode.Point;
		Shader.SetGlobalTexture ("_PointsTex", rt);
	}
	void OnDestroy ()
	{
		Extentions.ReleaseRenderTexture (rt);
	}

	void Update ()
	{
		Graphics.Blit (null, rt, mat);
		Shader.SetGlobalTexture ("_PointsTex", rt);
	}
}
