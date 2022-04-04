Shader "monkybusines/Properties"
{
    Properties
    {
        _myColor ("Color", Color) = (1,1,1,1)
        _myRange ("Range", Range(0,5)) = 1 //range between 0 and 5
        _myTex("Texture", 2D) = "white" {} //gives white color on top
        _myCube("Cube", CUBE) = "" {} //empty or nothing set
        _myFloat("Float", Float) = 0.5 //float value
        _myVector("Vector", Vector) = (0.5,1,1,1) //4 floating values given
    }
    SubShader
    {
        CGPROGRAM
            #pragma surface surf Lambert

            fixed4 _myColor;
            half _myRange;
            sampler2D _myTex;
            samplerCUBE _myCube;
            float _myFloat;
            float4 _myVector;

            struct Input
            {
                float2 uv_myTex; //any UV values must start with uv or uv2 followed by name of the texture
                float3 worldRefl; 
            };

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = (tex2D(_myTex, IN.uv_myTex) * _myRange * _myColor).rgb; //tex2D takes uv model and slaps the texture onto it. then we grab the rgb channels
                o.Emission = texCUBE(_myCube, IN.worldRefl).rgb;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
