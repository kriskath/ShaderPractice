Shader "monkybusines/Challenges/Challenge3"
{
    Properties
    {
        _myTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
       CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _myTex;

            struct Input
            {
                float2 uv_myTex; //any UV values must start with uv or uv2 followed by name of the texture
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                float4 green = float4(0,1,0,1);
                o.Albedo = (tex2D(_myTex, IN.uv_myTex) * green).rgb;
            }
        ENDCG
    }
        FallBack "Diffuse"
}
