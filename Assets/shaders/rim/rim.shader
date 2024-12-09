Shader "Custom/6"
{
    Properties
    {
        _myColor ("Sample color", Color) = (1,1,1,1)  // This color will be applied to the object
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
        _MainTex ("Base Texture", 2D) = "white" { }
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(0.1, 10)) = 2.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        // Surface shader with Lambert lighting model
        CGPROGRAM
        #pragma surface surf Lambert

        // Input structure
        struct Input
        {
            float3 viewDir;
            float2 uvMainTex;
        };

        // Properties
        fixed4 _myColor;
        fixed4 _RimColor;
        float _RimPower;
        sampler2D _MainTex;      // The base texture
        sampler2D _BumpMap;      // The normal map
        float _Shininess;        // The shininess value

        // Surface shader function
        void surf (Input IN, inout SurfaceOutput o)
        {
            // Sample the texture
            fixed4 texColor = tex2D(_MainTex, IN.uvMainTex);
            
            // Combine the texture with the _myColor property (override texture with _myColor if no texture)
            o.Albedo = texColor.rgb * _myColor.rgb; // Combine the texture with the color property

            // Apply normal map if present
            float3 normal = UnpackNormal(tex2D(_BumpMap, IN.uvMainTex));
            o.Normal = normalize(normal);  // Normalize to prevent issues with lighting

            // Calculate rim lighting based on view direction and surface normal
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower); // Apply rim lighting effect

            // Phong Lighting Model: Diffuse + Specular
            // Calculate diffuse lighting
            half3 lightDir = normalize(_WorldSpaceLightPos0.xyz); // Light direction
            half diff = max(0.0, dot(o.Normal, lightDir)); // Lambertian diffuse term
            o.Albedo *= diff; // Apply diffuse lighting

            // Calculate specular lighting
            half3 viewDir = normalize(IN.viewDir);
            half3 reflectDir = reflect(-lightDir, o.Normal);
            half spec = pow(max(0.0, dot(viewDir, reflectDir)), _Shininess); // Phong specular highlight
            o.Emission += _SpecColor.rgb * spec; // Add specular highlight to emission
        }
        ENDCG
    }

    FallBack "Diffuse"
}
