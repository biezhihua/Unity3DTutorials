// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/Single Texture" {
	Properties {
	
	    // 作为纹理色调
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		// 纹理
		_MainTex ("Main Tex", 2D) = "white" {}
		_Specular ("Specular", Color) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
	}
	SubShader {
		Pass {
		    Tags {"LightMode" = "ForwardBase"}
		    
		    CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            // 需要为纹理类型的属性声明一个float4类型的变量_MainText_ST
            // 在Unity，需要使用纹理名_ST的方式来声明某个纹理的属性
            // 其中ST是缩放(Scale)和平移(Translation)的缩写
            // _MainText_ST可以让我们得到该纹理的缩放和平移(偏移)值
            // _MainText_ST.xy存储的是缩放值
            // _MainText_ST.zw存储的是偏移值
            float4 _MainTex_ST;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                // Unity会将模型的第一组纹理坐标存储到该变量中
                float4 texcoord : TEXCOORD0;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                // 用于存储纹理坐标的变量uv，便于在偏远着色器中使用该做标记进行纹理采样
                float2 uv : TEXCOORD2;
            };
            
            v2f vert(a2v v) {
                v2f o;
                
                o.pos = UnityObjectToClipPos(v.vertex);
                
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                
                // 先使用缩放属性xy对顶点纹理坐标进行缩放
                // 再使用zw对结果进行平移
                // 缩放、旋转、平移顺序
                o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                // Or just call the built-in function
                // #define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
                // o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target {
                
                // 计算世界空间下的法线和光照方向
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                
                // Use the texture to sample the diffuse color
                // 使用Cg的tex2D函数对纹理进行采样
                // 第一个是被采样的纹理，第二个是参量的纹理坐标，返回纹素值
                // 使用采样结果和_Color乘积作为材质的反射率
                
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

                return fixed4(ambient+diffuse+specular,1.0); 
                
            }
            
		    ENDCG
		}
	}
	FallBack "Specular"
}
