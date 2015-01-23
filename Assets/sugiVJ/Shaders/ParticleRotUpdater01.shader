Shader "Custom/ParticleRotUpdater/rotate with id" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#define PI 3.141592
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
 		
 		uniform sampler3D _N3D;
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
			
		float4 frag(v2f_img i) : COLOR{
			float rad = floor(i.uv.y*256.0)+i.uv.x;
			rad *= 3.0;
			float
				rx = _Time.y - rad,
				rz = 0,
				ry = rad+_Time.y;
			float4 rot = float4(rx,ry,rz,1.0);
			rot = frac(rot/(PI*2.0))*PI*2.0;
			return rot;
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