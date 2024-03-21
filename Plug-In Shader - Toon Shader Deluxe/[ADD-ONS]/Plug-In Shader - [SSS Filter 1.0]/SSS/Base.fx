//////////////////////////////////////////////////////////////////////////////////////
//
// - Plug-In Shader - by Joshua: SSS Sampler
// Base Shader: Simple Soft Shader by BeanManP
//
//////////////////////////////////////////////////////////////////////////////////////
// Shader Type
//TYPE 0 = Simple Soft Shader
//TYPE 1 = Half Lambert shader (EDITED)

#define SHADER_TYPE 1
//////////////////////////////////////////////////////////////////////////////////////
// Shadow Color
float4 Shadow_Color = float4(1,1,1,1.0);

// Soft Shadow Blur
float SoftShadowParam = 0.5;

// Shadow Size
#define SHADOWMAP_SIZE 1024

// Toon
float Toon_Gradient = 2.0;
float Toon_Smooth = 1.5;
float Toon_Intensity = 0.6;

//////////////////////////////////////////////////////////////////////////////////////
// Normal Map

#define APPLY_NORMALMAP  0
#define APPLY_ANIMATED_NORMALMAP 0
#define NormalMap_Texture "n.png";

#define FLIP_NORMALMAP 0
float NormalMap_Intensity = 0.0;

//////////////////////////////////////////////////////////////////////////////////////
// IBL

#define APPLY_IBL 1
#define APPLY_IBL_LIGHT_DIRECTION 1

// IBL TEXTURE
#define IBL_Texture "IBL/IBL.dds";

float IBL_Intensity = 0.3;
float IBL_Brightness = 1.5;

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

#include "Resources/SSS.fxsub"