Shader "Custom/Squares" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Scale ("scale", Float) = 100
		_Size ("size", Range(0,0.5)) = 0.4
		_C ("color", Color) = (1.0,1.0,1.0,1.0)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Libs/PhotoshopMath.cginc"
 
		uniform sampler3D
			_N3D;
		uniform sampler2D
			_SpectrumTex;
		uniform float
			_AudioLevel, _SmoothAudioLevel, _DeltaLevel, _AudioTime,
			_Spectrum00,_Spectrum01,_Spectrum02,_Spectrum03,_Spectrum04,
			_Spectrum05,_Spectrum06,_Spectrum07,_Spectrum08,_Spectrum09,
			_Knob00, _Knob01, _Knob02, _Knob03,
			_Knob04, _Knob05, _Knob06, _Knob07,
			_Knob08, _Knob09, _Knob10, _Knob11,
			_Knob12, _Knob13, _Knob14, _Knob15;
		uniform int
			_NumSpectrum;
		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float _Scale, _Size;
		float4 _C;
		
		float rand( float2 co ){
			return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
		}
		float3 rand3( float2 seed ){
			float t = sin(seed.x + seed.y * 1e3);
			return float3(frac(t*1e4), frac(t*1e6), frac(t*1e5));
		}
		
		float4 square(float2 pos, float2 pos2, float size, float h, sampler2D tex, float scale){
			float t = _Time.y + rand(pos2+h);
			float4 c = 0;
			float2 center = pos2 + rand3(pos2 + float2(floor(t)/h*0.3,h)*pos2).xy;
			float2 center2 = center / scale;
			center2.x /= _MainTex_TexelSize.y/_MainTex_TexelSize.x;
			
			t = frac(t);
			c = tex2D(tex, center2);
			size *= t * length(c);
			c *= saturate(size - abs(pos.x - center.x)) * saturate(size - abs(pos.y - center.y)) > 0;
			
			float3 hsl = RGBToHSL(c.rgb);
			hsl.x += (_AudioLevel -0.5)*0.8;
			c.rgb = HSLToRGB(hsl);
			
			return c * (1-t)*4;
		}
		
		
		float4 squares(float2 pos, sampler2D tex, float scale, float size, fixed num){
			float4 c = 0;
			pos.x *= _MainTex_TexelSize.y/_MainTex_TexelSize.x;
			pos *= scale;
			float2
				fl = floor(pos),
				cl = ceil(pos),
				p1 = fl,
				p2 = float2(fl.x, cl.y),
				p3 = float2(cl.x, fl.y),
				p4 = cl,
				
				p5 = p1 + float2(-1,0),
				p6 = p1 + float2(0,-1),
				p7 = p1 + float2(-1,-1);
			
			for(fixed i = 0; i < 1; i = i + 1/num){
				c += square(pos, p1, size, i, tex, scale);
				c += square(pos, p2, size, i, tex, scale);
				c += square(pos, p3, size, i, tex, scale);
				c += square(pos, p4, size, i, tex, scale);
				
				c += square(pos, p5, size, i, tex, scale);
				c += square(pos, p6, size, i, tex, scale);
				c += square(pos, p7, size, i, tex, scale);
			}
			return c*1/num;
		}
			
		fixed4 frag(v2f_img i) : COLOR{
			float4 c = tex2D(_MainTex, i.uv);
			float4 s = squares(i.uv, _MainTex, _Scale, _Size, 5.4);
			return c + _C * length(s.rgb);
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  
		ColorMask RGB
 
		pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma target 3.0
			#pragma glsl
			ENDCG
		}
	} 
}