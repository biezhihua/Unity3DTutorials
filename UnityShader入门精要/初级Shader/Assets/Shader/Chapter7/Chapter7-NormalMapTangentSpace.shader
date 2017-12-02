// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/Normal Map Tangent Space" {

    Properties {
        _Color ("Color Tint", Color) = (1, 1, 1, 1) 
        _MainTex("Main Tex", 2D ) = "white" {}
        // 法线纹理
        // bump是Unity内置的法线纹理
        _BumpMap("Normap Map", 2D) = "bump" {}
        // 用于控制凹凸程度，当它为0时，意味着该法线纹理不会对
        // 光照产生任何影响
        _BumpScale("Bump Scale", Float) = 1.0
        
        _Specular("Specular", Color) = (1, 1, 1, 1)
        _Gloss("Gloss", Range(8.0, 256)) = 20
    }
    
    SubShader {
        Pass {
            Tags {"LightMode"="ForwardBase"}
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            
            // 与Properties语义块中的属性建立联系
            fixed4 _Color;
            sampler2D _MainTex;
            // 得到MainTex纹理属性的平铺和偏移系数
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            // 得到BumpMap纹理属性的平铺和偏移系数
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;
            
            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                // 顶点的切线方向
                // 需要使用tangent.w分量来决定切线空间中的第三个坐标轴-副切线的方向性
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                // 光照方向
                float3 lightDir : TEXCOORD1;
                // 视角方向
                float3 viewDir : TEXCOORD2;
            };
                
            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // xy分量存储了_MainTex的纹理坐标
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                // zw分量存储了_BumpMap的纹理坐标
                o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                 
                // 将模型空间下的切线方向、副切线方向和法线方向按行排列得到从模型空间到
                // 切线空间的变换矩阵rotation。
                
                // 之所以和w分量相乘，是为了决定使用哪一个方向
                // float3 binormal = cross( normalize(v.normal), normalize(v.tangent.xyz) ) * v.tangent.w; 
                // float3x3 rotation = float3x3( v.tangent.xyz, binormal, v.normal )
                TANGENT_SPACE_ROTATION;
                
                // Transform the light direction from object space to tangent space
                // ObjSpaceLightDir用于得到模型空间下的光照方向
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                // ObjSpaceViewDir用于得到模型空间下的视角方向
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;
                
                return o;
            }
            
            // 采样得到切线空间下的法线方向，再在切线空间下进行光照计算即可
            fixed4 frag(v2f i) : SV_Target {
                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);
                
                // Get the texel in the normal map
                // 法线纹理中存储的是经过映射后得到的像素值
                fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
                fixed3 tangentNormal;
                
                // If the texture is not marked as "Normal map"
                // tangentNormal.xy = (packedNormal.xy * 2 - 1 ) * _BumpScale;
                // tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                
                //  Or mark the texture as "Normal map", and use the built-in funciton
                tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));
                
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
                
                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal,halfDir)), _Gloss);
                
                return fixed4(ambient + diffuse + specular, 1.0);
            }
                
            ENDCG
        }
    }
    Fallback "Specular"
}
