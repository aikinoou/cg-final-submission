Shader "Custom/ToonShader"
{
    Properties
    {
        _Color ("Base Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _Glossiness ("Glossiness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf ToonRamp addshadow

        // Properties
        sampler2D _MainTex;
        sampler2D _RampTex;
        float4 _Color;
        float _Glossiness;

        // Custom Lighting Function
        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
        {
            // Diffuse lighting calculation
            float diff = max(dot(s.Normal, lightDir), 0.0);
            float h = diff * 0.5 + 0.5; // Map range [-1, 1] to [0, 1]
            float3 ramp = tex2D(_RampTex, float2(h, 0.0)).rgb;

            // Specular lighting calculation (using built-in specular calculation)
            float3 halfDir = normalize(lightDir + viewDir);
            float spec = pow(max(dot(s.Normal, halfDir), 0.0), _Glossiness * 128);
            float3 specular = s.Specular * spec * atten;  // Using built-in s.Specular

            // Final color output
            float4 c;
            c.rgb = (s.Albedo * ramp * _LightColor0.rgb + specular) * atten;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        // Surface function for processing the material properties
        void surf(Input IN, inout SurfaceOutput o)
        {
            // Use MainTex if available, otherwise use base color
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = tex.rgb * _Color.rgb;

            // Handle transparency and glossiness
            o.Specular = _Glossiness; // Use built-in specular
            o.Alpha = tex.a * _Color.a;
        }
        ENDCG
    }
    
    FallBack "Diffuse"
}
