Shader "Custom/TargetUpdater/rasen pattern" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		uniform sampler3D _N3D;
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
			
		float4 frag(v2f_img i) : COLOR{
			half4 tex = tex2D(_MainTex, i.uv);
			float rad = floor(i.uv.y*256.0)+i.uv.x;
			rad = sqrt(rad)*60.0;
			float
				px = rad*cos(rad)*0.15,
				pz = rad*sin(rad)*0.15,
				py = sin(rad*3.14*2+_Time.y)*rad/60;
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