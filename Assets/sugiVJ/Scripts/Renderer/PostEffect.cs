using UnityEngine;
using System.Collections;

public class PostEffect : MonoBehaviour
{
	public RenderTexture
		blurTex,
		finalTex,
		preTex;
	public Material
		effectMat;
	public float 
		blurSize = 1f;
	public int
		blurIter = 3,
		blurDS = 1;
	void OnRenderImage (RenderTexture s, RenderTexture d)
	{
		if (finalTex == null || finalTex.width != s.width || finalTex.height != s.height) {
			blurTex = Extentions.CreateRenderTexture (s, blurTex);
			finalTex = Extentions.CreateRenderTexture (s, finalTex);
			preTex = Extentions.CreateRenderTexture (s, preTex);
		}
		Graphics.Blit (s, blurTex);
		blurTex.GetBlur (blurSize, blurIter, blurDS);

		effectMat.SetTexture ("_bTex", blurTex);
		effectMat.SetTexture ("_pTex", preTex);
		Graphics.Blit (s, finalTex, effectMat);
		Graphics.Blit (finalTex, preTex);
		Graphics.Blit (finalTex, d);
	}
}
