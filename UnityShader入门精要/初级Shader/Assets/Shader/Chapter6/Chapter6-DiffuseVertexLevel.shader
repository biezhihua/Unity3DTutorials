// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/Diffuse Vertex-Level" {
	Properties {
		// 用于控制材质的漫反射颜色 初始值为白色
		_Diffuse ("Diffuse", Color) = (1,1,1,1)
	}

	SubShader {
		Pass {
			// 指明该Pass的光照模式
			// 只有定义了正确的LightMode才能在Unity中得到一些内置光照变量
			// 例如_LightColor()
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM

			// 告诉Unity顶点着色器与片元着色器的名字
			#pragma vertex vert
			#pragma fragment frag

			// Unity内置文件
			#include "Lighting.cginc"

			// 为了使用Properties语义块中声明的属性，需要定义
			// 一个和该属性类型相匹配的变量
			// 材质的漫反射属性
			fixed4 _Diffuse;

			// 顶点着色器的输入结构体
			struct a2v {
				// 顶点位置
				float4 vertex : POSITION;
				// 顶点法线
				float3 normal : NORMAL;
			};

			// 顶点着色器的输出结构体
			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			// 顶点着色器
			// 实现一个逐顶点的漫反射光照
			v2f vert(a2v v) {
				v2f o;

				// Transform the vertex from object space to projection space
				// mul(UNITY_MATRIX_MVP, v.vertex)
				// 把顶点位置从模型空间转换到裁剪空间
				o.pos = UnityObjectToClipPos(v.vertex);

				// Get ambient term
				// 通过Unity内置变量得到环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				// Transform the normal frame object space to world space
				// _World2Object = unity_WorldToObject
				// v.normal是模型空间下的，需要把法线转换到世界空间中。
				// 需要使用原变换矩阵的逆转置矩阵来变换法线就可以得到正确的世界空间结果
				// 模型空间到世界空间的变换矩阵的逆矩阵 = _WorldToObject
				// 调换mul函数中的位置得到和转置矩阵相同的乘法
				// mul代表的矩阵乘法，且是右乘
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

				// Get the light direction in world space
				// 规范化光源方向
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				// Compute diffuse term
				// 计算漫反射：漫反射 = (入射光线的颜色和强度 * 材质的漫反射颜色) * max(表面法线 * 光源方向)
				// 材质漫反射颜色 = _Diffuse.rgb
				// 光源颜色和强度信息 = _LightColor0.rgb
				// 光源方向 = _WorldSpaceLightPos0.xyz
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				// 环境光添加到输出颜色上
				o.color = ambient + diffuse;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}