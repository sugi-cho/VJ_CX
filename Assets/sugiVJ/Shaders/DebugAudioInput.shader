Shader "Custom/DebugAudioInput" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_C1 ("color1", Color) = (0.0,0.0,0.0,0.0)
		_C2 ("color2", Color) = (1.0,1.0,1.0,1.0)
	}
	CGINCLUDE
		#include "UnityCG.cginc"

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
		half4 _MainTex_TexelSize;
		half4 _C1,_C2;
			
		half4 frag(v2f_img i) : COLOR{
			half2 d = _MainTex_TexelSize.xy;
			float r = 0;
			
			if(i.uv.x < 1.0/16.0)
				r = _Knob00;
			else if(i.uv.x < 2.0/16.0)
				r = _Knob01;
			else if(i.uv.x < 3.0/16.0)
				r = _Knob02;
			else if(i.uv.x < 4.0/16.0)
				r = _Knob03;
			else if(i.uv.x < 5.0/16.0)
				r = _Knob04;
			else if(i.uv.x < 6.0/16.0)
				r = _Knob05;
			else if(i.uv.x < 7.0/16.0)
				r = _Knob06;
			else if(i.uv.x < 8.0/16.0)
				r = _Knob07;
			else if(i.uv.x < 9.0/16.0)
				r = _Knob08;
			else if(i.uv.x < 10.0/16.0)
				r = _Knob09;
			else if(i.uv.x < 11.0/16.0)
				r = _Knob10;
			else if(i.uv.x < 12.0/16.0)
				r = _Knob11;
			else if(i.uv.x < 13.0/16.0)
				r = _Knob12;
			else if(i.uv.x < 14.0/16.0)
				r = _Knob13;
			else if(i.uv.x < 15.0/16.0)
				r = _Knob14;
			else
				r = _Knob15;
			
			half4 rs = tex2D(_SpectrumTex, i.uv);//+tex2D(_SpectrumTex, i.uv.yx*2.0+half2(0,_AudioLevel*10000.0+_AudioTime*10000.0));
			half rawSpectrum = 4.0*(rs.z-0.5)*(rs.x + rs.y/256.0);
			return rawSpectrum;
			
			half2 uv = i.uv;
			uv.y *= d.x/d.y;
			half 
				b = tex3D(_N3D, half3(uv,_AudioTime*30.0)).z,
				b2 = tex3D(_N3D, half3(uv+half2(0,-_AudioTime*10.0),b*2.0+_AudioTime*10.0)).z,
				b3 = tex3D(_N3D, half3(uv+rawSpectrum+half2(0,-_AudioTime*100.0),b*2.0+_AudioTime*10.0)).z;
			
			
			half4 c = (3.0+90.0*_DeltaLevel)*pow(half4(b3,b2,b2, 1.0),4.0);
			c = lerp(_C1,_C2,1.5*(c+rawSpectrum*0.25));
			return c;
		}
	ENDCG
	
	SubShader {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }
 
		pass{
			CGPROGRAM
			#pragma glsl target 3.0
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}