Shader "Custom/ScrollingWater"
{
    Properties {
        _MainTex ("Water Texture", 2D) = "white" {} 
        _FoamTex ("Foam Texture", 2D) = "white" {}
        _ScrollX ("Scroll X", Range(-5,5)) = 1 
        _ScrollY ("Scroll Y", Range(-5,5)) = 1 
        _BlendStrength ("Blend Strength", Range(0,1)) = 0.5 
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
            //scrolling offsets
            float2 scrollOffset1 = IN.uv_MainTex + float2(_ScrollX, _ScrollY) * _Time;
            float2 scrollOffset2 = IN.uv_MainTex + float2(_ScrollX / 2.0, _ScrollY / 2.0) * _Time;
            
            float3 water = tex2D(_MainTex, scrollOffset1).rgb;
            float3 foam = tex2D(_FoamTex, scrollOffset2).rgb;
            
            o.Albedo = lerp(water, foam, _BlendStrength);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
