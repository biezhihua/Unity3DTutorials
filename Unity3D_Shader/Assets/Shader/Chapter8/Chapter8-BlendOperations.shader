﻿Shader "Unity Shaders Book/Chapter 8/Blend Operations 0" {
	Properties {
		_Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex ("Main Tex", 2D) = "white" {}
		_AlphaScale ("Alpha Scale", Range(0,1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		
		Pass {
		    Tags {"LightMode"="ForwardBase"}
		    
		    ZWrite Off
		    
		    //Blend SrcAlpha OneMinusSrcAlpha, One Zero
            // 正常(Normal), 即透明度混合
            // Blend SrcAlpha OneMinusSrcAlpha
            
            // 柔和相加 Soft Additive
            // Blend OneMinusDstColor One
            
            // 正片叠底(Multiply) 相乘
            // Blend DstColor One
            
            // 两倍相乘(2x Multiply)
            // Blend DstColor SrcColor
            
            // 变暗 Darken
            // BlendOp Min
            // Blend One One
            
            // 变亮 Lighten
            // BlendOp Max
            // Blend One One
            
            // 滤色
            // Blend OneMinusDstColor One
            
            // 线性减淡
            Blend One One 
		    
		    CGPROGRAM
		    
		    #pragma vertex vert
		    #pragma fragment frag
		    
		    #include "Lighting.cginc"
		    
		    fixed4 _Color;
		    sampler2D _MainTex;
		    float4 _MainTex_ST;
		    fixed _AlphaScale;
		    
		    struct a2v {
		        float4 vertex : POSITION;
		        float3 normal : NORMAL;
		        float4 texcoord : TEXCOORD0;
		    };
		    
		    struct v2f {
		        float4 pos : SV_POSITION;
		        float2 uv : TEXCOORD0;
		    };
		    
		    v2f vert(a2v v) {
		        v2f o;
		        o.pos = UnityObjectToClipPos(v.vertex);
		        
		        o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		        return o;
		    }
		    
		    fixed4 frag(v2f i) : SV_Target {				
				fixed4 texColor = tex2D(_MainTex, i.uv);
			 	
				return fixed4(texColor.rgb * _Color.rgb, texColor.a * _AlphaScale);
			}
		    
		    ENDCG
		}
		
	}
	FallBack "Transparent/VertexLit"
}
