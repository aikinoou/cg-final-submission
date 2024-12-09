Shader "Custom/rim no extra"
{
    Properties
    {
        _myColor ("Sample color", Color) = (1,1,1,1)  // This color will be applied to the object
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
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
            float3 viewDir;  // View direction for rim lighting
        };

        // Properties
        fixed4 _myColor;  // The color to apply to the object
        fixed4 _RimColor; // Rim lighting color
        float _RimPower;   // Rim power for the lighting effect
        float _Shininess;  // Shininess for specular highlights

        // Surface shader function
        void surf (Input IN, inout SurfaceOutput o)
        {
            // Use _myColor as the base albedo color
            o.Albedo = _myColor.rgb;

            // Apply rim lighting based on view direction and surface normal
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower); // Apply rim lighting effect

            // Phong Lighting Model: Specular
            // Calculate specular lighting
            half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);  // Light direction
            half3 viewDir = normalize(IN.viewDir);
            half3 reflectDir = reflect(-lightDir, o.Normal);
            half spec = pow(max(0.0, dot(viewDir, reflectDir)), _Shininess); // Specular highlight
            o.Emission += _SpecColor.rgb * spec; // Add specular highlight to emission
        }
        ENDCG
    }

    FallBack "Diffuse"
}
