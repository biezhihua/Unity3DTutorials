﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter6-BlinnPhong" {
	Properties {
		_Diffuse("Diffuse", Color) = (1,1,1,1)

		// 用于控制材质的高光反射颜色
		_Specular ("Specular", Color) = (1,1,1,1)

		// 用于控制高光区域的大小
		_Gloss ("Gloss", Range(8.0, 256)) = 20
	}
	SubShader {
		Pass {
			// 指明光照模式
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v) {
				v2f o;

				// Transform the vertex from object space to projection space
				// 把顶点位置从模型空间转换到裁剪空间
				o.pos = UnityObjectToClipPos(v.vertex);

				// Transform the normal fram object space to world space
				// v.normal是模型空间下的，需要把法线转换到世界空间中。
				// 需要使用原变换矩阵的逆转置矩阵来变换法线就可以得到正确的世界空间结果
				// 模型空间到世界空间的变换矩阵的逆矩阵 = _WorldToObject
				// 调换mul函数中的位置得到和转置矩阵相同的乘法
				o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				// Transform the vertex from object space to world space
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				// Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldNormal = normalize(i.worldNormal);

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				// Compute diffuse term
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

				// Get the reflect direction in world space
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

				// Get the view direction in world space
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

				// Get the half direction in world space
				fixed3 halfDir = normalize(worldLightDir + viewDir);

				// Compute specular term
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Specular"
}
