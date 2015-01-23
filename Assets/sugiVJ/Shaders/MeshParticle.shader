Shader "Custom/MeshParticle" {
	Properties {
		_MainTex ("texture", 2D) = "white" {}
		_LP ("light props", Vector) = (0,1.0,0,0)
	}
 
	CGINCLUDE
		#define PI 3.1415
		#include "UnityCG.cginc"
		#include "Libs/Random.cginc"
		#include "Libs/Transform.cginc"
		#include "Libs/Noise.cginc"
		
		sampler2D _MainTex;
		float4 _LP;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 texcoord : TEXCOORD0;
			float4 sPos : TEXCOORD1;
			float3 wPos : TEXCOORD2;
			float3 normal : TEXCOORD3;
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
				px = floor(frac(id/256.0)*256.0),
				pz = floor(id/256.0),
				py = snoise(float2(px/64+_Time.x,pz/64))*16+snoise(float2(px/32+_Time.x,pz/32))*8;
			
			v = localRotate(v,float3(_Time.y-id/100,id/100+_Time.y,0));
			v.vertex.xyz += float3(px-128.0,py,pz-128.0);
			
			float3 lightColor = ShadeVertexLights(v.vertex,v.normal);
			v.color.rgb *= lightColor;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = v.color;
			o.texcoord = v.texcoord;
			o.sPos = ComputeScreenPos(o.pos);
			o.wPos = mul(_Object2World, v.vertex);
			o.normal = mul((float3x3)_Object2World, v.normal);
			return o;
		}
			
		float4 frag (v2f i) : COLOR
		{
			float4 c = i.color;
			
			float3
				viewDir = _WorldSpaceCameraPos - i.wPos,
				h = normalize(normalize(_LP.xyz-i.wPos) + normalize(viewDir));
			float nh = max(0,dot(i.normal, h));
			
			c.a = max(0,1.0-i.sPos.w/100);
			c += pow(nh,_LP.w) * 10.0*c.a;
			c.rgb *= c.a;
			
			return c;
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