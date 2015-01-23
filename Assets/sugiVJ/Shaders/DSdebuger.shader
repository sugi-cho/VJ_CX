Shader "Custom/DSdebuger" {
	CGINCLUDE
		#define PI 3.141592
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
		#include "Libs/Transform.cginc"
		
		uniform sampler2D
			_VelTex,
			_VelAdditive,
			_PosTex,
			_PreTex,
			_RotTex,
			_ColTex,
			_VertPosTex,
			_VertColTex,
			_PointsTex;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float4 mvp :TEXCOORD0;
			float3 wPos : TEXCOORD1;
			float3 normal : TEXCOORD2;
			float3 bary : TEXCOORD3;
		};
		struct pOut{
			float4 color : COLOR0; //color.rgb,emission
			float4 normal : COLOR1; //normal.xyz,wire
			float4 position : COLOR2; //pos.xyz,depth
		};
		
		appdata_full localRotate(appdata_full v, float3 rot){
			v.vertex.xyz = rotateY(v.vertex.xyz, rot.y);
			v.vertex.xyz = rotateX(v.vertex.xyz, rot.x);
			v.normal = rotateY(v.normal, rot.y);
			v.normal = rotateX(v.normal, rot.x);
			return v;
		}
		
		v2f vert (appdata_full v)
		{
			v2f o;
			float4 mvp = mul(UNITY_MATRIX_MVP, v.vertex);
			o.pos = mvp;
			o.mvp = mvp;
			o.color = v.color;
			o.wPos = mul(_Object2World, v.vertex);
			o.normal = mul((float3x3)_Object2World, v.normal);
			o.bary = v.color.xyz;
			return o;
		}
			
		pOut frag (v2f i) : COLOR
		{
			float3 d = fwidth(i.bary.xyz);
			float3 a3 = smoothstep(float3(0.0,0.0,0.0), 0.8 * d, i.bary);
			float w = (1.0-saturate(min(min(a3.x, a3.y), a3.z)));
			
			pOut o;
			o.color = i.color;
			o.normal = float4(i.normal.xyz,w);
			o.position = float4(i.wPos.xyz,i.mvp.z);
			return o;
		}
	ENDCG
	
	SubShader {
		Tags {"LightMode" = "Vertex"} 
		Pass {
			CGPROGRAM
			#pragma glsl target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}