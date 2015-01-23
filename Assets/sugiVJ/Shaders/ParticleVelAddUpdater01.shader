Shader "Custom/ParticleVelAddUpdater/curl" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_S ("noise scale", Float) = 1
		_V ("noise velocity", Float) = 1
		_I ("noise intencity", Float) = 0.1
		_D ("micro delta", Float) = 0.01
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
 		
 		uniform sampler3D _N3D;
 		uniform sampler2D _VelTex,_PosTex;
 		uniform float _Knob10,_Knob11,_Knob12;
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float _S,_V,_I,_D;
		
		float3 noise3D(float3 p){
			float3 n = float3(
				tex3D(_N3D, p.xyz).z,
				tex3D(_N3D, p.yzx).z,
				tex3D(_N3D, p.zxy).z
			);
			return n;
		}
		
		float3 curl(float3 p){
			float
				nScale = pow(10,2*_Knob10-3),
				nSpeed = pow(10,2*_Knob11-2),
				nIntensity = pow(10,-2*_Knob10) * _Knob12;
			
			p *= nScale;
			p += float3(0,0,_Time.y*nSpeed);
			float
				cx = (noise3D(p+float3(0,_D,0))-noise3D(p-float3(0,_D,0))).z
					- (noise3D(p+float3(0,0,_D))-noise3D(p-(0,0,_D))).y,
				cy = (noise3D(p+float3(0,0,_D))-noise3D(p-float3(0,0,_D))).x
					- (noise3D(p+float3(_D,0,0))-noise3D(p-(_D,0,0))).z,
				cz = (noise3D(p+float3(_D,0,0))-noise3D(p-float3(_D,0,0))).y
					- (noise3D(p+float3(0,_D,0))-noise3D(p-(0,_D,0))).x;
			return nIntensity*float3(cx,cy,cz)/(2.0*_D);
		}
		
		float4 frag(v2f_img i) : COLOR{
			float4
				pos = tex2D(_PosTex, i.uv),
				vel = tex2D(_VelTex, i.uv);
			float3 c = curl(pos.xyz);
			return float4(c,0);
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