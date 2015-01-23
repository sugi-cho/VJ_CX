Shader "Custom/AfterEffects" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_pTex ("pre frame", 2D) = "clear"{}
		_bTex ("blur tex", 2D) = "clear"{}
		_MB ("motion blur", Float) = 0
		_CS ("color shift", Float) = 0
		_GL ("glow", Float) = 0.5
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		
 		uniform int
 			_ToggleR, //inverceEffect
 			_MouseButton0,//inverce, too
 			_ToggleT;//toggle triple head
 		uniform float
 			_Knob04,//reverce
 			_Knob07,
 			_Knob13,//motion blur
 			_Knob14,//pixel shift
 			_Knob15;//glow
 		uniform float
 			_Spectrum05, //glow intenity
 			_Spectrum06; //reverse
		uniform sampler2D _DSColTex,_DSNomTex,_DSPosTex;
		
		sampler2D _MainTex,_pTex,_bTex;
		float4 _MainTex_TexelSize;
		float _MB,_CS,_GL;
			
		float4 frag(v2f_img i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif
			float2 
				d = _MainTex_TexelSize.xy,
				shift = d*_CS*_Knob14;
			
			
			float
				dist = distance(float2(i.uv.x,i.uv.y*d.x/d.y),float2(0.5,0.5*d.x/d.y));
			float4
				p = tex2D(_pTex, i.uv);
				
			if(_ToggleT < 1.0){
				if(i.uv.x < 1.0/3.0)
					i.uv.x += 1.0/3.0;
				if(i.uv.x > 2.0/3.0)
					i.uv.x -= 1.0/3.0;
			}
			
			half4
				c = tex2D(_MainTex, i.uv),
				b = tex2D(_bTex, i.uv);
				
			c = lerp(c,b,c.a*dist);
			c += b*b.a*b.a*_GL*pow(10.0,_Knob15*(3.0+_Spectrum05));
			c = lerp(c,c*c*2,_Knob14)*pow(10,_Knob07*3)/10.0;
			
			int r = _Knob04 < _Spectrum06;
			c = c*(1.0-(_ToggleR+_MouseButton0+r)) + (_ToggleR+_MouseButton0+r)*(1.0-c);
			
			return max(float4(0,0,0,0),lerp(c,p,_MB*_Knob13));
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