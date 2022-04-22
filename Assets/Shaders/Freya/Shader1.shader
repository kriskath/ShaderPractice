Shader "Freya/Shader1"
{
    Properties //Input Data. Materials will use these properties to modify their values
    {
        _ColorA ("Color A", Color) = (1, 1, 1, 1) 
        _ColorB ("Color B", Color) = (1, 1, 1, 1) 
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1

        _Scale ("UV Scale", Float) = 1
        _Offset ("UV Offset", Float) = 0
    }
    SubShader //Contains passes
    {
        //subshader tags //specifies how shader should render. Render-pipeline related
        Tags 
        { 
            "RenderType"="Transparent" //for tagging to inform Render Pipeline what type it is. For Post-Processing
            "Queue"="Transparent" //modifies order at which this is rendered in
        } 

        Pass //The pass in the subShader. Contains actual Shader Code
        {
            //Pass can also have tags. They are more render specific for this pass

            Cull Off //sets it so it renders on both Front and Back side of the mesh
            ZWrite Off //makes it so this object does not write to depth buffer
            ZTest LEqual //LEqual (default), GEqual, Always - Affects how it is drawn when behind or in front of something

            //Blending: src * A (+-) dst * B -- We supply values for A & B.
            Blend One One // Additive blending
            //Blend DstColor Zero // Multiplicitive blending


            CGPROGRAM
            //This tells compiler what function is vertex & fragment shader
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" //contains unity specific things and functions
            
            #define TAU 6.28318530718



            // bool - 0 1
            // int 
            // float4 (32 bit float) used most, like Vector4
            // half (16 bit float) usually used
            // fixed (lower precision bit float) -1 to 1
            // float4 -> half4 -> fixed4
            // float4x4 -> half4x4 (C#: Matrix4x4)

            //Must declare variables for any Properties made
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            
            float _Scale;
            float _Offset;
            
            

            //Per vertex mesh data
                //automatically filled out by unity
            //mesh data input to the vertex shader. take what we care from the mesh for the shader
            struct MeshData
            {
                //the most commonly used variables are listed below

                float4 vertex : POSITION; //vertex position. vertex is a variable name, while POSITION is data being passed into the variable
                float3 normals : NORMAL; //populates normals variable with the local space normal of the mesh

                //float4 color : COLOR; // vertex colors
                //float4 tangent : TANGENT; //tangent direction (xyz) tangent sign (w)

                //UV channels can be defined by you. Channel 0 may be normal map textures, while Channel 1 is the lightmap coordinates
                    //TEXCOORDN in the MeshData exclusively refers to UV coordinates
                float2 uv0 : TEXCOORD0; // uv0 coordinate. Used for mapping textures to objects. TEXCOORD0 is the uv channel 0. 
                //float2 uv1 : TEXCOORD1; // uv1 coordinate. 
            };



            //The data passed from the vertex shader to the fragment shader is using this struct.
            //Called interpolator due to fragment shader interpolating data (normals, colors) on pixels.
            //Interpolated value is given from defined value in vertex shader.
            struct Interpolators
            {
                // *** THIS VARIABE IS MANDATORY ***
                float4 vertex : SV_POSITION; //clip space position of each vertex. Vertex interpolator that always has clip position

                //TEXCORRDN in Interpolators Does NOT exclusively refer to UV corrdinates. They can be anything. They are channels to send data through
                float3 normal : TEXCOORD0; //normals are a 3d vector
                float2 uv : TEXCOORD1;
                //float2 justSomeValues : TEXCOORD2; //could be absolutely anything, not just UVs
            };




            //better to do as much in Vertex Shader rather than Fragment Shader. There are less verts than pixels generally
            //job is to send data to the fragment shader and set the clip space position of the vertex.
            Interpolators vert (MeshData v)
            {
                Interpolators o;

                //without this clip space conversion the shader will only appear on clip space, which looks like its slapped on the screen. 
                    //usefull for post-processing shaders as those are screen wide shaders
                o.vertex = UnityObjectToClipPos(v.vertex); //multiplying by MVP (Model, View, Projection) Matrix. Converts local space to clip space
                
                //must pass normal value with something so fragment shader has something to output.
                    //brings from local space to world space.
                o.normal = UnityObjectToWorldNormal(v.normals); 
                
                o.uv = v.uv0; //(v.uv0 + _Offset) * _Scale; // passthrough

                return o;
            }




            float InverseLerp( float a, float b, float v)
            {
                return (v - a)/(b - a);
            }

            // SV_Target tells that this fragment shader should target the Frame Buffer
            float4 frag (Interpolators i) : SV_Target
            {
                //_Time.xyzw //global variable. has xyzw components. Each component is in different time. y - seconds,  w - seconds/20


                float xOffset = cos(i.uv.x * TAU * 8) * 0.01; //makes a zigzag effect based on vertical axis

                float t = cos((i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;

                t *= 1-i.uv.y; //causes color to fade

                float topBottomRemover = (abs(i.normal.y) < 0.999);
                float waves = t * topBottomRemover;

                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
                return gradient * waves;

                //saturate clamps the value to 0 or 1
                //float t = saturate( InverseLerp(_ColorStart, _ColorEnd, i.uv.x) );

                //frac = v - floor(v). If we see a repeating pattern then a 0 to 1 value is over or undershooting from that range. frac is good for testing this
                //t = frac(t);
                //return t;

                //blend between two colors based on the X UV coordinate
                //float4 outColor = lerp(_ColorA, _ColorB, t);
                //return outColor;

                //return float4(i.normal, 0);

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
