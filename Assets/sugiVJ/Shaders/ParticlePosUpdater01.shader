Shader "Custom/ParticlePosUpdater/noise" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		
 		uniform sampler3D _N3D;
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
			
		float4 frag(v2f_img i) : COLOR{
			float
				px = floor(i.uv.x*256.0)-128.0,
				pz = floor(i.uv.y*256.0)-128.0,
				py = tex3D(_N3D, float3(px/128.0+_Time.x,pz/128.0,_Time.x*0.5+(px+pz)/512.0)).y * 128.0-64.0;
			return float4(px,py,pz,1.0);
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