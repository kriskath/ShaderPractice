Shader "monkybusines/ronja/SurfaceShader"
{
    //This shader will handle lighting in the scene

    Properties
    {
        _Color ("Color", Color) = (0,0,0,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0
        _Metallic("Metalness", Range(0, 1)) = 0
        [HDR] _Emission ("Emission", Color) = (0,0,0,1) //[HDR] is a tag that allows for values greater than 1

    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry"}


        CGPROGRAM
        
        //define surface function. starts with #pragma, followed by kind of shader declared, then by name of method, and lstly the lighting model for surface method 
        #pragma surface surf Standard fullforwardshadows
        //directive that sets the build target to 3.0, means Unity will use higher precision values for better lighting
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

        half _Smoothness;
        half _Metallic;
        half3 _Emission;

        //Holds information to set color of surface
        struct Input {
            float2 uv_MainTex; //uv is added so that it will already have the tiling and offset of the MainTex texture. By convention to get uv do "uv'texture_name'"
        };

            //inout keyword used to let unity know that the SurfaceOutpuObject will be returning with information to the generated part of the shader
        void surf(Input i, inout SurfaceOutputStandard o) {
            fixed4 col = tex2D(_MainTex, i.uv_MainTex);
            col *= _Color;
            o.Albedo = col.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
            o.Emission = _Emission;
        }

        ENDCG
    }
    FallBack "Standard" //Fallback allows unity to use functions in this shader. "Shadow pass" will be used from this to make better shadow effects
}
