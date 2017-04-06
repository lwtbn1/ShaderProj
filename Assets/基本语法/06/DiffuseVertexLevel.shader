Shader "ShaderProj/DiffuseVertexLevel" {
	Properties{
		_Diffuse ("Diffuse", Color) = (1,1,1,1)  //这里定义物体的自身的漫反射颜色
	}

	SubShader{
		Pass{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "UnityCG.cginc"
			fixed4 _Diffuse;

			struct a2v{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;

			};

			v2f vert(a2v v){
				
				v2f f;
				f.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				float3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
				float3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				f.color = _Diffuse.rgb * _LightColor0.rgb * max(0.0, dot(worldNormal, worldLight));
				
				return f;

			}

			fixed4 frag(v2f f) : SV_Target{
				return fixed4(f.color.rgb,1);
			}

			ENDCG

		}
	}

	FallBack "Diffuse"
}
