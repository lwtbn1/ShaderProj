// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderProj/FrowardRendering" {
	Properties{
		//漫反射颜色
		_Diffuse ("Diffuse", Color) = (1,1,1,1)
		//高光反射颜色
		_Specular ("Specular", Color) = (1,1,1,1)
		//物体表面的粗糙度
		_Gross ("Gross", Range(0,255)) = 0
	}
	SubShader{
		Pass{
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
				#pragma multi_compile_fwdbase
				#pragma vertex vert
				#pragma fragment frag
				#include "Lighting.cginc"

				fixed4 _Diffuse;
				fixed4 _Specular;
				float _Gross;

				struct a2v{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f{
					float4 pos : SV_POSITION;
					float3 worldNormal : TEXCOORD0;
					float3 worldPos : TEXCOORD1;
				};

				v2f vert(a2v v){
					v2f f;
					f.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					f.worldNormal = UnityObjectToWorldNormal(v.normal);
					f.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					return f;
				}

				fixed4 frag(v2f f) : SV_Target{
					fixed3 worldNormal = normalize(f.worldNormal);
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
					fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0, dot(worldNormal, worldLightDir));

					fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldPos);
					fixed3 halfDir = normalize(viewDir + worldLightDir);
					fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal, halfDir)),_Gross);
					//衰减(表示没有衰减)
					fixed atten = 1.0;
					return fixed4(ambient + (diffuse + specular) * atten, 1.0);
				}

			ENDCG

		}

		Pass{
			Tags {"LightMode" = "ForwardAdd"}
			Blend One One

			CGPROGRAM
				#pragma multi_compile_fwdadd
				#pragma vertex vert
				#pragma fragment frag

				#include "Lighting.cginc"
				#include "AutoLight.cginc"

				fixed4 _Diffuse;
				fixed4 _Specular;
				float _Gross;

				struct a2v{
					float4 vertex : POSITION;	
					float3 normal : NORMAL;
				};

				struct v2f{
					float4 pos : SV_POSITION;
					float3 worldNormal : TEXCOORD0;
					float3 worldPos : TEXCOORD1;
				};

				v2f vert(a2v v){

					v2f f;
					f.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					f.worldNormal = UnityObjectToWorldNormal(v.normal);

					f.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					return f;
				}

				fixed4 frag(v2f f) : SV_Target{
					float3 worldNormal = normalize(f.worldNormal);
					#ifdef USING_DIRECTIONAL_LIGHT
						fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
					#else
						fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - f.worldPos.xyz);
					#endif
					//计算漫反射
					fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * max(0,dot(worldLightDir, worldNormal));

					fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldPos.xyz);
					fixed3 halfDir = normalize(viewDir + worldLightDir);
					//计算高光
					fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal, halfDir)), _Gross );

					#ifdef USING_DIRECTION_LIGHT
						fixed atten = 1.0;
					#else
						#if defined (POINT)
					        float3 lightCoord = mul(unity_WorldToLight, float4(f.worldPos, 1)).xyz;
					        fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
					    #elif defined (SPOT)
					        float4 lightCoord = mul(unity_WorldToLight, float4(f.worldPos, 1));
					        fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
					    #else
					        fixed atten = 1.0;
					    #endif

					#endif
					return fixed4((diffuse + specular) * atten, 1.0);
				}

			ENDCG

		}


	}


	FallBack "Specular"
}
