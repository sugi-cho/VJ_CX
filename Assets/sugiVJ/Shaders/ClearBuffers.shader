Shader "Custom/ClearBuffers" {
	Properties {
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		ZTest Always
		ZWrite On
		Cull Back

		CGINCLUDE


		struct appdata
		{
			float4 vertex : POSITION;
		};

		struct v2f {
			float4 vertex : SV_POSITION;
		};

		struct pOut{
			float4 color : COLOR0; //color.rgb,emission
			float4 normal : COLOR1; //normal.xyz,wire
			float4 position : COLOR2; //pos.xyz,depth
		};


		v2f vert (appdata v)
		{
			v2f o;
			o.vertex = v.vertex;
			return o;
		}

		pOut frag (v2f i)
		{
			pOut o;
			o.color = 0.0;
			o.normal = 0.0;
			o.position = float4(0.0,0.0,0.0,1000.0);
			return o;
		}
		ENDCG

	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		#pragma glsl
		ENDCG
	}
	} 
}