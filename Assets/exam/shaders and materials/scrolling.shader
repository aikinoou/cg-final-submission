Shader "Custom/ScrollingWater"
{
    Properties {
        _MainTex ("Water Texture", 2D) = "white" {}    // Water texture
        _FoamTex ("Foam Texture", 2D) = "white" {}     // Foam texture
        _ScrollX ("Scroll X", Range(-5,5)) = 1         // X scroll speed
        _ScrollY ("Scroll Y", Range(-5,5)) = 1         // Y scroll speed
        _BlendStrength ("Blend Strength", Range(0,1)) = 0.5 // Blending strength
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _FoamTex;
        float _ScrollX;
        float _ScrollY;
        float _BlendStrength;

        struct Input {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o) {
            // Calculate scrolling offsets
            float2 scrollOffset1 = IN.uv_MainTex + float2(_ScrollX, _ScrollY) * _Time;
            float2 scrollOffset2 = IN.uv_MainTex + float2(_ScrollX / 2.0, _ScrollY / 2.0) * _Time;

            // Sample textures
            float3 water = tex2D(_MainTex, scrollOffset1).rgb;
            float3 foam = tex2D(_FoamTex, scrollOffset2).rgb;

            // Blend textures
            o.Albedo = lerp(water, foam, _BlendStrength);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
