Shader "Custom/ParticleUpdater/Color" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("color", Color) = (0,0,0,0)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float4 _Color;
			
		float4 frag(v2f_img i) : COLOR{
			return _Color;
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