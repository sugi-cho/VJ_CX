Shader "Custom/ParticlePosUpdater/pos+=vel+curl" {
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
			p *= _S;
			p += float3(0,0,_Time.y*_V);
			float
				cx = (noise3D(p+float3(0,_D,0))-noise3D(p-float3(0,_D,0))).z
					- (noise3D(p+float3(0,0,_D))-noise3D(p-(0,0,_D))).y,
				cy = (noise3D(p+float3(0,0,_D))-noise3D(p-float3(0,0,_D))).x
					- (noise3D(p+float3(_D,0,0))-noise3D(p-(_D,0,0))).z,
				cz = (noise3D(p+float3(_D,0,0))-noise3D(p-float3(_D,0,0))).y
					- (noise3D(p+float3(0,_D,0))-noise3D(p-(0,_D,0))).x;
			return _I*float3(cx,cy,cz)/(2.0*_D);
		}
		
		float4 frag(v2f_img i) : COLOR{
			float4
				pos = tex2D(_PosTex, i.uv),
				vel = tex2D(_VelTex, i.uv);
			
			pos.xyz += vel.xyz;
			pos.xyz += curl(pos.xyz)*(0.5+i.uv.x*i.uv.y);
			pos.xyz = frac(pos.xyz/300.0+0.5) * 300.0-150.0;
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