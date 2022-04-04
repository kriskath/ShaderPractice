Shader "monkybusines/HelloShader" //folder that will show up when choosing shader
{

	Properties 
	{
		_myColor ("Example Color", Color) = (1,1,1,1) //Properties that will define things for shader. Editor formatting defined for inspector
		_myEmission ("Example Emission", Color) = (1,1,1,1) //Emission is a color for object like it is glowing
		_myNormal ("Example Normal", Color) = (1,1,1,1) 
	}

	//HLSL or CG written in here
	SubShader 
	{
		//Beginning CG Block
		CGPROGRAM
			//Compiler directive telling code how to be used. 
			//Surface indicates we are building a surface shader. 
			//surf is name of function containing surface shader.
			//Lambert is the type of lighting to use
			#pragma surface surf Lambert 

			//Input data required for the function
			struct Input 
			{
				float2 uvMainTex;
			};
		
			//fixed4 is a special shader data type. for now it is an array of 4 float values
			fixed4 _myColor;
			fixed4 _myEmission;
			fixed4 _myNormal;

			//The shader function.
				//Takes in input structure and shows type of output data expected.
				//Output changes depending on the type of lighting used. For Lambert it needs SurfaceOutput
			void surf(Input IN, inout SurfaceOutput o)
			{
				o.Albedo = _myColor.rgb;
				o.Emission = _myEmission.rgb;
				o.Normal = _myNormal.rgb;
			}

		//Ending CG Block
		ENDCG
	}

	//for inferior gpus to fall back on
	FallBack "Diffuse"
}