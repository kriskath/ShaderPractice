Shader "Freya/Shader1"
{
    Properties //Input Data. Materials will use these properties to modify their values
    {
        _Value ("Value", Float) = 1.0 
    }
    SubShader //Contains passes
    {
        Tags { "RenderType"="Opaque" } //specifies how shader should render. Render-pipeline related

        Pass //The pass in the subShader. Contains actual Shader Code
        {
            //Pass can also have tags. They are more render specific for this pass

            CGPROGRAM
            //This tells compiler what function is vertex & fragment shader
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" //contains unity specific things and functions


            //Must declare variables for any Properties made
            float _Value;
            
            
            //Per vertex mesh data
            struct MeshData
            {
                float4 vertex : POSITION; //vertex position. vertex is a variable name, while POSITION is data being passed into the variable
                float3 normals : NORMAL;
                float2 uv0 : TEXCOORD0; // uv0 coordinate. Used for mapping textures to objects. TEXCOORD0 is the uv channel 0. 
                float2 uv1 : TEXCOORD1; // uv1 coordinate. 
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };


            v2f vert (MeshData v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
