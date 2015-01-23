Shader "Custom/MovingPoints" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_S("space", Vector) = (1.0,1.0,1.0,100)
		_F ("freq", Float) = 1
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
		#include "Libs/Transform.cginc"
		#define PI 3.141592
 
		sampler2D _MainTex;
		float4 _S;
		float _F;
		
		half4 _MainTex_TexelSize;
			
		half4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			float
				r1 = rand(i.uv.xy),
				r11 = (1.0-r1*r1)+0.2,
				r2 = rand(i.uv.yx)-0.5,
				r3 = rand(float2(r1,r2))-0.5,
				r4 = rand(float2(r2,r1))-0.5,
				t = frac((_Time.y*r11+r2*10)/_F),
				rad = 2*PI*t;
			
			float3 pos = float3(sin(rad),0,cos(rad))*_S.xyz*_S.w*r11;
			pos = rotateZ(pos,r3*PI);
			pos = rotateY(pos,r4*PI);
			
			return float4(pos,1);
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