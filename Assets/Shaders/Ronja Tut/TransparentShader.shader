Shader "monkybusines/ronja/TransparentSpriteShader"{

	//This shader has transparency effects

	//Show values to edit in inspector
	Properties{
		_Color("Tint", Color) = (0, 0, 0, 1)
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader{

	//The material is completely transparent. 
		//By changing queue, the material is rendered after opaque materials. 
		//If not the case then an opaque material would render over the transparent one
	Tags{
		"RenderType" = "Transparent"
		"Queue" = "Transparent"
	}

	//Blanding mode defines how the existing colors and new colors blend with each other
		//defined by two keywords: 1) defines the value the new color is multiplied with 2) defines the value the old color is multiplied with
		//afterwards the colors are added together
	//When rendering opaque materials, blend mode is "1 0" because we take only new value and nothing of old.
	//For transparency we want to use alpha value and inverse of it
	Blend SrcAlpha OneMinusSrcAlpha

	//This disables objects behind this from writing over this one. We want this so we can see them with the transparent object
	ZWrite off

	Pass{

		CGPROGRAM

		//Includes shader functions
		#include "UnityCG.cginc"

		//define vertex and fragment shader functions
			//to define which functions represent certain stages we need to use #pragma and the function type followed by its name
		#pragma vertex vert //the vertex shader takes the data that defines the model and transforms it into screenspace so it can be rendered
		#pragma fragment frag //after deciding which pixels get rendered the fragment shader decides the color of the pixel

		//texture and transforms of the texture
		sampler2D _MainTex;
		float4 _MainTex_ST;

		//tint of the texture
		fixed4 _Color;

		//the mesh data thats read by the vertex shader
		struct appdata {
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		//the data thats passed from the vertex to the fragment shader and interpolated by the rasterizer
		struct v2f {
			float4 position : SV_POSITION;
			float2 uv : TEXCOORD0;
		};

		//the vertex shader function
			//Takes in vertex data and returns interpolators
		v2f vert(appdata v) {
			v2f o;

			//convert the vertex positions from object space to clip space so they can be rendered correctly
			o.position = UnityObjectToClipPos(v.vertex);

			//apply the texture transforms to the UV coordinates and pass them to the v2f struct
				//this will transform the UV coordinates into uv coordinates that respect the tiling and offset that was set in editor
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);

			return o;
		}

		//the fragment shader function
			//takes in interpolators and returns a vector which writes into the render target
		fixed4 frag(v2f i) : SV_TARGET{

			//read the texture color at the uv coordinate to return color at the uv coordinate
			fixed4 col = tex2D(_MainTex, i.uv);

		//multiplay the texture color and tint color
		col *= _Color;

		return col;
	}

	ENDCG
	}
	}
}