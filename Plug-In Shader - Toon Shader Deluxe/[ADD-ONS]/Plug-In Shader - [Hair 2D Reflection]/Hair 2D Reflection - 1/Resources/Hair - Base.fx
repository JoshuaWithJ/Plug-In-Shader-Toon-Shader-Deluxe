////////////////////////////////////////////////////////////////////////////////////////////////
//
//
// - Plug-In Shader - by Joshua: Hair Reflection Sampler
// Base Shader: Simple Soft Shader by BeanManP
// 
//
//////////////////////////////////////////////////////////////////////////////////////
// Blend Type
//TYPE 0 = ZERO
//TYPE 1 = ONE
//TYPE 2 = SrcColor
//TYPE 3 = INVSrcColor
//TYPE 4 = SrcAlpha
//TYPE 5 = INVSrcAlpha
//TYPE 6 = DestAlpha
//TYPE 7 = INVDestAlpha
//TYPE 8 = DestColor
//TYPE 9 = INVDestColor

#define BLEND_APPLY 1

#define SRC_BLEND_TYPE	4
#define DEST_BLEND_TYPE	5

///////////////////////////////////////////////
// Blend APPLY Type
//TYPE 0 = NONE
//TYPE 1 = FALSE
//TYPE 2 = TRUE

#define ALPHA_BLEND_APPLY	0
#define ALPHA_TEST_APPLY	0

#define ALPHA_BLEND_TYPE	0
#define ALPHA_TEST_TYPE		0

#define Z_WRITE_APPLY		0
#define Z_APPLY				0

#define Z_WRITE_TYPE		0
#define Z_TYPE				0

///////////////////////////////////////////////
// CullMode
//TYPE 0 = NONE
//TYPE 1 = CW
//TYPE 2 = CCW

#define CULLMODE_APPLY		0

#define CULLMODE_TYPE		0
//////////////////////////////////////////////////////////////////////////////////////
//Samplers

// Object Texture
texture ObjectTexture: MATERIALTEXTURE;
sampler ObjTexSampler = sampler_state {
    texture = <ObjectTexture>;
    FILTER= ANISOTROPIC;
    AddressU  = WRAP;
    AddressV  = WRAP;
};

////////////////////////////////////////////////////////////////////////////////////////////////
// Sequence of transformations
float4x4 WorldViewProjMatrix		: WORLDVIEWPROJECTION;
float4x4 WorldViewMatrix			: WORLDVIEW;
float4x4 WorldMatrix				: WORLD;
float4x4 ViewMatrix					: VIEW;
float4x4 LightWorldViewProjMatrix	: WORLDVIEWPROJECTION < string Object = "Light"; >;

float3   LightDirection    : DIRECTION < string Object = "Light"; >;
float3   CameraPosition    : POSITION  < string Object = "Camera"; >;

bool     parthf;   // Perspective flag
bool     transp;   // Semi-transparent flag
bool	 spadd;    // Sphere map additive composition flag

////////////////////////////////////////////////////////////////////////////////////////////////

sampler DefSampler : register(s0);

struct BufferShadow_INPUT {
    float4 Pos      : POSITION; // Position
    float3 Normal   : NORMAL; // Normal
	float2 UV : TEXCOORD0;
};

struct BufferShadow_OUTPUT {
	float4 Pos 		: POSITION;
    float3 Normal   : NORMAL; // Normal
	float2 UV : TEXCOORD0;
};

///////////////////////////////////////////////////////////////////////////////////////////////
// Vertex Shader
BufferShadow_OUTPUT BufferShadow_VS(BufferShadow_INPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon)
{
	BufferShadow_OUTPUT Out = (BufferShadow_OUTPUT)0;
	// UV
	Out.UV = IN.UV;
	
	// Vertex Normal
	Out.Normal = normalize( mul( IN.Normal, (float3x3)WorldMatrix ) );
	
	// World view projective transformation from camera perspective
	Out.Pos = mul( IN.Pos, WorldViewProjMatrix );
	
	return Out;
}
//////////////////////////////////////////////////
// Pixel Shader
float4 BufferShadow_PS(BufferShadow_OUTPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon) : COLOR
{
//////////////////////////////////////////////////
// Inputs
//////////////////////////////////////////////////
	float3 Normal		= normalize(IN.Normal);
//////////////////////////////////////////////////
	float4 TexColor		= tex2D( ObjTexSampler, IN.UV );
    float4 Color		= 1;
    Color.rgb			*= (0,0,0);
    Color.a				*= TexColor.a;
    Color.a				*= TexColor.a;
//////////////////////////////////////////////////

        return Color;
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Techniques
technique MainTecBS0  < string MMDPass = "object_ss"; bool UseTexture = false; bool UseSphereMap = false; bool UseToon = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 BufferShadow_VS(false, false, false);
        PixelShader  = compile ps_3_0 BufferShadow_PS(false, false, false);
    }
}

technique MainTecBS1  < string MMDPass = "object_ss"; bool UseTexture = true; bool UseSphereMap = false; bool UseToon = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 BufferShadow_VS(true, false, false);
        PixelShader  = compile ps_3_0 BufferShadow_PS(true, false, false);
    }
}

technique MainTecBS2  < string MMDPass = "object_ss"; bool UseTexture = false; bool UseSphereMap = true; bool UseToon = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 BufferShadow_VS(false, true, false);
        PixelShader  = compile ps_3_0 BufferShadow_PS(false, true, false);
    }
}

technique MainTecBS3  < string MMDPass = "object_ss"; bool UseTexture = true; bool UseSphereMap = true; bool UseToon = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 BufferShadow_VS(true, true, false);
        PixelShader  = compile ps_3_0 BufferShadow_PS(true, true, false);
    }
}

// オブジェクト描画用テクニック（PMDモデル用）
technique MainTecBS4  < string MMDPass = "object_ss"; bool UseTexture = false; bool UseSphereMap = false; bool UseToon = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 BufferShadow_VS(false, false, true);
        PixelShader  = compile ps_3_0 BufferShadow_PS(false, false, true);
    }
}

technique MainTecBS5  < string MMDPass = "object_ss"; bool UseTexture = true; bool UseSphereMap = false; bool UseToon = true; > {
    pass DrawObject {
		#if BLEND_APPLY == 1
		
		#if SRC_BLEND_TYPE == 0
		SRCBLEND = ZERO;
		#endif
		#if SRC_BLEND_TYPE == 1
		SRCBLEND = ONE;
		#endif
		#if SRC_BLEND_TYPE == 2
		SRCBLEND = SrcColor;
		#endif
		#if SRC_BLEND_TYPE == 3
		SRCBLEND = INVSrcColor;
		#endif
		#if SRC_BLEND_TYPE == 4
		SRCBLEND = SrcAlpha;
		#endif
		#if SRC_BLEND_TYPE == 5
		SRCBLEND = INVSrcAlpha;
		#endif
		#if SRC_BLEND_TYPE == 6
		SRCBLEND = DestAlpha;
		#endif
		#if SRC_BLEND_TYPE == 7
		SRCBLEND = INVDestAlpha;
		#endif
		#if SRC_BLEND_TYPE == 8
		SRCBLEND = DestColor;
		#endif
		#if SRC_BLEND_TYPE == 9
		SRCBLEND = INVDestColor;
		#endif

		#if DEST_BLEND_TYPE == 0
		DESTBLEND = ZERO;
		#endif
		#if DEST_BLEND_TYPE == 1
		DESTBLEND = ONE;
		#endif
		#if DEST_BLEND_TYPE == 2
		DESTBLEND = SrcColor;
		#endif
		#if DEST_BLEND_TYPE == 3
		DESTBLEND = INVSrcColor;
		#endif
		#if DEST_BLEND_TYPE == 4
		DESTBLEND = SrcAlpha;
		#endif
		#if DEST_BLEND_TYPE == 5
		DESTBLEND = INVSrcAlpha;
		#endif
		#if DEST_BLEND_TYPE == 6
		DESTBLEND = DestAlpha;
		#endif
		#if DEST_BLEND_TYPE == 7
		DESTBLEND = INVDestAlpha;
		#endif
		#if DEST_BLEND_TYPE == 8
		DESTBLEND = DestColor;
		#endif
		#if DEST_BLEND_TYPE == 9
		DESTBLEND = INVDestColor;
		#endif
		
		#endif

		#if ALPHA_BLEND_APPLY == 1
		
		#if ALPHA_BLEND_TYPE == 1
		ALPHABLENDENABLE = FALSE;
		#endif
		
		#if ALPHA_BLEND_TYPE == 2
		ALPHABLENDENABLE = TRUE;
		#endif
		
		#endif
		
		#if ALPHA_TEST_APPLY == 1
		
		#if ALPHA_TEST_TYPE == 1
		ALPHATESTENABLE = FALSE;
		#endif

		#if ALPHA_TEST_TYPE == 2
		ALPHATESTENABLE = TRUE;
		#endif

		#endif
		
		#if Z_WRITE_APPLY == 1
		
		#if Z_WRITE_TYPE == 1
		ZWRITEENABLE = FALSE;
		#endif
		
		#if Z_WRITE_TYPE == 2
		ZWRITEENABLE = TRUE;
		#endif
		
		#endif
		
		#if Z_ENABLE_APPLY == 1
		
		#if Z_TYPE == 1
		ZENABLE = FALSE;
		#endif
		
		#if Z_TYPE == 2
		ZENABLE = TRUE;
		#endif
		
		#endif
		
		#if CULLMODE_APPLY == 1
		
		#if CULLMODE_TYPE == 0
		CULLMODE = NONE;
		#endif
		
		#if CULLMODE_TYPE == 1
		CULLMODE = CW;
		#endif
		
		#if CULLMODE_TYPE == 2
		CULLMODE = CCW;
		#endif
		
		#endif
        VertexShader = compile vs_3_0 BufferShadow_VS(true, false, true);
        PixelShader  = compile ps_3_0 BufferShadow_PS(true, false, true);
    }
}

technique MainTecBS6  < string MMDPass = "object_ss"; bool UseTexture = false; bool UseSphereMap = true; bool UseToon = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 BufferShadow_VS(false, true, true);
        PixelShader  = compile ps_3_0 BufferShadow_PS(false, true, true);
    }
}

technique MainTecBS7  < string MMDPass = "object_ss"; bool UseTexture = true; bool UseSphereMap = true; bool UseToon = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 BufferShadow_VS(true, true, true);
        PixelShader  = compile ps_3_0 BufferShadow_PS(true, true, true);
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////
