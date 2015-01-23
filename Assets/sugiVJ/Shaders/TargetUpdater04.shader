Shader "Custom/TargetUpdater/to Vert" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		uniform sampler3D _N3D;
 		uniform sampler2D _VertPosTex;
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		float4 frag(v2f_img i) : COLOR{
			half4 tex = tex2D(_MainTex, i.uv);
			float4 pos = tex2D(_VertPosTex,i.uv);
			pos.xyz *=45;
			pos.y -= 35;
			float to = pos.w*(lerp(tex.w,1.0,0.1)+0.01) + (1-pos.w)*lerp(tex.w,-1.0,0.1);
			return float4(pos.xyz,to);
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