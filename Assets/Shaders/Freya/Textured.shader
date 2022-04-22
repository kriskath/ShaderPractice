Shader "Freya/Textured"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} //this specifies a 2D texture. white is what is assigned when no texture is given
        _Pattern ("Pattern", 2D) = "white" {} //this specifies a 2D texture
        _Rock ("Rock", 2D) = "white" {} //this specifies a 2D texture
        _MipSampleLevel ("MIP", Float) = 0 //this specifies a 2D texture
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #define TAU 6.28318530718

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };



            sampler2D _MainTex; //Texture variable            
            sampler2D _Pattern; 
            sampler2D _Rock; 
            float _MipSampleLevel; 



            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex); //object to world pos
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv; //TRANSFORM_TEX(v.uv, _MainTex); //takes offset values and inputs them to the uv coordinates so they are scaled. Optional
                return o;
            }


            float GetWave( float coord )
            {
                float wave = cos((coord - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                wave *= coord; //fade out ripples
                return wave;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 topDownProjection = i.worldPos.xz;
                float4 moss = tex2Dlod(_MainTex, float4(topDownProjection, _MipSampleLevel.xx)); 
                float4 rock = tex2D(_Rock, topDownProjection); //space for textures to work in is 0 to 1 (normalized coordinates)
                float pattern = tex2D(_Pattern, i.uv).x;

                float4 finalColor = lerp(rock, moss, pattern);
                
                return finalColor;
                //return moss; //for mip
            }
            ENDCG
        }
    }
}
