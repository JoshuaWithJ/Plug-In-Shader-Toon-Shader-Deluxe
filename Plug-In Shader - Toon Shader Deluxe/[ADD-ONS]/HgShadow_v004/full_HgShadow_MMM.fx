////////////////////////////////////////////////////////////////////////////////////////////////
//
//  MikuMikuMoving�p�T���v���V�F�[�_
//  2013/05/01
//  HgShadow�Ŏg�p�o����悤�ɉ��� by �j��P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

//////////////////// HgShadow�ł����ǉ����܂� ///////////////////////
// ��������������������������������������������������������������������

// HgShadow�̕K�v�ȃp�����[�^����荞��
#include "HgShadow_ObjHeader.fxh"

// ��������������������������������������������������������������������
///////////////////////////////////////////////////////////////////////

//���W�ϊ��s��
float4x4 WorldViewProjMatrix : WORLDVIEWPROJECTION;
float4x4 ViewProjMatrix      : VIEWPROJECTION;
float4x4 WorldMatrix         : WORLD;
float4x4 ViewMatrix          : VIEW;
float4x4 ProjMatrix          : PROJECTION;

//���C�g�֘A
bool     LightEnables[MMM_LightCount]      : LIGHTENABLES;      // �L���t���O
float4x4 LightWVPMatrices[MMM_LightCount]  : LIGHTWVPMATRICES;  // ���W�ϊ��s��
float3   LightDirection[MMM_LightCount]    : LIGHTDIRECTIONS;   // ����
float3   LightPositions[MMM_LightCount]    : LIGHTPOSITIONS;    // ���C�g�ʒu
float    LightZFars[MMM_LightCount]        : LIGHTZFARS;        // ���C�gzFar�l

//�ގ����[�t�֘A
float4 AddingTexture    : ADDINGTEXTURE;       // �ގ����[�t���ZTexture�l
float4 AddingSphere     : ADDINGSPHERE;        // �ގ����[�t���ZSphereTexture�l
float4 MultiplyTexture  : MULTIPLYINGTEXTURE;  // �ގ����[�t��ZTexture�l
float4 MultiplySphere   : MULTIPLYINGSPHERE;   // �ގ����[�t��ZSphereTexture�l

//�J�����ʒu
float3 CameraPosition  : POSITION  < string Object = "Camera"; >;

// �}�e���A���F
float4 MaterialDiffuse    : DIFFUSE  < string Object = "Geometry"; >;
float3 MaterialAmbient    : AMBIENT  < string Object = "Geometry"; >;
float3 MaterialEmmisive   : EMISSIVE < string Object = "Geometry"; >;
float3 MaterialSpecular   : SPECULAR < string Object = "Geometry"; >;
float  SpecularPower      : SPECULARPOWER < string Object = "Geometry"; >;
float4 MaterialToon       : TOONCOLOR;
float4 EdgeColor          : EDGECOLOR;
float  EdgeWidth          : EDGEWIDTH;
float4 GroundShadowColor  : GROUNDSHADOWCOLOR;

bool spadd;                // �X�t�B�A�}�b�v���Z�����t���O
bool usetoontexturemap;    // Toon�e�N�X�`���t���O

// ���C�g�F
float3 LightDiffuses[MMM_LightCount]   : LIGHTDIFFUSECOLORS;
float3 LightAmbients[MMM_LightCount]   : LIGHTAMBIENTCOLORS;
float3 LightSpeculars[MMM_LightCount]  : LIGHTSPECULARCOLORS;

// ���C�g�F
static float4 DiffuseColor[3]  = { MaterialDiffuse * float4(LightDiffuses[0], 1.0f),
                                   MaterialDiffuse * float4(LightDiffuses[1], 1.0f),
                                   MaterialDiffuse * float4(LightDiffuses[2], 1.0f) };
static float3 AmbientColor[3]  = { saturate(MaterialAmbient * LightAmbients[0]) + MaterialEmmisive,
                                   saturate(MaterialAmbient * LightAmbients[1]) + MaterialEmmisive,
                                   saturate(MaterialAmbient * LightAmbients[2]) + MaterialEmmisive };
static float3 SpecularColor[3] = { MaterialSpecular * LightSpeculars[0],
                                   MaterialSpecular * LightSpeculars[1],
                                   MaterialSpecular * LightSpeculars[2] };

// �I�u�W�F�N�g�̃e�N�X�`��
texture ObjectTexture: MATERIALTEXTURE;
sampler ObjTexSampler = sampler_state {
    texture = <ObjectTexture>;
    MINFILTER = ANISOTROPIC;
    MAGFILTER = ANISOTROPIC;
    MIPFILTER = LINEAR;
    MAXANISOTROPY = 16;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
};

// �X�t�B�A�}�b�v�̃e�N�X�`��
texture ObjectSphereMap: MATERIALSPHEREMAP;
sampler ObjSphareSampler = sampler_state {
    texture = <ObjectSphereMap>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

///////////////////////////////////////////////////////////////////////////////////////////////
// �I�u�W�F�N�g�`��
struct VS_OUTPUT {
    float4 Pos     : POSITION;     // �ˉe�ϊ����W
    float2 Tex     : TEXCOORD0;    // �e�N�X�`��
    float4 SubTex  : TEXCOORD1;    // �T�u�e�N�X�`��/�X�t�B�A�}�b�v�e�N�X�`�����W
    float3 Normal  : TEXCOORD2;    // �@��
    float3 Eye     : TEXCOORD3;    // �J�����Ƃ̑��Έʒu
    float4 SS_UV1  : TEXCOORD4;    // �Z���t�V���h�E�e�N�X�`�����W
    float4 SS_UV2  : TEXCOORD5;    // �Z���t�V���h�E�e�N�X�`�����W
    float4 SS_UV3  : TEXCOORD6;    // �Z���t�V���h�E�e�N�X�`�����W

    //////////////////// HgShadow�ł͂����ǉ����܂� /////////////////////
    // ��������������������������������������������������������������������
    float4 PPos     : TEXCOORD7;    // �ˉe���W
    // ��������������������������������������������������������������������
    ///////////////////////////////////////////////////////////////////////

    float4 Color   : COLOR0;       // ���C�g0�ɂ��F
};

//==============================================
// ���_�V�F�[�_
// MikuMikuMoving�Ǝ��̒��_�V�F�[�_����(MMM_SKINNING_INPUT)
//==============================================
VS_OUTPUT Basic_VS(MMM_SKINNING_INPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon, uniform bool useSelfShadow)
{
    VS_OUTPUT Out = (VS_OUTPUT)0;

    //================================================================================
    //MikuMikuMoving�Ǝ��̃X�L�j���O�֐�(MMM_SkinnedPositionNormal)�B���W�Ɩ@�����擾����B
    //================================================================================
    MMM_SKINNING_OUTPUT SkinOut = MMM_SkinnedPositionNormal(IN.Pos, IN.Normal, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);

    // �J�����Ƃ̑��Έʒu
    Out.Eye = CameraPosition - mul( SkinOut.Position, WorldMatrix ).xyz;
    // ���_�@��
    Out.Normal = normalize( mul( SkinOut.Normal, (float3x3)WorldMatrix ) );

    // ���_���W
    if (MMM_IsDinamicProjection)
    {
        float4x4 wvpmat = mul(mul(WorldMatrix, ViewMatrix), MMM_DynamicFov(ProjMatrix, length(Out.Eye)));
        Out.Pos = mul( SkinOut.Position, wvpmat );
    }
    else
    {
        Out.Pos = mul( SkinOut.Position, WorldViewProjMatrix );
    }

    //////////////////// HgShadow�ł͂����ǉ����܂� /////////////////////
    // ��������������������������������������������������������������������
    Out.PPos = Out.Pos;
    // ��������������������������������������������������������������������
    ///////////////////////////////////////////////////////////////////////

    // �f�B�t���[�Y�F�{�A���r�G���g�F �v�Z
    float3 color = float3(0, 0, 0);
    float3 ambient = float3(0, 0, 0);
    float count = 0;
    for (int i = 0; i < 3; i++) {
        if (LightEnables[i]) {
            color += (float3(1,1,1) - color) * (max(0, DiffuseColor[i].rgb * dot(Out.Normal, -LightDirection[i])));
            ambient += AmbientColor[i];
            count = count + 1.0;
        }
    }
    Out.Color.rgb = saturate(ambient / count + color);
    Out.Color.a = MaterialDiffuse.a;

    // �e�N�X�`�����W
    Out.Tex = IN.Tex;
    Out.SubTex.xy = IN.AddUV1.xy;

    if ( useSphereMap ) {
        // �X�t�B�A�}�b�v�e�N�X�`�����W
        float2 NormalWV = mul( Out.Normal, (float3x3)ViewMatrix ).xy;
        Out.SubTex.z = NormalWV.x * 0.5f + 0.5f;
        Out.SubTex.w = NormalWV.y * -0.5f + 0.5f;
    }

    if (useSelfShadow) {
        float4 dpos = mul(SkinOut.Position, WorldMatrix);
        //�f�v�X�}�b�v�e�N�X�`�����W
        Out.SS_UV1 = mul(dpos, LightWVPMatrices[0]);
        Out.SS_UV2 = mul(dpos, LightWVPMatrices[1]);
        Out.SS_UV3 = mul(dpos, LightWVPMatrices[2]);

        Out.SS_UV1.y = -Out.SS_UV1.y;
        Out.SS_UV2.y = -Out.SS_UV2.y;
        Out.SS_UV3.y = -Out.SS_UV3.y;

        Out.SS_UV1.z = (length(LightPositions[0] - SkinOut.Position.xyz) / LightZFars[0]);
        Out.SS_UV2.z = (length(LightPositions[1] - SkinOut.Position.xyz) / LightZFars[1]);
        Out.SS_UV3.z = (length(LightPositions[2] - SkinOut.Position.xyz) / LightZFars[2]);
    }

    return Out;
}

//==============================================
// �s�N�Z���V�F�[�_
// ���͓͂��ɓƎ��`���Ȃ�
//==============================================
float4 Basic_PS(VS_OUTPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon, uniform bool useSelfShadow) : COLOR0
{
    float4 Color = IN.Color;
    float4 texColor = float4(1,1,1,1);
    float  texAlpha = MultiplyTexture.a + AddingTexture.a;

    //�X�y�L�����F�v�Z
    float3 HalfVector;
    float3 Specular = 0;
    for (int i = 0; i < 3; i++) {
        if (LightEnables[i]) {
            HalfVector = normalize( normalize(IN.Eye) + -LightDirection[i] );
            Specular += pow( max(0,dot( HalfVector, normalize(IN.Normal) )), SpecularPower ) * SpecularColor[i];
        }
    }

    // �e�N�X�`���K�p
    if (useTexture) {
        texColor = tex2D(ObjTexSampler, IN.Tex);
        texColor.rgb = (texColor.rgb * MultiplyTexture.rgb + AddingTexture.rgb) * texAlpha + (1.0 - texAlpha);
    }
    Color.rgb *= texColor.rgb;

    // �X�t�B�A�}�b�v�K�p
    if ( useSphereMap ) {
        // �X�t�B�A�}�b�v�K�p
        if(spadd) Color.rgb = Color.rgb + (tex2D(ObjSphareSampler,IN.SubTex.zw).rgb * MultiplySphere.rgb + AddingSphere.rgb);
        else      Color.rgb = Color.rgb * (tex2D(ObjSphareSampler,IN.SubTex.zw).rgb * MultiplySphere.rgb + AddingSphere.rgb);
    }
    // �A���t�@�K�p
    Color.a = IN.Color.a * texColor.a;

    // �Z���t�V���h�E�Ȃ��̃g�D�[���K�p
    float3 color;
    if (!useSelfShadow && useToon && usetoontexturemap ) {
        //================================================================================
        // MikuMikuMoving�f�t�H���g�̃g�D�[���F���擾����(MMM_GetToonColor)
        //================================================================================
        color = MMM_GetToonColor(MaterialToon, IN.Normal, LightDirection[0], LightDirection[1], LightDirection[2]);
        Color.rgb *= color;
    }

    // �Z���t�V���h�E
    if (useSelfShadow) {

        ////////////////////// HgShadow�ɑΉ�����ɂ͂����ǉ����܂� ///////////////////////
        // ����������������������������������������������������������������������������������

        if(HgShadow_Valid && LightEnables[0]){

            float3 light23Shadow;  // �Ɩ�2,�Ɩ�3�̉e�F
            if (useToon && usetoontexturemap) {
                //================================================================================
                // MikuMikuMoving�f�t�H���g�̃Z���t�V���h�E�F���擾����(MMM_GetSelfShadowToonColor)
                //================================================================================
                float3 shadow = MMM_GetToonColor(MaterialToon, IN.Normal, -IN.Normal, LightDirection[1], LightDirection[2]);
                color = MMM_GetSelfShadowToonColor(MaterialToon, IN.Normal, float4(0,0,0,1), IN.SS_UV2, IN.SS_UV3, false, useToon);
                light23Shadow = min(shadow, color);
            }
            else {
                light23Shadow = MMM_GetSelfShadowToonColor(MaterialToon, IN.Normal, float4(0,0,0,1), IN.SS_UV2, IN.SS_UV3, false, useToon);
            }

            float4 ShadowColor = float4(saturate(AmbientColor[0]), Color.a);  // �e�̐F
            // �e�N�X�`���K�p
            if (useTexture) {
                ShadowColor.rgb *= texColor.rgb;
            }
            // �X�t�B�A�}�b�v�K�p
            if ( useSphereMap ) {
                // �X�t�B�A�}�b�v�K�p
                if(spadd) ShadowColor.rgb += (tex2D(ObjSphareSampler,IN.SubTex.zw).rgb * MultiplySphere.rgb + AddingSphere.rgb);
                else      ShadowColor.rgb *= (tex2D(ObjSphareSampler,IN.SubTex.zw).rgb * MultiplySphere.rgb + AddingSphere.rgb);
            }

            // �e�攻��
            float comp = HgShadow_GetSelfShadowRate(IN.PPos);

            // PMD�EPMX�̃g�D�[���K�p
            float LightNormal = dot(normalize(IN.Normal), -LightDirection[0]);
            if ( useToon && usetoontexturemap ) {
                comp = min(saturate(LightNormal*3.0f), comp);
                ShadowColor.rgb *= MaterialToon.rgb;
            }

            // �e�F�ɔZ�x����������
            HgShadow_COLOR Out = HgShadow_GetShadowDensity(Color, ShadowColor, useToon, LightNormal);

            // �Ɩ�2,�Ɩ�3�̍���
            Out.Color.rgb *= light23Shadow;

            // �X�y�L�����K�p
            Out.Color.rgb += Specular;

            // �e�F�̍���
            float4 ans = lerp(Out.ShadowColor, Out.Color, comp);
            return ans;
        }

        // ����������������������������������������������������������������������������������
        /////////////////////////////////////////////////////////////////////////////////////

        if (useToon && usetoontexturemap) {
            //================================================================================
            // MikuMikuMoving�f�t�H���g�̃Z���t�V���h�E�F���擾����(MMM_GetSelfShadowToonColor)
            //================================================================================
            float3 shadow = MMM_GetToonColor(MaterialToon, IN.Normal, LightDirection[0], LightDirection[1], LightDirection[2]);
            color = MMM_GetSelfShadowToonColor(MaterialToon, IN.Normal, IN.SS_UV1, IN.SS_UV2, IN.SS_UV3, false, useToon);

            Color.rgb *= min(shadow, color);
        }
        else {
            Color.rgb *= MMM_GetSelfShadowToonColor(MaterialToon, IN.Normal, IN.SS_UV1, IN.SS_UV2, IN.SS_UV3, false, useToon);
        }
    }

    // �X�y�L�����K�p
    Color.rgb += Specular;

    return Color;
}

//==============================================
// �I�u�W�F�N�g�`��e�N�j�b�N
// UseSelfShadow���Ǝ��ɒǉ�����Ă��܂��B
//==============================================
technique MainTec0 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = false; bool UseToon = false; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, false, false, false);
        PixelShader  = compile ps_3_0 Basic_PS(false, false, false, false);
    }
}

technique MainTec1 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = false; bool UseToon = false; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, false, false, false);
        PixelShader  = compile ps_3_0 Basic_PS(true, false, false, false);
    }
}

technique MainTec2 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = true; bool UseToon = false; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, true, false, false);
        PixelShader  = compile ps_3_0 Basic_PS(false, true, false, false);
    }
}

technique MainTec3 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = true; bool UseToon = false; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, true, false, false);
        PixelShader  = compile ps_3_0 Basic_PS(true, true, false, false);
    }
}

technique MainTec4 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = false; bool UseToon = true; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, false, true, false);
        PixelShader  = compile ps_3_0 Basic_PS(false, false, true, false);
    }
}

technique MainTec5 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = false; bool UseToon = true; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, false, true, false);
        PixelShader  = compile ps_3_0 Basic_PS(true, false, true, false);
    }
}

technique MainTec6 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = true; bool UseToon = true; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, true, true, false);
        PixelShader  = compile ps_3_0 Basic_PS(false, true, true, false);
    }
}

technique MainTec7 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = true; bool UseToon = true; bool UseSelfShadow = false; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, true, true, false);
        PixelShader  = compile ps_3_0 Basic_PS(true, true, true, false);
    }
}
technique MainTec8 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = false; bool UseToon = false; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, false, false, true);
        PixelShader  = compile ps_3_0 Basic_PS(false, false, false, true);
    }
}

technique MainTec9 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = false; bool UseToon = false; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, false, false, true);
        PixelShader  = compile ps_3_0 Basic_PS(true, false, false, true);
    }
}

technique MainTec10 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = true; bool UseToon = false; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, true, false, true);
        PixelShader  = compile ps_3_0 Basic_PS(false, true, false, true);
    }
}

technique MainTec11 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = true; bool UseToon = false; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, true, false, true);
        PixelShader  = compile ps_3_0 Basic_PS(true, true, false, true);
    }
}

technique MainTec12 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = false; bool UseToon = true; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, false, true, true);
        PixelShader  = compile ps_3_0 Basic_PS(false, false, true, true);
    }
}

technique MainTec13 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = false; bool UseToon = true; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, false, true, true);
        PixelShader  = compile ps_3_0 Basic_PS(true, false, true, true);
    }
}

technique MainTec14 < string MMDPass = "object"; bool UseTexture = false; bool UseSphereMap = true; bool UseToon = true; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(false, true, true, true);
        PixelShader  = compile ps_3_0 Basic_PS(false, true, true, true);
    }
}

technique MainTec15 < string MMDPass = "object"; bool UseTexture = true; bool UseSphereMap = true; bool UseToon = true; bool UseSelfShadow = true; > {
    pass DrawObject {
        VertexShader = compile vs_3_0 Basic_VS(true, true, true, true);
        PixelShader  = compile ps_3_0 Basic_PS(true, true, true, true);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////
// �֊s�`��

//==============================================
// ���_�V�F�[�_
//==============================================
float4 Edge_VS(MMM_SKINNING_INPUT IN) : POSITION 
{
    //================================================================================
    //MikuMikuMoving�Ǝ��̃X�L�j���O�֐�(MMM_SkinnedPosition)�B���W���擾����B
    //================================================================================
    MMM_SKINNING_OUTPUT SkinOut = MMM_SkinnedPositionNormal(IN.Pos, IN.Normal, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);

    // ���[���h���W
    float4 Pos = mul(SkinOut.Position, WorldMatrix);

    // �@������
    float3 Normal = normalize( mul( SkinOut.Normal, (float3x3)WorldMatrix ) );

    // ���_���W
    if (MMM_IsDinamicProjection)
    {
        float dist = length(CameraPosition - Pos.xyz);
        float4x4 vpmat = mul(ViewMatrix, MMM_DynamicFov(ProjMatrix, dist));

        Pos += float4(Normal, 0) * IN.EdgeWeight * EdgeWidth * distance(Pos.xyz, CameraPosition) * MMM_GetDynamicFovEdgeRate(dist);
        return mul( Pos, vpmat );
    }
    else
    {
        Pos += float4(Normal, 0) * IN.EdgeWeight * EdgeWidth * distance(Pos.xyz, CameraPosition);
        return mul( Pos, ViewProjMatrix );
    }
}

//==============================================
// �s�N�Z���V�F�[�_
//==============================================
float4 Edge_PS() : COLOR
{
    // �֊s�F�œh��Ԃ�
    return EdgeColor;
}

//==============================================
// �֊s�`��e�N�j�b�N
//==============================================
technique EdgeTec < string MMDPass = "edge"; > {
    pass DrawEdge {
        VertexShader = compile vs_2_0 Edge_VS();
        PixelShader  = compile ps_2_0 Edge_PS();
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////
// �e�i��Z���t�V���h�E�j�`��

//==============================================
// ���_�V�F�[�_
//==============================================
float4 Shadow_VS(MMM_SKINNING_INPUT IN) : POSITION
{
    //================================================================================
    //MikuMikuMoving�Ǝ��̃X�L�j���O�֐�(MMM_SkinnedPosition)�B���W���擾����B
    //================================================================================
    float4 Pos = MMM_SkinnedPosition(IN.Pos, IN.BlendWeight, IN.BlendIndices, IN.SdefC, IN.SdefR0, IN.SdefR1);

    // �J�������_�̃��[���h�r���[�ˉe�ϊ�
    return mul( Pos, WorldViewProjMatrix );
}

//==============================================
// �s�N�Z���V�F�[�_
//==============================================
float4 Shadow_PS() : COLOR
{
    return GroundShadowColor;
}

//==============================================
// �n�ʉe�`��e�N�j�b�N
//==============================================
technique ShadowTec < string MMDPass = "shadow"; > {
    pass DrawShadow {
        VertexShader = compile vs_2_0 Shadow_VS();
        PixelShader  = compile ps_2_0 Shadow_PS();
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
