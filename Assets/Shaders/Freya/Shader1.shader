Shader "Freya/Shader1"
{
    Properties //Input Data. Materials will use these properties to modify their values
    {
        _Color ("Color", Color) = (1, 1, 1, 1) 
        
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


            // bool - 0 1
            // int 
            // float4 (32 bit float) used most, like Vector4
            // half (16 bit float) usually used
            // fixed (lower precision bit float) -1 to 1
            // float4 -> half4 -> fixed4
            // float4x4 -> half4x4 (C#: Matrix4x4)

            //Must declare variables for any Properties made
            float4 _Color;
            
            
            //Per vertex mesh data
                //automatically filled out by unity
            struct MeshData
            {
                float4 vertex : POSITION; //vertex position. vertex is a variable name, while POSITION is data being passed into the variable
                float3 normals : NORMAL; //populates normals variable with the normal of the mesh
                //float4 color : COLOR;
                //float4 tangent : TANGENT;

                //UV channels can be defined by you. Channel 0 may be normal map textures, while Channel 1 is the lightmap coordinates
                float2 uv0 : TEXCOORD0; // uv0 coordinate. Used for mapping textures to objects. TEXCOORD0 is the uv channel 0. 
                //float2 uv1 : TEXCOORD1; // uv1 coordinate. 
            };

            //The data passed from the vertex shader to the fragment shader is using this struct.
            //Called interpolator due to fragment shader interpolating data (normals, colors) on pixels.
            //Interpolated value is given from defined value in vertex shader.
            struct Interpolators
            {
                float4 vertex : SV_POSITION; //clip space position of each vertex. Vertex interpolator that always has clip position
                float3 normal : TEXCOORD0; //normals are a 3d vector
                //float2 uv : TEXCOORD0; //could be absolutely anything, not just UVs
            };



            Interpolators vert (MeshData v)
            {
                Interpolators o;

                //without this clip space conversion the shader will only appear on clip space, which looks like its slapped on the screen. 
                    //usefull for post-processing shaders as those are screen wide shaders
                o.vertex = UnityObjectToClipPos(v.vertex); //multiplying by MVP (Model, View, Projection) Matrix. Converts local space to clip space
                
                o.normal = v.normals; //must pass normal value with something so fragment shader has something to output
                
                return o;
            }



            // SV_Target tells that this fragment shader should target the Frame Buffer
            float4 frag (Interpolators i) : SV_Target
            {
                return float4( i.normal, 1 );

                //example of swizzling
                /*
                float4 myValue;
                float2 otherValue = myValue.gr;
                float4 otherValue1 = myValue.xxxx;
                */
            }

            ENDCG
        }
    }
}
