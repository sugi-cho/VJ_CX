using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class ParticleController : MonoBehaviour
{
	public Material
		particleMat,
		changeMat;
	public RenderTexture
		velTex,
		vAdTex,
		posTex,
		preTex,
		rotTex,
		colTex;
	public ParticleUpdater[]
		updaters;

	ParticleUpdater
		prev,
		current;
	bool changing;
	RenderTexture rt1, rt2;


	// Use this for initialization
	void Start ()
	{
		updaters = updaters.OrderBy (b => b.name).ToArray ();
		Application.targetFrameRate = 30;

		velTex = Extentions.CreateRenderTexture (256, 256);
		velTex.filterMode = FilterMode.Point;
		vAdTex = Extentions.CreateRenderTexture (256, 256);
		vAdTex.filterMode = FilterMode.Point;
		posTex = Extentions.CreateRenderTexture (256, 256);
		posTex.filterMode = FilterMode.Point;
		preTex = Extentions.CreateRenderTexture (256, 256);
		preTex.filterMode = FilterMode.Point;
		rotTex = Extentions.CreateRenderTexture (256, 256);
		rotTex.filterMode = FilterMode.Point;
		colTex = Extentions.CreateRenderTexture (256, 256);
		colTex.filterMode = FilterMode.Point;
		
		rt1 = Extentions.CreateRenderTexture (256, 256);
		rt1.filterMode = FilterMode.Point;
		rt2 = Extentions.CreateRenderTexture (256, 256);
		rt2.filterMode = FilterMode.Point;

		Shader.SetGlobalTexture ("_VelTex", velTex);
		Shader.SetGlobalTexture ("_VelAdditive", vAdTex);
		Shader.SetGlobalTexture ("_PosTex", posTex);
		Shader.SetGlobalTexture ("_PreTex", preTex);
		Shader.SetGlobalTexture ("_RotTex", rotTex);
		Shader.SetGlobalTexture ("_ColTex", colTex);
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (changing)
			return;
		if (Input.anyKeyDown) {
			foreach (var u in updaters) {
				if (Input.GetKeyDown (u.key) && u != current) {
					switch (u.type) {
					case ChangeType.Quick:
						current = u;
						break;
					case ChangeType.Sync:
						prev = current;
						current = u;
						StartCoroutine (ChangeUpdater (0));
						break;
					case ChangeType.Order:
						prev = current;
						current = u;
						StartCoroutine (ChangeUpdater (1));
						break;
					case ChangeType.Random:
						prev = current;
						current = u;
						StartCoroutine (ChangeUpdater (2));
						break;
					}
					return;
				}
			}
		}
		if (current == null)
			return;
		Graphics.Blit (velTex, rt1);
		Graphics.Blit (rt1, velTex, current.velMat);
		Shader.SetGlobalTexture ("_VelTex", velTex);

		Graphics.Blit (vAdTex, rt1);
		Graphics.Blit (rt1, vAdTex, current.vAdMat);
		Shader.SetGlobalTexture ("_VelAdditive", vAdTex);

		Graphics.Blit (posTex, preTex);
		Shader.SetGlobalTexture ("_PreTex", preTex);

		Graphics.Blit (posTex, rt1);
		Graphics.Blit (rt1, posTex, current.posMat);
		Shader.SetGlobalTexture ("_PosTex", posTex);
		
		Graphics.Blit (rotTex, rt1);
		Graphics.Blit (rt1, rotTex, current.rotMat);
		Shader.SetGlobalTexture ("_RotTex", rotTex);
		
		Graphics.Blit (colTex, rt1);
		Graphics.Blit (rt1, colTex, current.colMat);
		Shader.SetGlobalTexture ("_ColTex", colTex);
	}

	void LerpRT (RenderTexture from, RenderTexture to, RenderTexture target, float t, int pass = 0)
	{
		changeMat.SetTexture ("_FromTex", from);
		changeMat.SetTexture ("_ToTex", to);
		changeMat.SetFloat ("_T", t);
		Graphics.Blit (null, target, changeMat, pass);
	}

	IEnumerator ChangeUpdater (int pass = 0)
	{
		if (prev == null)
			yield break;
		changing = true;
		float t = 0;
		while (t < 1f) {
			Graphics.Blit (velTex, rt1, prev.velMat);
			Graphics.Blit (velTex, rt2, current.velMat);
			LerpRT (rt1, rt2, velTex, t, pass);
			Shader.SetGlobalTexture ("_VelTex", velTex);

			Graphics.Blit (vAdTex, rt1, prev.vAdMat);
			Graphics.Blit (vAdTex, rt2, current.vAdMat);
			LerpRT (rt1, rt2, vAdTex, t, pass);
			Shader.SetGlobalTexture ("_VelAdditive", vAdTex);
			
			Graphics.Blit (posTex, preTex);
			Shader.SetGlobalTexture ("_PreTex", preTex);

			Graphics.Blit (posTex, rt1, prev.posMat);
			Graphics.Blit (posTex, rt2, current.posMat);
			LerpRT (rt1, rt2, posTex, t, pass);
			Shader.SetGlobalTexture ("_PosTex", posTex);
			
			Graphics.Blit (rotTex, rt1, prev.rotMat);
			Graphics.Blit (rotTex, rt2, current.rotMat);
			LerpRT (rt1, rt2, rotTex, t, pass);
			Shader.SetGlobalTexture ("_RotTex", rotTex);
			
			Graphics.Blit (colTex, rt1, prev.colMat);
			Graphics.Blit (colTex, rt2, current.colMat);
			LerpRT (rt1, rt2, colTex, t, pass);
			Shader.SetGlobalTexture ("_ColTex", colTex);

			yield return t += Time.deltaTime;
		}
		changing = false;
	}

	void OnDestroy ()
	{
		Extentions.ReleaseRenderTexture (velTex);
		Extentions.ReleaseRenderTexture (vAdTex);
		Extentions.ReleaseRenderTexture (posTex);
		Extentions.ReleaseRenderTexture (preTex);
		Extentions.ReleaseRenderTexture (rotTex);
		Extentions.ReleaseRenderTexture (colTex);
		Extentions.ReleaseRenderTexture (rt1);
		Extentions.ReleaseRenderTexture (rt2);
	}

	[System.Serializable]
	public class ParticleUpdater
	{
		public string name;
		public KeyCode
			key;
		public Material
			velMat,
			vAdMat,
			posMat,
			rotMat,
			colMat;
		public ChangeType type;
	}
	public enum ChangeType
	{
		Quick = 0,
		Sync = 1,
		Order = 2,
		Random = 3,
	}
}
