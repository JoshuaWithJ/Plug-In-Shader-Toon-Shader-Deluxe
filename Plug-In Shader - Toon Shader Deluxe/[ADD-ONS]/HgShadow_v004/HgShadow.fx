////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HgShadow.fx ���i��(��������Ȃ�)�e�����G�t�F�N�g
//  �쐬: �j��P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

// HgShadow�̃p�����[�^����荞��
#include "HgShadow_Header.fxh"

#ifndef MIKUMIKUMOVING

float AcsSi : CONTROLOBJECT < string name = "(self)"; string item = "Si"; >;
float AcsTr : CONTROLOBJECT < string name = "(self)"; string item = "Tr"; >;
float AcsRy : CONTROLOBJECT < string name = "(self)"; string item = "Ry"; >;
static float Scale = AcsSi * 0.1f;
static float OcclLenParam = AcsTr;

#else
// MMM���̓p�����[�^�̎󂯓n���p

#if (ShadowMapType == CLSPSM)
shared float HgShadow_MMM_ShadowViewNear <
    string UIName = "Near�l";
    string UIHelp = "�V���h�E�}�b�v���Q�Ƃł���J����������̍ŋߒl";
    string UIWidget = "Numeric";
    bool UIVisible =  true;
    float UIMin = 1.0;
    float UIMax = 7000.0;
> = ShadowViewNear;
#endif

shared float HgShadow_MMM_ShadowViewFar <
    #if (ShadowMapType == CLSPSM)
    string UIName = "Far�l";
    string UIHelp = "�V���h�E�}�b�v���Q�Ƃł���J����������̍ŉ��l";
    #else
    string UIName = "�}�b�v�͈�";
    string UIHelp = "�V���h�E�}�b�v���Q�Ƃł���͈�";
    #endif
    string UIWidget = "Numeric";
    bool UIVisible =  true;
    float UIMin = 10.0;
    float UIMax = 9999.0;
> = ShadowViewFar;

shared float HgShadow_MMM_CascadedParam <
    string UIName = "CascadParam";
    string UIHelp = "CLSPSM�̃V���h�E�}�b�v���������p�����[�^";
    string UIWidget = "Slider";
    bool UIVisible =  true;
    float UIMin = -1.0;
    float UIMax = 1.0;
> = float( 0.0 );

#if (ShadowMapType == CLSPSM)
shared float HgShadow_MMM_PerspectiveParam <
    string UIName = "PersParam";
    string UIHelp = "CLSPSM�̃V���h�E�}�b�v�p�[�X�����p�����[�^";
    string UIWidget = "Slider";
    bool UIVisible =  true;
    float UIMin = -20.0;
    float UIMax = 20.0;
> = float( 0.0 );
#endif

shared float HgShadow_MMM_BlurPower <
    string UIName = "�e�ڂ���";
    string UIHelp = "�\\�t�g�V���h�E�̂ڂ����x";
    string UIWidget = "Slider";
    bool UIVisible =  true;
    float UIMin = 0.0;
    float UIMax = 5.0;
> = float( 1.0 );

shared float HgShadow_MMM_Density <
    string UIName = "�e�Z�x";
    string UIWidget = "Slider";
    bool UIVisible =  true;
    float UIMin = 0.0;
    float UIMax = 5.0;
> = float( 1.0 );

float MMM_OcclLengthParam <
    string UIName = "�Օ���������";
    string UIHelp = "�Օ������ɂ���Ăڂ����̋�����ς���x�����������Œ������܂�";
    string UIWidget = "Slider";
    bool UIVisible =  true;
    float UIMin = 0.0;
    float UIMax = 1.0;
> = float( 1.0 );

shared float HgShadow_MMM_NearDistParam <
    string UIName = "�ߖT�e����";
    string UIHelp = "�Օ��������ɒ[�ɒZ���e�̂������}���邽�߂̒����l\n�傫����������ƋߖT�e�������Ă��܂��܂�";
    string UIWidget = "Slider";
    bool UIVisible =  true;
    #if (ShadowMapType == CLSPSM)
    float UIMin = -1.0;
    #else
    float UIMin = 0.0;
    #endif
    float UIMax = 1.0;
> = float( 0.0 );

static float Scale = HgShadow_MMM_BlurPower;
static float OcclLenParam = MMM_OcclLengthParam;

#endif


////////////////////////////////////////////////////////////////////////////////////////////////

float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass = "scene";
    string ScriptOrder = "postprocess";
> = 0.8;

// �V���h�E�}�b�v�o�b�t�@�T�C�Y
#define SMAPSIZE_WIDTH   ShadowMapSize * 5.0
#define SMAPSIZE_HEIGHT  ShadowMapSize * 5.0

#define TEX_FORMAT_SMAP  "D3DFMT_R32F"
#define TEX_MIPLEVELS  1

#if BufferFmtQuality == 1
    #define TEX_FORMAT_VMAP  "D3DFMT_A32B32G32R32F"
    #define TEX_FORMAT_WMAP  "D3DFMT_G32R32F"
#else
    #define TEX_FORMAT_VMAP  "D3DFMT_A16B16G16R16F"
    #define TEX_FORMAT_WMAP  "D3DFMT_G16R16F"
#endif

#if BufferAntiAlias == 1
    #define TEX_AASET  true
#else
    #define TEX_AASET  false
#endif



#ifndef MIKUMIKUMOVING
// �I�t�X�N���[���e�����p��ʃf�[�^�}�b�v�쐬�o�b�t�@(MME�p)
texture HgS_VMap : OFFSCREENRENDERTARGET <
    string Description = "HgShadow.fx�̉e�����}�b�v�o�b�t�@";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 1 };
    float ClearDepth = 1.0;
    string Format = TEX_FORMAT_VMAP;
    bool AntiAlias = TEX_AASET;
    int Miplevels = TEX_MIPLEVELS;
    string DefaultEffect = 
        "self = hide;"
        "* = HgShadow_ViewportMap.fxsub;"
        ;
>;
#endif

// �I�t�X�N���[���V���h�E�}�b�v�o�b�t�@
shared texture HgS_SMap : OFFSCREENRENDERTARGET <
    string Description = "HgShadow.fx�̃V���h�E�}�b�v�o�b�t�@";
    int Width  = SMAPSIZE_WIDTH;
    int Height = SMAPSIZE_HEIGHT;
    float4 ClearColor = { 1, 1, 1, 1 };
    float ClearDepth = 1.0;
    string Format = TEX_FORMAT_SMAP;
    bool AntiAlias = false;
    int Miplevels = TEX_MIPLEVELS;
    string DefaultEffect = 
        "self = hide;"
        "* = HgShadow_ShadowMap.fxsub;"
        ;
>;

#ifdef MIKUMIKUMOVING
// �I�t�X�N���[���e�����p��ʃf�[�^�}�b�v�쐬�o�b�t�@(MMM�p)
texture HgS_VMap : OFFSCREENRENDERTARGET <
    string Description = "HgShadow.fx�̉�ʃ}�b�v�o�b�t�@";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 1 };
    float ClearDepth = 1.0;
    string Format = TEX_FORMAT_VMAP;
    bool AntiAlias = TEX_AASET;
    int Miplevels = TEX_MIPLEVELS;
    string DefaultEffect = 
        "self = hide;"
        "* = HgShadow_ViewportMap.fxsub;"
        ;
>;
#endif

sampler ViewportMapSamp = sampler_state {
    texture = <HgS_VMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};


// �����_�����O�^�[�Q�b�g�̃N���A�l
float4 ClearColor = {0,0,0,1};
float ClearDepth  = 1.0f;

// �V���h�E�`��ҏW�p�̃����_�[�^�[�Q�b�g
texture2D HgShadow_ViewportMap1 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 1;
    string Format = TEX_FORMAT_WMAP;
>;
sampler2D WorkMapSamp1 = sampler_state {
    texture = <HgShadow_ViewportMap1>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

// �V���h�E�`��ҏW�p�̃����_�[�^�[�Q�b�g2
shared texture2D HgShadow_ViewportMap2 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 1;
    string Format = TEX_FORMAT_WMAP;
>;
sampler2D WorkMapSamp2 = sampler_state {
    texture = <HgShadow_ViewportMap2>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

// �V���h�E�`��ɗp����[�x�X�e���V���o�b�t�@
texture2D HgShadow_DepthStencilBuffer : RENDERDEPTHSTENCILTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "D3DFMT_D24S8";
>;


// JitteredSampling�p�����e�N�X�`��
texture RandomTex <
    string ResourceName = "JitteredSamp.png";
    int MipLevels = 1;
>;
sampler RandomSmp = sampler_state {
    texture = <RandomTex>;
    MinFilter = POINT;
    MagFilter = POINT;
    MipFilter = NONE;
    AddressU  = WRAP;
    AddressV  = WRAP;
};


#ifndef MIKUMIKUMOVING
#if WithVolumeShadow==1

// �V���h�E�{�����[������p�����[�^
bool VolumeShadow_Valid  : CONTROLOBJECT < string name = "VolumeShadow.x"; >;
float VolumeShadow_Levels  : CONTROLOBJECT < string name = "VolumeShadow.x"; string item = "Tr"; >;

// �V���h�E�{�����[���̕`�挋�ʂ��L�^���邽�߂̃����_�[�^�[�Q�b�g
shared texture2D VolumeShadow_VolumeMap : RENDERCOLORTARGET;
sampler2D VolumeShadow_VolumeMapSamp = sampler_state {
    texture = <VolumeShadow_VolumeMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = LINEAR;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

#endif
#endif

#ifdef MIKUMIKUMOVING
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

// �s�N�Z���V�F�[�_
float4 PS_ScrDraw( float2 Tex: TEXCOORD0 ) : COLOR
{
    return tex2D( ScnSamp, Tex );
}
#endif


// �X�N���[���T�C�Y�E�T���v�����O��
float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset = float2(0.5,0.5) / ViewportSize;
static float2 SampStep = float2(1,1) / ViewportSize;
static float2 BlurSampStep = float2(1.0f/720.0f, ViewportSize.x/ViewportSize.y/720.0f);

static float2 SampStep2[9] = { float2(0.0f, 0.0f),
                               float2(-SampStep.x, 0.0f)*1.5f,
                               float2( SampStep.x, 0.0f)*1.5f,
                               float2( 0.0f,-SampStep.y)*1.5f,
                               float2( 0.0f, SampStep.y)*1.5f,
                               float2(-SampStep.x,-SampStep.y)*1.5f,
                               float2( SampStep.x, SampStep.y)*1.5f,
                               float2(-SampStep.x, SampStep.y)*1.5f,
                               float2( SampStep.x,-SampStep.y)*1.5f };


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
// ��Ɨp�̃r���[�|�[�g�}�b�v���쐬

float4 PS_ShadowDraw( float2 Tex: TEXCOORD0 ) : COLOR
{
    // �Օ����E�Օ�����
    float2 data = tex2D( ViewportMapSamp, Tex ).xy;

    // �{�����[���V���h�E�����p����ꍇ�͒ǉ�
    #ifndef MIKUMIKUMOVING
    #if WithVolumeShadow==1
    if(VolumeShadow_Valid){
        float comp = tex2Dlod( VolumeShadow_VolumeMapSamp, float4(Tex, 0, 1.0f-VolumeShadow_Levels) ).r;
        if( comp > data.x ){
            data = float2( comp, data.y+3.0f );
        }
    }
    #endif
    #endif

    return float4(data, 0, 1);
}


////////////////////////////////////////////////////////////////////////////////////////////////
// �ڂ����Ɏg���p�����[�^

float4x4 ProjMatrix : PROJECTION;
float DepthThreshold  = 0.5;    // �[�x��臒l
float NormalThreshold = 0.1;    // �@����臒l

// �ڂ����T���v�����O�͈͂̋��E����
bool IsSameArea(float2 edge0, float2 edge1)
{
    float edgeDepthThreshold = min(DepthThreshold + 0.05f * max(edge0.x-40.0f, 0.0f), 50.0f);
    return (abs(edge0.x - edge1.x) < edgeDepthThreshold && abs(edge0.y - edge1.y) < NormalThreshold);
}


#if SoftShadowQuality > 1

// �ڂ������x�̊�l
static float OcclBlurPower = InitBlurPower * Scale;
static float DistBlurPower = OcclBlurPower * ViewportMapSampCount * 0.3f;

// ���a1�~���̃����_�����W�𓾂�(Jittered Sampling)
float2 CalcRandomCoord(int index, int rCount, float seed)
{
    float4 rand = tex2D( RandomSmp, float2((index-0.5f)/64.0f, seed) );
    float x = ((rand.x * 256.0f + rand.y) * 255.0f) / 2048.0f - 16.0f;
    float y = ((rand.z * 256.0f + rand.w) * 255.0f) / 2048.0f - 16.0f;
    return (float2(x, y) / float(rCount));
}

////////////////////////////////////////////////////////////////////////////////////////////////
// �Օ������̂ڂ���

#if SoftShadowQuality == 3
float4 PS_BlurDistance( float2 Tex: TEXCOORD0, uniform sampler2D Samp, uniform float stepLength ) : COLOR
{
    float4 Color0 = tex2D( Samp, Tex );

    // data.x:�[�x, data.y:���C�g�Ɩ@���̂Ȃ��p
    float2 data = tex2D( ViewportMapSamp, Tex ).zw;

    // �ߖT�t�B���^�����O�Ŏ��ӂ𕽋ω�����
    float dist = Color0.y + Color0.y;
    float weight = 2.0f;
    int rCount = ceil(float(ViewportMapSampCount-1)/4.0f);
    float seed = 1234.5f*Tex.x + 1357.9f*Tex.y;
    #if ViewportMapSampCount < 17
    [unroll]
    #endif
    for(int i=1; i<ViewportMapSampCount; i++){
        // �T���v�����O�ʒu
        float2 texCoord = Tex + BlurSampStep * CalcRandomCoord(i, rCount, seed) * stepLength * DistBlurPower;
        // �[�x�Ɗp�x�����狫�E�𔻒�
        float2 edge0 = data;
        float2 edge1 = tex2D( ViewportMapSamp, texCoord ).zw;
        // ���E�̊O���̓T���v�����O���Ȃ�
        if( IsSameArea(edge0, edge1)){
            float dist1 = tex2D( Samp, texCoord ).y;
            //if(Color0.y <= dist1){
                dist += dist1;
                weight += 1.0f;
            //}
        }
    }
    dist /= weight;  // ���ω�

    return float4(Color0.x, dist, 0, 1);
}
#endif

////////////////////////////////////////////////////////////////////////////////////////////////
// �e�̂ڂ���

float4 PS_BlurShadow( float2 Tex: TEXCOORD0, uniform sampler2D Samp, uniform float stepLength ) : COLOR
{
    float4 Color0 = tex2D( Samp, Tex );

    // data.x:�[�x, data.y:���C�g�Ɩ@���̂Ȃ��p
    float2 data = tex2D( ViewportMapSamp, Tex ).zw;
    // �ڂ����̋���(�Օ�����,�[�x,���C�g�@���p�x,����p���l���ɓ���Ăڂ������������肷��)
    float OcclLen = min(lerp(3.0f, Color0.y+1.0f, OcclLenParam), Color0.y+1.0f);
    float BlurPower = OcclBlurPower * max(ProjMatrix._22 * OcclLen / (pow(data.x+1.0f, 0.75f) * (abs(data.y)+0.2f)), 1.0f);

    // �ߖT�t�B���^�����O�Ŏ��ӂ𕽋ω�����
    float comp = Color0.x + Color0.x;
    float weight = 2.0f;
    int rCount = ceil(float(ViewportMapSampCount-1)/4.0f);
    float seed = 1234.5f*Tex.x + 1357.9f*Tex.y;
    #if ViewportMapSampCount < 17
    [unroll]
    #endif
    for(int i=1; i<ViewportMapSampCount; i++){
        // �T���v�����O�ʒu
        float2 texCoord = Tex + BlurSampStep * CalcRandomCoord(i, rCount, seed) * stepLength * BlurPower;
        if( !any( saturate(texCoord) - texCoord ) ) {
            // �[�x�Ɗp�x�����狫�E�𔻒�
            float2 edge0 = data;
            float2 edge1 = tex2D( ViewportMapSamp, texCoord ).zw;
            // ���E�̊O���̓T���v�����O���Ȃ�
            if( IsSameArea(edge0, edge1)){
                comp += tex2D( Samp, texCoord ).x;
                weight += 1.0f;
            }
        }
    }
    comp /= weight;  // ���ω�

    return float4(comp, Color0.y, 0, 1);
}
#endif

////////////////////////////////////////////////////////////////////////////////////////////////
// �Ō��9�_�T���v�����O�łڂ����̂�����𐮂���

#if SoftShadowQuality > 0

#if SoftShadowQuality > 1
    #define  BLUR_OCCRATE  (Color0.y+1.0f)
    #define  BLUR_DEPRATE  pow(data.x+1.0f, 0.7f)
    #define  BLUR_RATE  1.0
#else
    #define  BLUR_OCCRATE  2.0f
    #define  BLUR_DEPRATE  (data.x+1.0f)
    #define  BLUR_RATE  (Scale * 2.0f)
#endif

float4 PS_BlurShadow2( float2 Tex: TEXCOORD0, uniform sampler2D Samp ) : COLOR
{
    float4 Color0 = tex2D( Samp, Tex );

    // data.x:�[�x, data.y:���C�g�Ɩ@���̂Ȃ��p
    float2 data = tex2D( ViewportMapSamp, Tex ).zw;
    // �ڂ����̋���(�Օ�����,�[�x,���C�g�@���p�x,����p���l���ɓ���Ăڂ������������肷��)
    float BlurPower = clamp(ProjMatrix._22 * BLUR_OCCRATE / (BLUR_DEPRATE * (abs(data.y)+0.2f)), 0.5f, 1.5f) * min(Scale, 1.0f);

    // 9�_�T���v�����O
    float comp = Color0.x;
    float weight = 1.0f;
    [unroll]
    for(int i=1; i<9; i++){
        // �[�x�Ɗp�x�����狫�E�𔻒�
        float2 edge0 = data;
        float2 edge1 = tex2D( ViewportMapSamp, Tex+SampStep2[i]*BlurPower*BLUR_RATE ).zw;
        // ���E�̊O���̓T���v�����O���Ȃ�
        if( IsSameArea(edge0, edge1)){
            comp += tex2D( Samp, Tex+SampStep2[i]*BlurPower*BLUR_RATE ).x;
            weight += 1.0f;
        }
    }
    comp /= weight;  // ���ω�

    return float4(comp, Color0.y, 0, 1);
}

#endif


////////////////////////////////////////////////////////////////////////////////////////////////
// �e�X�g�\��

//#define TestView

#ifdef TestView
float4 PS_TestView( float2 Tex: TEXCOORD0 ) : COLOR
{
    float4 Color = tex2D( WorkMapSamp2, Tex );
    //float4 Color = tex2D( ViewportMapSamp, Tex );
    Color.x = 1.0f - Color.x;
    return float4(Color.x,Color.x,Color.x,1);
}
#endif


////////////////////////////////////////////////////////////////////////////////////////////////
// �e�N�j�b�N

technique MainTech < string MMDPass = "object";
    string Script = 
        #if SoftShadowQuality > 0
        "RenderColorTarget0=HgShadow_ViewportMap1;"
        #else
        "RenderColorTarget0=HgShadow_ViewportMap2;"
        #endif
            "RenderDepthStencilTarget=HgShadow_DepthStencilBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "Pass=DrawShadow;"

        #if SoftShadowQuality > 1
        #if SoftShadowQuality == 3
        "RenderColorTarget0=HgShadow_ViewportMap2;"
            "RenderDepthStencilTarget=HgShadow_DepthStencilBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "Pass=BlurDistance1;"
        "RenderColorTarget0=HgShadow_ViewportMap1;"
            "RenderDepthStencilTarget=HgShadow_DepthStencilBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "Pass=BlurDistance2;"
        #endif

        "RenderColorTarget0=HgShadow_ViewportMap2;"
            "RenderDepthStencilTarget=HgShadow_DepthStencilBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "Pass=BlurShadow1;"
        "RenderColorTarget0=HgShadow_ViewportMap1;"
            "RenderDepthStencilTarget=HgShadow_DepthStencilBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "Pass=BlurShadow2;"
        #endif

        #if SoftShadowQuality > 0
        "RenderColorTarget0=HgShadow_ViewportMap2;"
            "RenderDepthStencilTarget=HgShadow_DepthStencilBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "Pass=BlurShadow3;"
        #endif

        #ifndef MIKUMIKUMOVING
        "RenderColorTarget0=;"
            "RenderDepthStencilTarget=;"
            "ScriptExternal=Color;"
        #else
        "RenderColorTarget0=ScnMap;"
            "RenderDepthStencilTarget=HgShadow_DepthStencilBuffer;"
            "ClearSetColor=ClearColor;"
            "ClearSetDepth=ClearDepth;"
            "Clear=Color;"
            "Clear=Depth;"
            "ScriptExternal=Color;"
        "RenderColorTarget0=;"
            "RenderDepthStencilTarget=;"
            "Pass=ScrDrawPass;"
        #endif

            #ifdef TestView
            "Pass=TestShadowView;"
            #endif

    ;
> {
    pass DrawShadow < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable = FALSE;
        VertexShader = compile vs_3_0 VS_Common();
        PixelShader  = compile ps_3_0 PS_ShadowDraw();
    }

    #if SoftShadowQuality > 1
    #if SoftShadowQuality == 3
    pass BlurDistance1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable = FALSE;
        VertexShader = compile vs_3_0 VS_Common();
        PixelShader  = compile ps_3_0 PS_BlurDistance(WorkMapSamp1, 1.0f);
    }
    pass BlurDistance2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable = FALSE;
        VertexShader = compile vs_3_0 VS_Common();
        PixelShader  = compile ps_3_0 PS_BlurDistance(WorkMapSamp2, 0.5f);
    }
    #endif
    pass BlurShadow1 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable = FALSE;
        VertexShader = compile vs_3_0 VS_Common();
        PixelShader  = compile ps_3_0 PS_BlurShadow(WorkMapSamp1, 1.0f);
    }

    pass BlurShadow2 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable = FALSE;
        VertexShader = compile vs_3_0 VS_Common();
        PixelShader  = compile ps_3_0 PS_BlurShadow(WorkMapSamp2, 0.2f);
    }
    #endif

    #if SoftShadowQuality > 0
    pass BlurShadow3 < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable = FALSE;
        VertexShader = compile vs_3_0 VS_Common();
        PixelShader  = compile ps_3_0 PS_BlurShadow2(WorkMapSamp1);
    }
    #endif

    #ifdef MIKUMIKUMOVING
    pass ScrDrawPass < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable  = FALSE;
        VertexShader = compile vs_2_0 VS_Common();
        PixelShader  = compile ps_2_0 PS_ScrDraw();
    }
    #endif

    #ifdef TestView
    pass TestShadowView < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VS_Common();
        PixelShader  = compile ps_2_0 PS_TestView();
    }
    #endif
}


////////////////////////////////////////////////////////////////////////////////////////////////

// �n�ʉe�͕`�悵�Ȃ�
technique ShadowTec < string MMDPass = "shadow"; > { }
// Z�v���b�g�͕`�悵�Ȃ�
technique ZplotTec < string MMDPass = "zplot"; > { }

