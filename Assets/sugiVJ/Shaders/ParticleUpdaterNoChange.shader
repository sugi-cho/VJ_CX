Shader "Custom/ParticleUpdater/NoChange" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			
			return tex2D(_MainTex, i.uv);
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}