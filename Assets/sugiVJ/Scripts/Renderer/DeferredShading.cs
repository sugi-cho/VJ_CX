using UnityEngine;
using System.Collections;

public class DeferredShading : MonoBehaviour
{
	public RenderTexture
		colTex,
		nomTex,
		posTex;
	public Material clearMat, compMat;
	RenderBuffer[] rbs;

	void CreateBuffers ()
	{
		colTex = Extentions.CreateRenderTexture ((int)camera.pixelWidth, (int)camera.pixelHeight, colTex);
		nomTex = Extentions.CreateRenderTexture ((int)camera.pixelWidth, (int)camera.pixelHeight, nomTex);
		posTex = Extentions.CreateRenderTexture ((int)camera.pixelWidth, (int)camera.pixelHeight, posTex);
		rbs = new RenderBuffer[3]{
			colTex.colorBuffer,
			nomTex.colorBuffer,
			posTex.colorBuffer
		};
		compMat.SetTexture ("_DSColTex", colTex);
		compMat.SetTexture ("_DSNomTex", nomTex);
		compMat.SetTexture ("_DSPosTex", posTex);
	}
	void OnDestroy ()
	{
		Extentions.ReleaseRenderTexture (colTex);
		Extentions.ReleaseRenderTexture (nomTex);
		Extentions.ReleaseRenderTexture (posTex);
	}

	void OnPreRender ()
	{
		if (rbs == null || colTex.width != (int)camera.pixelWidth || colTex.height != (int)camera.pixelHeight)
			CreateBuffers ();
		Graphics.SetRenderTarget (rbs, colTex.depthBuffer);
		clearMat.DrawFullscreenQuad ();
	}
	void OnPostRender ()
	{
		Graphics.SetRenderTarget (null);
		GL.Clear (true, true, Color.black);
		compMat.DrawFullscreenQuad ();
	}
	
	// Update is called once per frame
	void Update ()
	{
	
	}
}
