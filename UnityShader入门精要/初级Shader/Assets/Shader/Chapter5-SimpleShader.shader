// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 5/Simple Shader" {
	SubShader {
		Pass {
			CGPROGRAM

			// 两个重点的编译指令
			// 更通用的表示, name是指定的函数名：
			// #pragma vertex name
			// #pragma fragment name
			#pragma vertex vert			// 告诉Unity哪个函数包含了顶点着色器代码
			#pragma fragment frag		// 告诉Unity哪个函数包含了片元着色器

			// POSITION和SV_POSITION都是Cg/HLSL中的语义
			// POSITION 告诉Unity把模型的顶点坐标填充到输入参数v中
			// SV_POSITION 告诉Unity顶点着色器的输出是裁剪空间中的顶点坐标
			float4 vert(float4 v : POSITION) : SV_POSITION {
				// 把顶点坐标从模型空间转换到裁剪空间中
				// UNITY_MATRIX_MVP矩阵是Unity内置的模型*观察*投影矩阵
				// mul(UNITY_MATRIX_MVP,*)
				return UnityObjectToClipPos(v);
			}

			// SV_Target是HLSL的一个系统语义，
			// 把用户的输出颜色存储到一个渲染目标(render target)，
			// 这里输出到默认的帧缓冲中。
			// 片元着色器输出的颜色每个分量在[0,1]，其中(0,0,0)表示黑色
			// (1,1,1)表示白色
			fixed4 frag() : SV_Target {
				return fixed4(1.0, 1.0, 1.0, 1.0);
			}

			ENDCG
		}
	}
}