Shader "Custom/MeshParticle tex" {
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
			float 
				id = v.texcoord1.x,
				x = frac(id/256.0),
				y = floor(id/256.0)/256.0;
			float2
				uv = float2(x,y);
			float4
				pos = tex2Dlod(_PosTex,float4(uv,0,0)),
				vel = tex2Dlod(_VelTex,float4(uv,0,0)),
				vAd = tex2Dlod(_VelAdditive,float4(uv,0,0)),
				pre = pos-vel-vAd,
				rot = tex2Dlod(_RotTex,float4(uv,0,0)),
				col = tex2Dlod(_ColTex,float4(uv,0,0));
			
			v = localRotate(v, rot.xyz);
			if(pos.a<0)
				v.vertex.xyz = rotateX(v.vertex.xyz, abs(pos.a)*10);
			float3
				dist = pre.xyz - pos.xyz,
				center = (pre.xyz+pos.xyz)/2.0;
			if(length(pos.xyz-center-v.vertex.xyz) > length(pre.xyz-center-v.vertex.xyz)){
				float speed = length(dist);
				v.vertex.xyz += normalize(dist)*min(speed,4.0);
				v.vertex.xyz *= 2.0/(2.0+min(speed*0.5,4.0));
			}
			
			v.vertex.xyz += pos.xyz + max(0,1.0-pos.a)*v.normal;
			
			v2f o;
			float4 mvp = mul(UNITY_MATRIX_MVP, v.vertex);
			o.pos = mvp;
			o.mvp = mvp;
			o.color = col;
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