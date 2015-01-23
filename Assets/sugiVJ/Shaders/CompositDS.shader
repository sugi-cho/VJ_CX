Shader "Custom/CompositDS" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DSColTex ("color ,emissino", 2D) = "white" {}
		_DSNomTex ("normal ,wire", 2D) = "white" {}
		_DSPosTex ("position ,depth", 2D) = "white" {}
	}
	CGINCLUDE
		#include "UnityCG.cginc"
 		
		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		
		uniform sampler3D _N3D;
		uniform sampler2D _BGTex,_PointsTex;
		uniform float3 _MainCameraPos;
		uniform float _Knob06,_Knob03,_DeltaLevel;
		uniform int _ToggleQ,_ToggleE,_ToggleW;
		
		sampler2D
			_DSColTex,
			_DSNomTex,
			_DSPosTex;		
		
		struct v2f{
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			
			float4 ps00 : TEXCOORD1;
			float4 ps01 : TEXCOORD2;
			float4 ps02 : TEXCOORD3;
			float4 ps03 : TEXCOORD4;
			float4 ps04 : TEXCOORD5;
			float4 ps05 : TEXCOORD6;
			float4 ps06 : TEXCOORD7;
			float4 ps07 : TEXCOORD8;
			float4 ps08 : TEXCOORD9;
			float4 ps09 : TEXCOORD10;
			float4 ps10 : TEXCOORD11;
			float4 ps11 : TEXCOORD12;
			float4 ps12 : TEXCOORD13;
			float4 ps13 : TEXCOORD14;
			float4 ps14 : TEXCOORD15;
			float4 ps15 : TEXCOORD16;
			
			float3 pc00 : TEXCOORD17;
			float3 pc01 : TEXCOORD18;
			float3 pc02 : TEXCOORD19;
			float3 pc03 : TEXCOORD20;
			float3 pc04 : TEXCOORD21;
			float3 pc05 : TEXCOORD22;
			float3 pc06 : TEXCOORD23;
			float3 pc07 : TEXCOORD24;
			float3 pc08 : TEXCOORD25;
			float3 pc09 : TEXCOORD26;
			float3 pc10 : TEXCOORD27;
			float3 pc11 : TEXCOORD28;
			float3 pc12 : TEXCOORD29;
			float3 pc13 : TEXCOORD30;
			float3 pc14 : TEXCOORD31;
			float3 pc15 : TEXCOORD32;
		};
		
		
		float3 noise3D(float3 pos){
			float
				r = tex3D(_N3D, pos.xyz).z,
				g = tex3D(_N3D, pos.yzx).z,
				b = tex3D(_N3D, pos.zxy).z;
			return float3(r,g,b);
		}
		v2f vert(appdata_full v){
			v2f o;
			o.pos = v.vertex;
			o.uv = (v.vertex.xy/v.vertex.w+1.0)*0.5;
			
			o.ps00 = tex2Dlod(_PointsTex,float4(0.5/4.0,0.5/4.0,0,1.0));
			o.ps01 = tex2Dlod(_PointsTex,float4(1.5/4.0,0.5/4.0,0,1.0));
			o.ps02 = tex2Dlod(_PointsTex,float4(2.5/4.0,0.5/4.0,0,1.0));
			o.ps03 = tex2Dlod(_PointsTex,float4(3.5/4.0,0.5/4.0,0,1.0));
			o.ps04 = tex2Dlod(_PointsTex,float4(0.5/4.0,1.5/4.0,0,1.0));
			o.ps05 = tex2Dlod(_PointsTex,float4(1.5/4.0,1.5/4.0,0,1.0));
			o.ps06 = tex2Dlod(_PointsTex,float4(2.5/4.0,1.5/4.0,0,1.0));
			
			o.pc00 = noise3D(o.ps00.xyz*0.04+_Time.x);
			o.pc01 = noise3D(o.ps01.xyz*0.04+_Time.x);
			o.pc02 = noise3D(o.ps02.xyz*0.04+_Time.x);
			o.pc03 = noise3D(o.ps03.xyz*0.04+_Time.x);
			o.pc04 = noise3D(o.ps03.xyz*0.04+_Time.x);
			o.pc05 = noise3D(o.ps03.xyz*0.04+_Time.x);
			o.pc06 = noise3D(o.ps03.xyz*0.04+_Time.x);
			return o;
		}
		
		struct litProp{
			float3 diff;
			float3 spec;
		};
		litProp lightColor(litProp lp, float3 lPos, float3 lCol, float3 vPos, float3 nom, float3 vDir){
			float3
				lDir = normalize(lPos-vPos),
				h = normalize(lDir + vDir);
			float
				diff = max(0, dot(nom, lDir)),
				nh = max(0, dot(nom, h)),
				spec = pow(nh, 16.0),
				dist = length(vPos-lPos);
			lCol *= lCol*lCol*pow(10,_Knob03*_DeltaLevel);
			lp.diff += diff / (dist*dist)*lCol*1000.0;
			lp.spec += spec / (dist)*lCol*lCol*10000.0;
			return lp;
		}
		
		half4 frag(v2f i) : COLOR{
#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0) 
				i.uv.y = 1-i.uv.y;
#endif

			float4
				col = tex2D(_DSColTex, i.uv),
				nom = tex2D(_DSNomTex, i.uv),
				pos = tex2D(_DSPosTex, i.uv),
				bg = tex2D(_BGTex, i.uv);
			float3
				vDir = normalize(pos.xyz - _MainCameraPos.xyz);
			float
				emi = col.w,
				wir = nom.w,
				dep = pos.w;
			nom.xyz = normalize(nom.xyz);
			
			litProp lp;
			lp.diff = 0;
			lp.spec = 0;
			
			lp = lightColor(lp, i.ps00.xyz, i.pc00.rgb, pos.xyz, nom.xyz, vDir);
			lp = lightColor(lp, i.ps01.xyz, i.pc01.rgb, pos.xyz, nom.xyz, vDir);
			lp = lightColor(lp, i.ps02.xyz, i.pc02.rgb, pos.xyz, nom.xyz, vDir);
			lp = lightColor(lp, i.ps03.xyz, i.pc03.rgb, pos.xyz, nom.xyz, vDir);
			lp = lightColor(lp, i.ps04.xyz, i.pc04.rgb, pos.xyz, nom.xyz, vDir);
			lp = lightColor(lp, i.ps05.xyz, i.pc05.rgb, pos.xyz, nom.xyz, vDir);
			lp = lightColor(lp, i.ps06.xyz, i.pc06.rgb, pos.xyz, nom.xyz, vDir);
			lp = lightColor(lp, i.ps07.xyz, i.pc07.rgb, pos.xyz, nom.xyz, vDir);
			
			float4 c = col;
			c.rgb = c.rgb*(lp.diff)+lp.spec;
			
			float3 nCol = noise3D(pos*0.05);
			nCol = cos(nCol*nCol*5);
			
			bg = 0;
			float t = saturate(dep/(50+_Knob06*300));
			c.a = 1-t;
			c = lerp(c,bg,t);
			if(_ToggleE)
				c.rgb = nCol*c.a;
			if(_ToggleQ)
				return float4(c.a-wir,c.a-wir,c.a-wir,0.1);
			if(_ToggleW)
				return float4(wir*float3(0.5,0.75,1.0),0.1);
			return c;
		}
	ENDCG
	
	SubShader {
		pass{
			CGPROGRAM
			#pragma glsl target 3.0
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	} 
}