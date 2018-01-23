// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 8/Alpha Test Both Sided" {
	Properties {
		_Color ("Main Tint", Color) = (1,1,1,1)
		_MainTex ("Main Tex", 2D) = "white" {}
		// 用于使用clip进行透明度测试时使用的判断条件。
		_Cutoff ("Alpha Cutoff", Range(0,1 )) = 0.5
	}
	SubShader {
	
	    // Queue用于指定渲染队列
	    // RenderType让Unity把这个Shader归入到提前定的组(TransparentCutout组),以指明该Shader是一个使用了透明度测试的Shader
	    // IgnoreProjector=true意味着该Shader不会受到投影器(Projectors)的影响
		Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
        
        Pass {
            // 定义该Pass在Unity中的光照流水线中的角色
            Tags { "LightMode"="ForwardBase" }
            
            // 可以使用Cull指令来控制需要剔除n哪个面的渲染图元
            // Cull Back | Front | Off
            // 若设置成Back，那么背对摄像机的面就不会被渲染
            // 若设置成Front，那么朝向摄像机的面就不会被渲染
            // 若设置成Off，就会关闭剔除功能，但是需要渲染的图元数目会成倍的增加
            Cull Off
            
            CGPROGRAM
                
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Cutoff;
                
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };
            
            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target {
                fixed3 worldNormal = normalize(i.worldNormal);
                
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                
                fixed4 texColor = tex2D(_MainTex, i.uv);
                
                // AlphaTest
                clip(texColor.a - _Cutoff);
                
                fixed3 albedo = texColor.rgb * _Color.rgb;
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
                
                return fixed4 (ambient + diffuse , 1.0);
            }
                
                
            ENDCG
        }
        		
	}
	FallBack "Transparent/Cutout/VertexLit"
}
