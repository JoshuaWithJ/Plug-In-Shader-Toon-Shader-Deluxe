////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HgShadow_TestAliasingError.fx : HgShadow.fx �̃V���h�E�}�b�v Aliasing Error �̉���
//  �쐬: �j��P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

// HgShadow�̃p�����[�^����荞��
#include "../HgShadow_Header.fxh"

float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass = "sceneorobject";
    string ScriptOrder = "postprocess";
> = 0.8;

float AcsSi : CONTROLOBJECT < string name = "(self)"; string item = "Si"; >;
float AcsTr : CONTROLOBJECT < string name = "(self)"; string item = "Tr"; >;

// �V���h�E�}�b�v�o�b�t�@�T�C�Y
#define SMAPSIZE_WIDTH   ShadowMapSize
#define SMAPSIZE_HEIGHT  ShadowMapSize


// �I�t�X�N���[���V���h�E�}�b�v�e�X�g�f�[�^�o�b�t�@
shared texture HgS_Test : OFFSCREENRENDERTARGET <
    string Description = "HgShadow.fx�̃e�X�g�f�[�^";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 1 };
    float ClearDepth = 1.0;
    string Format = "D3DFMT_G32R32F";
    bool AntiAlias = false;
    int Miplevels = 1;
    string DefaultEffect = 
        "self = hide;"
        "* = HgShadow_Test.fxsub;"
        ;
>;
sampler DataSamp = sampler_state {
    texture = <HgS_Test>;
    MinFilter = POINT;
    MagFilter = POINT;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV = CLAMP;
};

// Aliasing Error �̊K���e�N�X�`��
texture2D GradationTex <
    string ResourceName = "grad.png";
>;
sampler GradSamp = sampler_state {
    texture = <GradationTex>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

// Aliasing Error �̖}��e�N�X�`��
texture2D HanreiTex <
    string ResourceName = "hanrei.png";
    int Miplevels = 0;
>;
sampler HanreiSamp = sampler_state {
    texture = <HanreiTex>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};


// �X�N���[���T�C�Y
float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset = float2(0.5,0.5) / ViewportSize;
static float2 SampStep = float2(1,1) / ViewportSize;


#ifdef MIKUMIKUMOVING
// �����_�����O�^�[�Q�b�g�̃N���A�l
float4 ClearColor = {0,0,0,1};
float ClearDepth  = 1.0;

// �I���W�i���̕`�挋�ʂ��L�^���邽�߂̃����_�[�^�[�Q�b�g
texture2D ScnMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    string Format = "D3DFMT_A8R8G8B8";
>;
sampler2D ScnSamp = sampler_state {
    texture = <ScnMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU = CLAMP;
    AddressV = CLAMP;
};

texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    string Format = "D24S8";
>;

// �s�N�Z���V�F�[�_
float4 PS_ScrDraw( float2 Tex: TEXCOORD0 ) : COLOR
{
    return tex2D( ScnSamp, Tex );
}
#endif


////////////////////////////////////////////////////////////////////////////////////////////////
// ���ʂ̒��_�V�F�[�_

struct VS_OUTPUT {
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

VS_OUTPUT VS_Common(float4 Pos : POSITION, float2 Tex: TEXCOORD)
{
    VS_OUTPUT Out = (VS_OUTPUT)0; 

    Out.Pos = Pos;
    Out.Tex = Tex + ViewportOffset;

    return Out;
}


////////////////////////////////////////////////////////////////////////////////////////////////
// Aliasing Error �}�b�v�`��

float4 PS_AliasingError( float2 Tex: TEXCOORD0 ) : COLOR
{
    float4 Color0  = tex2D( DataSamp, Tex );
    float4 ColorX1 = tex2D( DataSamp, Tex - float2(SampStep.x, 0) );
    float4 ColorX2 = tex2D( DataSamp, Tex + float2(SampStep.x, 0) );
    float4 ColorY1 = tex2D( DataSamp, Tex + float2(0, SampStep.y) );
    float4 ColorY2 = tex2D( DataSamp, Tex - float2(0, SampStep.y) );

    float4 Color = float4(0,0,0,0);
    if( !any( saturate(Color0.xy) - Color0.xy ) && any(Color0.xy) ) {
        float3 vec1 = float3((ColorX2.xy-ColorX1.xy)*0.5, 0);
        float3 vec2 = float3((ColorY2.xy-ColorY1.xy)*0.5, 0);
        float3 s = cross(vec1,vec2)*SMAPSIZE_WIDTH*SMAPSIZE_HEIGHT;
        float dpds = sqrt(1.0/length(s));
        float texCoordX = (log10(dpds) + 1.0f)*0.5f;
        float4 gradColor = tex2D( GradSamp, float2(texCoordX, 0.5f) );
        Color = float4(gradColor.rgb, AcsTr);
    }

    return Color;
}


////////////////////////////////////////////////////////////////////////////////////////////////
// �V���h�E�}�b�v�O���b�h�`��

#define GRID_WIDTH  16.0  // �O���b�h���̃e�N�Z���Ԋu
static float GridWidth = max(GRID_WIDTH * AcsSi * 0.1f, 1.0f);

// �s�N�Z���V�F�[�_
float4 PS_GridDraw( float2 Tex: TEXCOORD0 ) : COLOR
{
    float4 Color0 = tex2D( DataSamp, Tex );
    float4 Color1 = tex2D( DataSamp, Tex + float2(SampStep.x, 0) );
    float4 Color2 = tex2D( DataSamp, Tex + float2(0, SampStep.y) );

    float alpha = 0.0f;
    if( !any( saturate(Color0.xy) - Color0.xy ) ) {
        float gridX0 = frac(Color0.x*SMAPSIZE_WIDTH/GridWidth) - 0.5;
        float gridY0 = frac(Color0.y*SMAPSIZE_HEIGHT/GridWidth) - 0.5;
        float gridX1 = frac(Color1.x*SMAPSIZE_WIDTH/GridWidth) - 0.5;
        float gridY1 = frac(Color1.y*SMAPSIZE_HEIGHT/GridWidth) - 0.5;
        float gridX2 = frac(Color2.x*SMAPSIZE_WIDTH/GridWidth) - 0.5;
        float gridY2 = frac(Color2.y*SMAPSIZE_HEIGHT/GridWidth) - 0.5;

        alpha = step(gridX0*gridX1, 0);
        alpha = max(step(gridX0*gridX2, 0), alpha);
        alpha = max(step(gridY0*gridY1, 0), alpha);
        alpha = max(step(gridY0*gridY2, 0), alpha);
        alpha *= AcsTr*0.3;
    }

    return float4(0, 0, 0, alpha);
}


////////////////////////////////////////////////////////////////////////////////////////////////
// �}��`��

#define ScrSizeRate  4.0

// ���_�V�F�[�_
VS_OUTPUT VS_Hanrei( float4 Pos : POSITION, float2 Tex : TEXCOORD0 )
{
    VS_OUTPUT Out = (VS_OUTPUT)0;
    Pos.xy *= float2( 0.25f/ScrSizeRate, ViewportSize.x/ViewportSize.y/ScrSizeRate);
    #ifndef MIKUMIKUMOVING
    Out.Pos = Pos + float4( 0.25f/ScrSizeRate-1.0f, 1.0f-ViewportSize.x/ViewportSize.y/ScrSizeRate, 0, 0);
    #else
    Out.Pos = Pos + float4( 0.25f/ScrSizeRate-1.0f, ViewportSize.x/ViewportSize.y/ScrSizeRate-1.0f, 0, 0);
    #endif
    Out.Tex = Tex;
    return Out;
}

// �s�N�Z���V�F�[�_
float4 PS_Hanrei( float2 Tex: TEXCOORD0 ) : COLOR
{
    return tex2D( HanreiSamp, Tex );
}


////////////////////////////////////////////////////////////////////////////////////////////////
// �e�N�j�b�N

technique MainTech < string MMDPass = "object";
    string Script = 
        #ifdef MIKUMIKUMOVING
        "RenderColorTarget0=ScnMap;"
            "RenderDepthStencilTarget=DepthBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "ScriptExternal=Color;"
        #endif
        "RenderColorTarget0=;"
            "RenderDepthStencilTarget=;"
            #ifndef MIKUMIKUMOVING
            "ScriptExternal=Color;"
            #else
            "Pass=ScrDrawPass;"
            #endif
            "Pass=DrawAliasingError;"
            "Pass=DrawGrid;"
            "Pass=DrawHanrei;"
    ;
> {
    #ifdef MIKUMIKUMOVING
    pass ScrDrawPass < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable  = FALSE;
        VertexShader = compile vs_2_0 VS_Common();
        PixelShader  = compile ps_2_0 PS_ScrDraw();
    }
    #endif
    pass DrawAliasingError < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VS_Common();
        PixelShader  = compile ps_2_0 PS_AliasingError();
    }
    pass DrawGrid < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VS_Common();
        PixelShader  = compile ps_2_0 PS_GridDraw();
    }
    pass DrawHanrei < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        VertexShader = compile vs_2_0 VS_Hanrei();
        PixelShader  = compile ps_2_0 PS_Hanrei();
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////

// �n�ʉe�͕`�悵�Ȃ�
technique ShadowTec < string MMDPass = "shadow"; > { }
// Z�v���b�g�͕`�悵�Ȃ�
technique ZplotTec < string MMDPass = "zplot"; > { }

