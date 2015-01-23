Shader "Custom/TextureLerper" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FromTex ("from", 2D) = "black" {}
		_ToTex ("to", 2D) = "black" {}
		_T ("t", Float) = 0
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
		#include "Libs/Easing.cginc"
 		
 		uniform sampler3D _N3D;
		sampler2D _MainTex,_FromTex,_ToTex;
		float4 _MainTex_TexelSize;
		float _T;
			
		float4 fragSync(v2f_img i) : COLOR{
			float4
				from = tex2D(_FromTex, i.uv),
				to = tex2D(_ToTex, i.uv);
			float t = _T;
			return lerp(from,to,saturate(t));
		}
		
		float4 fragOrder(v2f_img i) : COLOR{
			float4
				from = tex2D(_FromTex, i.uv),
				to = tex2D(_ToTex, i.uv);
			float
				id = i.uv.x + i.uv.y*256.0,
				t = _T*2.0-id/256.0;
			return lerp(from,to,saturate(easeOutBack(t)));
		}
		
		float4 fragRandom(v2f_img i) : COLOR{
			float4
				from = tex2D(_FromTex, i.uv),
				to = tex2D(_ToTex, i.uv);
			float 
				r = rand(i.uv),
				t = _T*2.0-saturate(r);
			return lerp(from,to,saturate(t));
		}
		
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment fragSync
			ENDCG
		}
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment fragOrder
			ENDCG
		}
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment fragRandom
			ENDCG
		}
	} 
}