Shader "Custom/CoinShader"
{
    Properties {
        _MainTex ("Base Texture", 2D) = "white" {}
        _Metallic ("Metallic", Range(0,1)) = 0.8
        _Smoothness ("Smoothness", Range(0,1)) = 0.5   
        _Color ("Base Color", Color) = (1, 1, 0, 1)  
        _BumpMap ("Normal Map", 2D) = "bump" {}        
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _BumpMap;
        fixed4 _Color;
        half _Metallic;
        half _Smoothness;

        struct Input {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutputStandard o) {
            //color from textures
            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = texColor.rgb * _Color.rgb;

            //metallic and smoothness
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;

            //normal map
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
