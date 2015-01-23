Shader "Custom/ParticleRotUpdater/vel = pos - pre" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_L ("limit vel", Float) = 1.0
		_P ("power to target", Float) = 0.1
		_D ("drag", Float) = 1
	}
	CGINCLUDE
		#define PI 3.141592
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
 		
 		uniform sampler3D _N3D;
 		uniform sampler2D _VelTex,_PosTex,_PreTex;
 		uniform float4 _MousePos,_MainCameraPos;
 		uniform int _MouseButton0;
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float _L,_P,_D;
			
		float4 frag(v2f_img i) : COLOR{
			float3
				pos = tex2D(_PosTex, i.uv).xyz,
				pre = tex2D(_PreTex, i.uv).xyz,
				vel = pos - pre,
				target = _MousePos.xyz,
				to = target - pos;
			float dist = length(to);
			vel -= _MouseButton0*100*normalize(to)/(dist*dist);
			return float4(vel,0);
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