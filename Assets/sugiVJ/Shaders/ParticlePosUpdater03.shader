Shader "Custom/ParticlePosUpdater/pos+=vel" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
 		
 		uniform sampler3D _N3D;
 		uniform sampler2D _VelTex,_PosTex,_VelAdditive;
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
			
		float4 frag(v2f_img i) : COLOR{
			float4
				pos = tex2D(_PosTex, i.uv),
				vel = tex2D(_VelTex, i.uv),
				vAd = tex2D(_VelAdditive, i.uv);
			
			pos.xyz += vel.xyz+vAd.xyz;
//			pos.xyz = frac(pos.xyz/600.0+0.5) * 600.0-300.0;
			pos.w = vel.w;
			return pos;
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