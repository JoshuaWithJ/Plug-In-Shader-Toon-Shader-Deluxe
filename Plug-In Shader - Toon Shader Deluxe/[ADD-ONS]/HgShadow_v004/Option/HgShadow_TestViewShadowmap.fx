////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HgShadow_TestAliasingError.fx : HgShadow.fx �̃V���h�E�}�b�v �̕\��
//  �쐬: �j��P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

float Script : STANDARDSGLOBAL <
    string ScriptOutput = "color";
    string ScriptClass = "sceneorobject";
    string ScriptOrder = "postprocess";
> = 0.8;

float AcsSi : CONTROLOBJECT < string name = "(self)"; string item = "Si"; >;
float AcsTr : CONTROLOBJECT < string name = "(self)"; string item = "Tr"; >;

// �X�N���[���T�C�Y
float2 ViewportSize : VIEWPORTPIXELSIZE;
static float2 ViewportOffset = float2(0.5,0.5) / ViewportSize;

// HgShadow�ɂ��CLSPSM�V���h�E�}�b�v�o�b�t�@
shared texture HgS_SMap : OFFSCREENRENDERTARGET;
sampler HgShadow_ShadowMapSamp = sampler_state {
    texture = <HgS_SMap>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

struct VS_OUTPUT {
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

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

// ���_�V�F�[�_
VS_OUTPUT VS_ScrDraw(float4 Pos : POSITION, float2 Tex: TEXCOORD)
{
    VS_OUTPUT Out = (VS_OUTPUT)0; 
    Out.Pos = Pos;
    Out.Tex = Tex + ViewportOffset;
    return Out;
}

// �s�N�Z���V�F�[�_
float4 PS_ScrDraw( float2 Tex: TEXCOORD0 ) : COLOR
{
    return tex2D( ScnSamp, Tex );
}
#endif


////////////////////////////////////////////////////////////////////////////////////////////////
// �V���h�E�}�b�v�`��

#define ScrSizeRate  (40.0 / AcsSi)

// ���_�V�F�[�_
VS_OUTPUT VS_Draw( float4 Pos : POSITION, float2 Tex : TEXCOORD0 )
{
    VS_OUTPUT Out = (VS_OUTPUT)0;
    Pos.xy *= float2( 1.0f/ScrSizeRate, ViewportSize.x/ViewportSize.y/ScrSizeRate);
    Out.Pos = Pos + float4( (ScrSizeRate-1)/ScrSizeRate, 1.0f-ViewportSize.x/ViewportSize.y/ScrSizeRate, 0, 0);
    Out.Tex = Tex;
    return Out;
}

// �s�N�Z���V�F�[�_
float4 PS_Draw( float2 Tex: TEXCOORD0 ) : COLOR
{
    float dep = tex2D( HgShadow_ShadowMapSamp, Tex ).r;
    dep = (dep - 0.5f)*10000.0f/500 + 0.5f;
    return float4( dep, 0, 0, AcsTr);
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
            "Pass=DrawSMap;"
    ;
> {
    #ifdef MIKUMIKUMOVING
    pass ScrDrawPass < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = FALSE;
        AlphaTestEnable  = FALSE;
        VertexShader = compile vs_2_0 VS_ScrDraw();
        PixelShader  = compile ps_2_0 PS_ScrDraw();
    }
    #endif
    pass DrawSMap < string Script= "Draw=Buffer;"; > {
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VS_Draw();
        PixelShader  = compile ps_2_0 PS_Draw();
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////

// �n�ʉe�͕`�悵�Ȃ�
technique ShadowTec < string MMDPass = "shadow"; > { }
// Z�v���b�g�͕`�悵�Ȃ�
technique ZplotTec < string MMDPass = "zplot"; > { }

