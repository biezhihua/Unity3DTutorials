// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 5/Simple Shader" {
	SubShader {
		Pass {
			CGPROGRAM

			#pragma vertex vert	
			#pragma fragment frag

			// 使用一个结构体来定义顶点着色器
			struct a2v {
				// POSITION 语义告诉 Unity，用模型空间的顶点坐标填充vertex变量
				float4 vertex : POSITION
				// NORMAL语义告诉 Unity，用模型空间的法线方向填充normal变量
				float3 normal : NORMAL
				// TEXCOORD0语义告诉Unity，用模型的第一套纹理坐标填充texcoord变量
				float4 texcoord : TEXCOORD0
			}

			float4 vert(a2v v) : SV_POSITION {
				// 使用v.vertex来访问模型空间的顶点坐标
				return UnityObjectToClipPos(v.vertex);
			}

			fixed4 frag() : SV_Target {
				return fixed4(1.0, 1.0, 1.0, 1.0);
			}

			ENDCG
		}
	}
}