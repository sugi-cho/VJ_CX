Shader "Custom/TargetUpdater/noise pattern" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		uniform sampler3D _N3D;
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		float4 frag(v2f_img i) : COLOR{
			half4 tex = tex2D(_MainTex,i.uv);
			float
				px = floor(i.uv.x*256.0)-128.0,
				pz = floor(i.uv.y*256.0)-128.0,
				py = tex3D(_N3D, float3(px/128.0+_Time.x,pz/128.0,_Time.x*0.5+(px+pz)/512.0)).y * 128.0-64.0;
			return float4(px,py,pz,lerp(tex.w,1.0,0.1)+0.01);
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