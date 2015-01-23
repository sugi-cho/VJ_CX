Shader "Custom/ParticleVelUpdater/vel to target" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_P ("power to target", Float) = 0.1
		_D ("drag", Float) = 1
	}
	CGINCLUDE
		#define PI 3.141592
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
 		
 		uniform sampler3D _N3D;
 		uniform sampler2D _VelTex,_PosTex,_TargetTex;
 		uniform float4 _MousePos,_MainCameraPos;
 		uniform int _MouseButton0;
 		uniform float
 			_Knob08,//to power
 			_Knob09;//drag
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float _L,_P,_D;
		
		float3 noise3D(float3 pos){
			float
				r = tex3D(_N3D, pos.xyz).z-0.5,
				g = tex3D(_N3D, pos.yzx).z-0.49,
				b = tex3D(_N3D, pos.zxy).z-0.5;
			g *= 3;
			return float3(r,g,b);
		}
			
		float4 frag(v2f_img i) : COLOR{
			float4
				pos = tex2D(_PosTex, i.uv),
				vel = tex2D(_VelTex, i.uv),
				target = tex2D(_TargetTex, i.uv);
			float3 to = target.xyz - pos.xyz;
			float
				dist = length(_MousePos.xyz - pos.xyz),
				toPower = _Knob08*10.0,
				drag = _Knob09*10.0;
			vel.xyz = (0.99<target.w)*(vel.xyz*saturate(1.0-drag*unity_DeltaTime) + to*toPower*unity_DeltaTime.x);
			if(target.w < 0.5)
				vel.xyz += noise3D(pos*0.01+_Time.x)*unity_DeltaTime.x*10;
			if(length(pos)>150)
				vel -= pos*1e-6;
			return float4(vel.xyz,target.w);
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