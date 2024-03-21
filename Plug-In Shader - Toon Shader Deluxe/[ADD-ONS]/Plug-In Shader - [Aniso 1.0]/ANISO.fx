//==============================//
//
// - Plug-In Shader Aniso Filter - By Infu_D, Joshua: 1.8
//
//==============================//
	
	// Aniso:
	float Size = 8.0f; // Blur Size (Radius)
	float Intensity = 1.2;  // Aniso Intensity
	//  More settings in "ps_aniso".
	
//==============================//
float Script : STANDARDSGLOBAL <
	string ScriptOutput = "color";
	string ScriptClass = "scene";
	string ScriptOrder = "postprocess";
> = 0.8;
//==============================//

// オリジナルの描画結果を記録するためのレンダーターゲット
texture2D ScnMap : RENDERCOLORTARGET <
	float2 ViewportRatio = {1.0f, 1.0f};
	bool AntiAlias = true;
	int MipLevels = 1;
	string Format = "A16B16G16R16F";
>;

sampler2D ScnSamp = sampler_state {
	texture = <ScnMap>;
	MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET <
	string Format = "D24S8";
>;

texture2D ExpandTex : RENDERCOLORTARGET <
	bool AntiAlias = true;
	int Miplevels = 0;
	float2 ViewPortRatio = {1.0f, 1.0f};
	string Format = "A16B16G16R16F";
>;
sampler2D g_expand_s = sampler_state {
	texture = <ExpandTex>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

shared texture2D AnisoTex : RENDERCOLORTARGET <
	bool AntiAlias = true;
	string Format = "A16B16G16R16F";
>;
	
//  Textures / Samplers  :
//=== ANISO ===//
texture2D ANISO_Mat : OFFSCREENRENDERTARGET
<
    string Description = "Aniso Material Array";
    float2 ViewPortRatio = {1.0f, 1.0f};
    float4 ClearColor = {1.0f, 1.0f, 1.0f, 0.0f};
    float ClearDepth = 1.0f;
	bool AntiAlias = true;
	int Miplevels = 0;
	string Format = "A16B16G16R16F";
	string DefaultEffect =
	    //"self=hide;"
	    "*=ANISO/V.fx;";
>;
sampler2D SSSS = sampler_state {
    texture = <ANISO_Mat>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
};

//=== DEPTH ===//
texture DEPTH_SF : OFFSCREENRENDERTARGET
<   string Description = "SSS Material Array";
    float2 ViewPortRatio = {1.0f, 1.0f};
    float4 ClearColor = {0.0f, 0.0f, 0.0f, 0.0f};
    float ClearDepth = 1.0f;
	bool AntiAlias = true;
	int Miplevels = 1;
	string Format = "D3DFMT_R32F";
	string DefaultEffect = 
        "self = hide;"
        "*=ANISO/Depth.fx;";
>;

sampler2D DS = sampler_state {
	texture = <DEPTH_SF>;
	MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
    MIPFILTER = LINEAR;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
};

// レンダリングターゲットのクリア値
float4 ClearColor = {0,0,0,0};
float ClearDepth  = 1.0;

float2 ViewportSize : VIEWPORTPIXELSIZE;
static const float2 ViewportOffset = float2(0.5,0.5)/ViewportSize;
#define cmp

//============================================================================//
//  Base Structure  :
struct vs_in
{
  float4 v0 : POSITION0;
  float4 v1 : TEXCOORD0;
  float4 v2 : TEXCOORD1;
  float4 v3 : TEXCOORD2;
  float4 v4 : TEXCOORD3;
};
struct vs_out
{
  float4 o0 : SV_POSITION0;
  float4 o1 : TEXCOORD0;
  float4 o2 : TEXCOORD1;
  float4 o3 : TEXCOORD2;
  float4 o4 : TEXCOORD3;
};
//============================================================================//
//  Vertex Shader(s)  :
vs_out vs_model (vs_in i)
{
    vs_out o = (vs_out)0;
		
  o.o0 = i.v0;
  o.o1 = i.v1 + ViewportOffset.xyxy;
  
  float4 g_texcoord_modifier = float4(1, 1, 0, 0);
	float4 g_texel_size = float4(ViewportSize.xy*0.5*0.5* 0.00001, 320.00*2, 180.00*2);
	float2 r0 = i.v1;
  r0.xy = r0.xy * g_texcoord_modifier.xy + g_texcoord_modifier.zw;
  
  o.o2.xy = r0.xy;
  o.o3.xyzw = g_texel_size.xyxy * float4(-2,0,2,0) + r0.xyxy;
  o.o4.xyzw = g_texel_size.xyxy * float4(0,8,0,-8) + r0.xyxy;
  
    return o;
}
//============================================================================//
// Fragment Shader(s) :
float4 ps_model(vs_out i) : COLOR0
{	
  float2 v1 = i.o1;
  float4 o0 = 0;
  
  float Pi = 6.28318530718; // Pi*2
  
	float Quality = 4.0f; // Blur Quality (Default 4.0)
    float Directions = 16.0f; // Blur Directions (Default 16.0)   
    float2 Radius = (Size * saturate(1-tex2D(DS, v1)/100))/ViewportSize.xy;
    
    // Normalized pixel coordinates (from 0 to 1)
    float2 uv = v1.xy;
    // Pixel colour
    float4 Color = tex2D(g_expand_s, uv);
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
			Color += pow(tex2D( g_expand_s, uv+float2(cos(d),sin(d))*Radius*i), 2.2);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions;
	  return pow(0.45, saturate(1 - Color)/2.2) * Intensity;
}

float4 ps_expand(vs_out i) : COLOR0
{	
  float4 r0 = 1;
  float4 r1 = 1;
  float4 r2 = 1;
		
  float4 v1 = i.o1;
  float4 v2 = i.o3;
  float4 v3 = i.o4;
  float4 o0 = 0;
  
  r0.xyzw = tex2D(SSSS, v1.xy).xyzw;
  r1.x = cmp(r0.w == 1.000000);
  if (r1.x != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return o0;
  }
  r1.xyzw = tex2D(SSSS, v2.xy).xyzw;
  r2.x = cmp(r0.w < r1.w);
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  r1.xyzw = tex2D(SSSS, v2.zw).xyzw;
  r2.x = cmp(r0.w < r1.w);
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  r1.xyzw = tex2D(SSSS, v3.xy).xyzw;
  r2.x = cmp(r0.w < r1.w);
  r0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  r1.xyzw = tex2D(SSSS, v3.zw).xyzw;
  r2.x = cmp(r0.w < r1.w);
  o0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;
  return o0 = 1;
}

float4 ps_screen(vs_out i, float2 UV : TEXCOORD0) : COLOR0
{	
  return tex2D(ScnSamp, UV).xyzw;
}
//============================================================================//
//  Technique(s)  : 
technique SSS <
	string Script = 
		"RenderColorTarget0=ExpandTex;"
		"RenderDepthStencilTarget=DepthBuffer;"
        "ClearSetColor=ClearColor;"
        "ClearSetDepth=ClearDepth;"
        "Clear=Color;"
        "Clear=Depth;"
		"Pass=Expand;"
		
		"RenderColorTarget0=AnisoTex;"
		"RenderDepthStencilTarget=DepthBuffer;"
        "ClearSetColor=ClearColor;"
        "ClearSetDepth=ClearDepth;"
        "Clear=Color;"
        "Clear=Depth;"
		"Pass=Main;"

		"RenderColorTarget0=ScnMap;"
        "RenderDepthStencilTarget=DepthBuffer;"
        "ClearSetColor=ClearColor;"
        "ClearSetDepth=ClearDepth;"
        "Clear=Color;"
        "Clear=Depth;"
			
		"RenderColorTarget0=;"
        "RenderDepthStencilTarget=;"
        "Pass=Screen;"
	;
> {
	pass Main < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = FALSE;	AlphaTestEnable = FALSE;
		VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_model();
	}
	pass Expand < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = FALSE;	AlphaTestEnable = FALSE;
		VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_expand();
	}
	pass Screen < string Script= "Draw=Buffer;"; > {
		AlphaBlendEnable = FALSE;	AlphaTestEnable = FALSE;
		VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_screen();
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////
