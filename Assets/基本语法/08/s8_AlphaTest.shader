// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderProj/s8_AlphaTest" {
	Properties{
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Cutoff ("CutOff", Range(0,1)) = 0.5
	}

	SubShader{
		Pass{
			Tags{
				"Queue" = "AlphaTest" 
				"IgnoreProjector" = "True"
				"RenderType" = "TransparentCutout"
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag	
				#include "Lighting.cginc"

				fixed4 _Color;
				sampler2D _MainTex;
				float4 _MainTex_ST;
				fixed _Cutoff;

				struct a2v{
					float4 pos : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f{
					float4 pos : SV_POSITION;
					float3 worldNormal : TEXCOORD0;
					float3 worldPos : TEXCOORD1;
					float2 uv : TEXCOORD2;
				};



				v2f vert(a2v v){
					v2f f;
					f.pos = mul(UNITY_MATRIX_MVP, v.pos);
					f.worldNormal = UnityObjectToWorldNormal(v.normal);
					f.worldPos = mul(unity_ObjectToWorld, v.pos);
					f.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					return f;
				}


				fixed4 frag(v2f f) : SV_Target{
					fixed3 worldNormal = normalize(f.worldNormal);
					//
					fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(f.worldPos));

					fixed4 texColor = tex2D(_MainTex, f.uv);
					//如果alpha值小于 _Cutoff，则剔除该片元
					if(texColor.a - _Cutoff < 0.0)
						discard;

					//反照率(反射光线强度)
					fixed3 albedo = texColor.rgb * _Color.rgb;
					//环境光
					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;

					fixed3 diffuse = _LightColor0.rgb * albedo * max(0.0, dot(worldNormal, worldLightDir));
					return fixed4(ambient + diffuse, 1.0);
				}


			ENDCG
		}
	}
	FallBack "Legacy Shaders/Transparent/VertexLit"
}
