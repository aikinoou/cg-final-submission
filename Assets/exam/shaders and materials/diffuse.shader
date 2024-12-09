Shader "Custom/CoinShader"
{
    Properties {
        _MainTex ("Base Texture", 2D) = "white" {}      // Diffuse texture
        _Metallic ("Metallic", Range(0,1)) = 0.8        // Metallic property
        _Smoothness ("Smoothness", Range(0,1)) = 0.5    // Smoothness for specular highlights
        _Color ("Base Color", Color) = (1, 1, 0, 1)     // Base color for the coin
        _BumpMap ("Normal Map", 2D) = "bump" {}         // Optional normal map
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
            // Base color from texture and property
            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = texColor.rgb * _Color.rgb;

            // Metallic and smoothness values
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;

            // Normal map for surface details (handles missing texture gracefully)
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
