Shader "Custom/VertPosToTexture" {
	CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float4 wPos : TEXCOORD1;
		};
		struct pOut{
			float4 pos:COLOR0;
			float4 col:COLOR1;
		};
 
		v2f vert (appdata_full v)
		{
			v2f o;
			o.pos = half4(v.texcoord1.xy-0.5,0,0.5);
			o.wPos = mul(_Object2World, v.vertex);
			o.color = v.color;
			return o;
		}
			
		pOut frag (v2f i) : COLOR
		{
			pOut o;
			o.pos = i.wPos;
			o.col = i.color;
			return o;
		}
	ENDCG
	
	SubShader {
		
		Pass {
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}