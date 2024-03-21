//////////////////////////////////////////////////////////////////////////////////////
//
// - Plug-In Shader - by Joshua: Toon Shader Deluxe
//   Base Shader: Simple Soft Shader by BeanManP
//
//////////////////////////////////////////////////////////////////////////////////////
// ToneMap
#define APPLY_TONE_MAP	1

float Tone_Map_Intensity    = 1.0;

float Exposure    = 2.0;
float Saturation = 1.0;
float Gama = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
// Shader Type
//TYPE 0 = Simple Soft Shader
//TYPE 1 = Half Lambert shader (EDITED)

#define SHADER_TYPE 1
//////////////////////////////////////////////////////////////////////////////////////
// Shadow Color
#define APPLY_SHADER_SHADOW_COLOR 1
float4 Shadow_Color = float4(1.0,1.0,1.0,1.0);

// Soft Shadow Blur
float SoftShadowParam = 0.5;

// Shadow Size
#define SHADOWMAP_SIZE 1024

//////////////////////////////////////////////////////////////////////////////////////
//Texture
float Texture_Brightness = 1.5;

// Toon
float Toon_Gradient = 20.0;
float Toon_Smooth = 1.0;
float Toon_Intensity = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
// Animated Texture

#define APPLY_ANIMATED_TEXTURE 0
#define Animated_Texture "GIF.gif";

//////////////////////////////////////////////////////////////////////////////////////
// Toon Mask

#define APPLY_TOON_MASK  0
#define APPLY_TOON_REFLECTION_MASK  0

#define ToonMask_Texture			"Pattern 1.png";
#define ToonMaskReflection_Texture	"Pattern 2.png";

#define APPLY_TOON_REFLECTION_MASK_SPECULAR 0
#define APPLY_TOON_REFLECTION_MASK_RIMLIGHT 0

float ToonMask_Scale = 250.0;
float ToonMask_Intensity = 1.0;

float ToonMaskReflection_Scale = 300.0;
float ToonMaskReflection_Intensity = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
//Edge Line
float4 Edge_Line_Color = float4(1.0,1.0,1.0,1.0);
//////////////////////////////////////////////////////////////////////////////////////
// Normal Map

#define APPLY_NORMALMAP  0
#define APPLY_ANIMATED_NORMALMAP 0
#define NormalMap_Texture "n.png";

#define FLIP_NORMALMAP 0
float NormalMap_Intensity = 0.5;

//////////////////////////////////////////////////////////////////////////////////////
// Specular Map

#define APPLY_SPECULARMAP 0
#define SpecularMap_Texture "S.png";

//////////////////////////////////////////////////////////////////////////////////////
// Alpha Channel

#define APPLY_ALPHA 1

#define APPLY_ALPHA_CLIP 0
float Alpha_Clip        = 0.0; //Set a value from 0 to 1

//////////////////////////////////////////////////////////////////////////////////////
// Alpha Color Channel

#define APPLY_COLOR_ALPHA 0

float3 Alpha_Color = float3(0,0,0);
float Alpha_Color_Intensity = 1;

//////////////////////////////////////////////////////////////////////////////////////
//Transparency Mask

#define APPLY_TRANSPARENCY  0
#define TRANSPARENCY_COLOR_TYPE  0
#define Transparency_Texture "T.png";

float Transparency_Intensity = 1.0;

float4 Transparency_Color = float4(1, 1, 1, 1);

//////////////////////////////////////////////////////////////////////////////////////
//Alpha Mask
//Alpha Mask UV 0 = UV
//Alpha Mask UV 1 = UV1

#define APPLY_ALPHA_MASK  0
#define APPLY_ALPHA_MASK_UV 0
#define Alpha_Mask_Texture "A.png";

#define APPLY_ALPHA_MASK_RGB_CHANNELS 0

#define R_CHANNEL_ALPHA_MASK 0
#define G_CHANNEL_ALPHA_MASK 0
#define B_CHANNEL_ALPHA_MASK 0
//////////////////////////////////////////////////////////////////////////////////////
// OVER TRANSPARENCY

#define APPLY_OVER_TRANSPARENCY 0

//////////////////////////////////////////////////////////////////////////////////////
// Specular

#define APPLY_SHADER_SPECULAR 1
#define APPLY_SPECULAR 1

float Specular_Shininess = 1.0;

float4 Specular_Color = float4(1.0, 1.0, 1.0, 1.0);

float Specular_Pos_X = 0.0;
float Specular_Pos_Y = -2.5;

//////////////////////////////////////////////////////////////////////////////////////
//Aniso
#define APPLY_ANISO  0

float Aniso_Size = 1.0;

float Aniso_Pos_X = 0.0;
float Aniso_Pos_Y = 0.0;

float3 Aniso_Back = 0.0;
float3 Aniso_Softness = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
// Environment Maps

#define APPLY_TINT 1

// SPA
#define APPLY_SPA 0

// CubeMap
#define APPLY_CUBEMAP 0
#define APPLY_CUBEMAP_LIGHT_DIRECTION 1
#define CubeMap_Texture "CubeMap.dds";

//////////////////////////////////////////////////////////////////////////////////////
//Refraction

#define APPLY_REFRACTION 0
#define APPLY_REFRACTION_REFLECTION 0

#define APPLY_REFRACTION_LIGHT_DIRECTION 0
#define APPLY_REFRACTION_SPECULARMAP 0

#define Refraction_Texture "CUBEMAP.DDS";

float Refraction_Intensity	= 1.0;
float Refraction_Index		= 1.0;

#define WIDTH       512
#define HEIGHT      512
#define APPLY_REFRACTION_ANTI_ALIAS 0

////////////////////////////////////////////////////////////////////////////////////////
// Rim Light
//TYPE 0 = DISABLED
//TYPE 1 = RimLight (Automatic)
//TYPE 2 = Fresnel (Automatic)
//TYPE 3 = Custom RimLight (Non-Automatic)

#define APPLY_RIMLIGHT_TYPE 0

#define APPLY_RIMLIGHT_LIGHT_DIRECTION 0

float Custom_RimLight_Size = 1.0;

float3 Custom_RimLight_Color = float3(1.0, 1.0, 1.0);

//////////////////////////////////////////////////////////////////////////////////////
// SubSurfaceToon

#define APPLY_SUBSURFACETOON  0
#define APPLY_SUBSURFACETOON_MAP  0
#define SubSurfaceToon_Map_Texture "T.png";

float SubSurfaceToon_Size		= 1.0;
float SubSurfaceToon_Bright		= 1.0;
float3 SubSurfaceToon_Color		= float3(1.0,0.0,0.0);

//////////////////////////////////////////////////////////////////////////////////////
// SubSurfaceToon Filter

#define APPLY_SUBSURFACETOON_FILTER_SHADOW 0

float SubSurfaceToon_Saturation = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
// Height Map
//TYPE 0 = Parallax / Offset
//TYPE 1 = Vertex

#define APPLY_HEIGHTMAP 0
#define APPLY_HEIGHTMAP_TYPE 0
#define HeightMap_Texture "H.png"

float HeightMap_Scale = 1.0;
float Height_Intensity = 0.0;

//////////////////////////////////////////////////////////////////////////////////////
// Vertex Color

#define APPLY_VERTEXCOLOR 0
float VertexColor_Intensity = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
// Ambient Occlussion
//Ambient Occlussion UV 0 = UV1
//Ambient Occlussion UV 1 = UV

#define APPLY_AMBIENTOCCLUSSION 0
#define APPLY_AMBIENTOCCLUSSION_UV 0
#define AmbientOcclussion_Texture "Shadow.png";

// TYPE 0 = NONE
// TYPE 1 = Multiply
// TYPE 2 = Add

#define AMBIENTOCCLUSSION_TYPE 1

#define APPLY_AMBIENTOCCLUSSION_RGB_CHANNELS 0

#define R_CHANNEL_AMBIENTOCCLUSSION 0
#define G_CHANNEL_AMBIENTOCCLUSSION 0
#define B_CHANNEL_AMBIENTOCCLUSSION 0

float Ambient_Occlussion_Intensity = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
// IBL

#define APPLY_IBL 0
#define APPLY_IBL_SPECULAR 0
#define APPLY_IBL_LIGHT_DIRECTION 1
#define APPLY_IBL_LIGHT_AMBIENT 0

// IBL TEXTURE
#define IBL_Texture "IBL/IBL.dds";

// IBL SPECULAR TEXTURE
#define IBL_Texture_2 "IBL/Specular.dds";

// IBL IRRADIANCE
#define IBL_Texture_3 "IBL/Irradiance.dds";

float IBL_Intensity = 1.0;
float IBL_Shadow_Intensity = 1.0;
float IBL_Brightness = 1.0;

//////////////////////////////////////////////////////////////////////////////////////
// Eye Mask

#define APPLY_EYEMASK 0
#define EyeMask_Texture "E.png";

// TYPE 0 = Multiply
// TYPE 1 = Add

#define EYEMASK_TYPE 1

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
#define Z_ENABLE_APPLY		0

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

#include "Resources/FXSUB - ToonShader.fxsub"