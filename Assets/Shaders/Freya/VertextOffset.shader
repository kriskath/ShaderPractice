Shader "Freya/VertexOffset"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1, 1, 1, 1) 
        _ColorB ("Color B", Color) = (1, 1, 1, 1) 
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
        _WaveAmp ("Wave Amplitude", Range(0,0.2)) = 0.1
    }
    SubShader 
    {
        Tags 
        { 
            "RenderType"="Opaque" 
        } 

        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" 
            
            #define TAU 6.28318530718

            float GetWave( float2 uv );
            float InverseLerp( float a, float b, float v);

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            float _WaveAmp;

              
            struct MeshData
            {

                float4 vertex : POSITION; 
                float3 normals : NORMAL; 
                float2 uv0 : TEXCOORD0; 
            };


            struct Interpolators
            {
                float4 vertex : SV_POSITION; 
                float3 normal : TEXCOORD0; 
                float2 uv : TEXCOORD1;
            };


            Interpolators vert (MeshData v)
            {
                Interpolators o;

                //we are creating a wave value and modifying the local space vertex value to, before transforming it to clip space
                /*
                float wave_y = cos((v.uv0.y - _Time.y * 0.1) * TAU * 5);
                float wave_x = cos((v.uv0.x - _Time.y * 0.1) * TAU * 5);
                v.vertex.y = wave_y * wave_x * _WaveAmp;
                */

                v.vertex.y = GetWave(v.uv0) * _WaveAmp;
                o.vertex = UnityObjectToClipPos(v.vertex); 
                o.normal = UnityObjectToWorldNormal(v.normals); 
                o.uv = v.uv0;
                return o;
            }

            float InverseLerp( float a, float b, float v)
            {
                return (v - a)/(b - a);
            }

            float GetWave( float2 uv )
            {
                float2 uvsCentered = uv * 2 - 1; //centers uv from 0 to 1 -> -1 to 1
                float radialDistance = length(uvsCentered); //each pixel will show distance to the center
                float wave = cos((radialDistance - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;
                wave *= 1-radialDistance; //fade out ripples
                return wave;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
                return GetWave(i.uv) * gradient;
            }

            ENDCG
        }
    }
}
