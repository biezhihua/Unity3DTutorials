// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unity Shaders Book/Chapter 7/Normal Map World Space" {
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
                float4 TtoW0 : TEXCOORD1;
                float4 TtoW1 : TEXCOORD2;
                float4 TtoW2 : TEXCOORD3;
            };
                
            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                // xy分量存储了_MainTex的纹理坐标
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                // zw分量存储了_BumpMap的纹理坐标
                o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

                // 世界空间下位置                 
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                // 世界空间法线
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                // 世界空间切线
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                // 世界空间副切线
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                
                // Compute the matrix that transform directions from tangent space to world space
                // Put the world postion in w component for optimizeation
                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x); 
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y); 
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z); 
                
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target {
                
                // Get the position in world space
                // 构建世界空间下的坐标
                float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
                
                // Compute the light and view dir in world space
                // 世界空间的光照
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                // 世界空间的视角
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                
                // Get the normal in tangent space
                // 使用UnpackNormal对法线纹理进行采样和解码（需要把法线纹理的格式识别为Normal map）
                // 并使用_BumpScale进行缩放。
                fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
                bump.xy *= _BumpScale;
                bump.z = sqrt(1.0 - saturate(dot(bump.xy, bump.xy)));
                
                // Transform the normal from tangent space to world space
                // 使用TtoW0/TtoW1/TtoW2存储的变换矩阵把法线变换到世界空间下。
                bump = normalize(half3(dot(i.TtoW0.xyz, bump), dot(i.TtoW1.xyz, bump), dot(i.TtoW2.xyz, bump)));
            
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(bump, lightDir));
                
                fixed3 halfDir = normalize(lightDir + viewDir);
                
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(bump, halfDir)), _Gloss);
                
                return fixed4(ambient + diffuse + specular, 1.0);
            }
                
            ENDCG
        }
    }
    Fallback "Specular"
}
