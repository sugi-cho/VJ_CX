Shader "Custom/ParticleVelUpdater/slow down" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Brake ("brake", Float) = 0
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		
 		uniform float _Knob10;
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		float _Brake;
			
		half4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			float4 ret = tex2D(_MainTex, i.uv);
			ret.xyz *= max(0, 1.0-_Brake*unity_DeltaTime.x);
			return ret;
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