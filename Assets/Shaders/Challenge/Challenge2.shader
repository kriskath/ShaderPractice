Shader "monkybusines/Challenges/Challenge2"
{
    Properties
    {
        _myTex ("Texture", 2D) = "white" {}
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
                o.Albedo = (tex2D(_myTex, IN.uv_myTex)).rgb; //tex2D takes uv model and slaps the texture onto it. then we grab the rgb channels
                o.Albedo.g = 1;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
