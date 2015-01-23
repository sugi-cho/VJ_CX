Shader "Custom/CursorVisualize" {
	Properties {
		_Color ("color", Color) = (0.5,0.5,0.5,0.5)
	}
 
	CGINCLUDE
		#include "UnityCG.cginc"
		uniform float4 _MousePos;
		uniform int _ToggleP;
		fixed4 _Color;
		
		struct v2f {
			float4 pos : SV_POSITION;
			float t : TEXCOORD0;
		};
 
		v2f vert (appdata_full v)
		{
			float t = v.vertex.x + v.vertex.y + v.vertex.z;
			t = (t+1)/2;
			
			v.vertex.xyz *= 1000.0;
			float3 pos = _MousePos.xyz;
			v.vertex.xyz += pos;
			
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.t = t;
			return o;
		}
			
		half4 frag (v2f i) : COLOR
		{
			half d = abs(i.t-0.5);
			d = 1.0-2.0*d;
			return _ToggleP*_Color*d*d*d;
		}
	ENDCG
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaTest Greater .01
		Cull Off Lighting Off ZWrite Off
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}
	}
}