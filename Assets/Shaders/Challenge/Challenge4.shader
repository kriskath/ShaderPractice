Shader "monkybusines/Challenges/Challenge4"
{
    Properties
    {
        _difTex ("Diffuse Texture", 2D) = "white" {}
        _emisTex("Emissive Texture", 2D) = "black" {}
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _difTex;
        sampler2D _emisTex;

        struct Input
        {
            float2 uv_difTex;
            float2 uv_emisTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = (tex2D(_difTex, IN.uv_difTex)).rgb;
            o.Emission = (tex2D(_emisTex, IN.uv_emisTex)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
