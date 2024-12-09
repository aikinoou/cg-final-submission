Shader "Custom/rim no extra"
{
    Properties
    {
        _myColor ("Sample color", Color) = (1,1,1,1) 
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(0.1, 10)) = 2.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM
        #pragma surface surf Lambert
        
        struct Input
        {
            float3 viewDir;
        };
        
        fixed4 _myColor;
        fixed4 _RimColor;
        float _RimPower; 
        float _Shininess;

        void surf (Input IN, inout SurfaceOutput o)
        {

            o.Albedo = _myColor.rgb;

            //rim lighting based on view direction and surface normal
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower); //rim lighting effect
            
            half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);  // ight direction
            half3 viewDir = normalize(IN.viewDir);
            half3 reflectDir = reflect(-lightDir, o.Normal);
            half spec = pow(max(0.0, dot(viewDir, reflectDir)), _Shininess);
            o.Emission += _SpecColor.rgb * spec; //specular highlight
        }
        ENDCG
    }

    FallBack "Diffuse"
}
