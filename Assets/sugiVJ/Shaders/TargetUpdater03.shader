Shader "Custom/TargetUpdater/to nearest point" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
 		uniform sampler3D _N3D;
 		uniform sampler2D _PreTex,_PointsTex;
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		
		struct v2f{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			
			float3 p00 : TEXCOORD1;
			float3 p01 : TEXCOORD2;
			float3 p02 : TEXCOORD3;
			float3 p03 : TEXCOORD4;
			float3 p04 : TEXCOORD5;
			float3 p05 : TEXCOORD6;
			float3 p06 : TEXCOORD7;
			float3 p07 : TEXCOORD8;
			float3 p08 : TEXCOORD9;
			float3 p09 : TEXCOORD10;
			float3 p10 : TEXCOORD11;
			float3 p11 : TEXCOORD12;
			float3 p12 : TEXCOORD13;
			float3 p13 : TEXCOORD14;
			float3 p14 : TEXCOORD15;
			float3 p15 : TEXCOORD16;
		};
		
		v2f vert(appdata_img v){
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = MultiplyUV( UNITY_MATRIX_TEXTURE0, v.texcoord );
			
			o.p00 = tex2Dlod(_PointsTex, float4(0.5/4.0,0.5/4.0,0,0)).xyz;
			o.p01 = tex2Dlod(_PointsTex, float4(1.5/4.0,0.5/4.0,0,0)).xyz;
			o.p02 = tex2Dlod(_PointsTex, float4(2.5/4.0,0.5/4.0,0,0)).xyz;
			o.p03 = tex2Dlod(_PointsTex, float4(3.5/4.0,0.5/4.0,0,0)).xyz;
			o.p04 = tex2Dlod(_PointsTex, float4(0.5/4.0,1.5/4.0,0,0)).xyz;
			o.p05 = tex2Dlod(_PointsTex, float4(1.5/4.0,1.5/4.0,0,0)).xyz;
			o.p06 = tex2Dlod(_PointsTex, float4(2.5/4.0,1.5/4.0,0,0)).xyz;
			o.p07 = tex2Dlod(_PointsTex, float4(3.5/4.0,1.5/4.0,0,0)).xyz;
			
			o.p08 = tex2Dlod(_PointsTex, float4(0.5/4.0,2.5/4.0,0,0)).xyz;
			o.p09 = tex2Dlod(_PointsTex, float4(1.5/4.0,2.5/4.0,0,0)).xyz;
			o.p10 = tex2Dlod(_PointsTex, float4(2.5/4.0,2.5/4.0,0,0)).xyz;
			o.p11 = tex2Dlod(_PointsTex, float4(3.5/4.0,2.5/4.0,0,0)).xyz;
			o.p12 = tex2Dlod(_PointsTex, float4(0.5/4.0,3.5/4.0,0,0)).xyz;
			o.p13 = tex2Dlod(_PointsTex, float4(1.5/4.0,3.5/4.0,0,0)).xyz;
			o.p14 = tex2Dlod(_PointsTex, float4(2.5/4.0,3.5/4.0,0,0)).xyz;
			o.p15 = tex2Dlod(_PointsTex, float4(3.5/4.0,3.5/4.0,0,0)).xyz;
			
			return o;
		}
		
			
		float4 frag(v2f i) : COLOR{
			float
				r1 = rand(i.uv.xy)-0.5,
				r2 = rand(i.uv.yx)-0.5,
				r3 = rand(float2(r1,r2))-0.5,
				r4 = rand(float2(r2,r1));
			
			half4 tex = tex2D(_MainTex, i.uv);
			half3
				pos = tex2D(_PreTex,i.uv).xyz,
				toPos = 0;
			float d = 10000;
			if(length(i.p00 - pos) < d)
				toPos = i.p00;
			if(length(i.p01 - pos) < length(toPos-pos))
				toPos = i.p01;
			if(length(i.p02 - pos) < length(toPos-pos))
				toPos = i.p02;
			if(length(i.p03 - pos) < length(toPos-pos))
				toPos = i.p03;
			if(length(i.p04 - pos) < length(toPos-pos))
				toPos = i.p04;
			if(length(i.p05 - pos) < length(toPos-pos))
				toPos = i.p05;
			if(length(i.p06 - pos) < length(toPos-pos))
				toPos = i.p06;
			if(length(i.p07 - pos) < length(toPos-pos))
				toPos = i.p07;
			
			if(length(i.p08 - pos) < length(toPos-pos))
				toPos = i.p08;
			if(length(i.p09 - pos) < length(toPos-pos))
				toPos = i.p09;
			if(length(i.p10 - pos) < length(toPos-pos))
				toPos = i.p10;
			if(length(i.p11 - pos) < length(toPos-pos))
				toPos = i.p11;
			if(length(i.p12 - pos) < length(toPos-pos))
				toPos = i.p12;
			if(length(i.p13 - pos) < length(toPos-pos))
				toPos = i.p13;
			if(length(i.p14 - pos) < length(toPos-pos))
				toPos = i.p14;
			if(length(i.p15 - pos) < length(toPos-pos))
				toPos = i.p15;
			
			return float4(lerp(pos,toPos+float3(r1,r2,r3)*10,r4*r4*0.9+0.1),lerp(tex.w,1.0,0.1)+0.01);
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }
 
		pass{
			CGPROGRAM
			#pragma glsl target 3.0
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	} 
}