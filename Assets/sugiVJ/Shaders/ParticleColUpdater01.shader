Shader "Custom/ParticleColUpdater/color to vcol" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("color", Color) = (0,0,0,0)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		
 		uniform sampler2D _VertColTex;
 		uniform float _Knob05;
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float4 _Color;
			
		float4 frag(v2f_img i) : COLOR{
			return lerp(_Color,tex2D(_VertColTex,i.uv),_Knob05);
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