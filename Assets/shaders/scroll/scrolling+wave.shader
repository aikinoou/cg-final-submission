Shader "Custom/ScrollingWaterWithWaves"
{
    Properties {
        _MainTex ("Water", 2D) = "white" {}         // Water texture
        _FoamTex ("Foam", 2D) = "white" {}          // Foam texture
        _ScrollX ("Scroll X", Range(-5,5)) = 1      // X scroll speed
        _ScrollY ("Scroll Y", Range(-5,5)) = 1      // Y scroll speed
        _Tint ("Colour Tint", Color) = (1,1,1,1)    // Colour tint for the water
        _Freq ("Frequency", Range(0,5)) = 3         // Frequency of the wave
        _Speed ("Speed", Range(0,100)) = 10         // Speed of the wave animation
        _Amp ("Amplitude", Range(0,1)) = 0.5        // Amplitude of the wave
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        // Water texture and foam texture
        sampler2D _MainTex;
        sampler2D _FoamTex;

        // Wave parameters
        float _Freq;
        float _Speed;
        float _Amp;
        float _ScrollX;
        float _ScrollY;

        // Colour tint
        float4 _Tint;

        // Input structure for the surface shader
        struct Input {
            float2 uv_MainTex;
            float3 vertColor; // Wave displacement info
        };

        // Appdata structure for vertex shader
        struct appdata {
            float4 vertex: POSITION;
            float3 normal: NORMAL;
            float4 texcoord: TEXCOORD0;
        };

        // Vertex shader for wave displacement
        void vert(inout appdata v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input, o);

            // Calculate wave height based on time and position
            float t = _Time * _Speed;
            float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin(t*2 + v.vertex.x * _Freq*2) * _Amp;
            v.vertex.y += waveHeight; // Apply wave height to the vertex position

            // Modify the normal vector based on the wave height
            v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));

            // Pass the wave height info for tinting
            o.vertColor = waveHeight + 2.0;
        }

        // Surface shader for texture sampling and applying tint
        void surf(Input IN, inout SurfaceOutput o) {
            // Scroll texture coordinates for water and foam
            float2 scrollWater = IN.uv_MainTex + float2(_ScrollX, _ScrollY) * _Time;
            float2 scrollFoam = IN.uv_MainTex + float2(_ScrollX / 2.0, _ScrollY / 2.0) * _Time;

            // Sample the water and foam textures
            float3 water = tex2D(_MainTex, scrollWater).rgb;
            float3 foam = tex2D(_FoamTex, scrollFoam).rgb;

            // Blend the water and foam textures
            o.Albedo = (water + foam) / 2.0 * IN.vertColor.rgb * _Tint.rgb; // Apply wave displacement tint
        }
        ENDCG
    }
    FallBack "Diffuse"
}
