////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HgShadow_CFSUSM.fxh : HgShadow �V���h�E�}�b�v��{�v�Z
//  ������ԌŒ萳���V���h�E�}�b�v CFSUSM(Cascaded Fixation Space Uniform Shadow Maps)�̍쐬
//  �쐬: �j��P
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

// �V���h�E�}�b�v�o�b�t�@�T�C�Y
#define SMAPSIZE_WIDTH   ShadowMapSize
#define SMAPSIZE_HEIGHT  ShadowMapSize

// �V���h�E�}�b�v�̕�����(�ύX�s��)
#define HgShadow_MapCount  4

// �������E�̗]���e�N�Z����
#define HgShadow_SCParam  4

// ���C�g����(���K���ς�)
float3 HgShadow_LightDirection  : DIRECTION < string Object = "Light"; >;

#ifdef HGSHADOW_TEST
    #define CTRLFILENAME  "HgShadow.x"
#else
    #define CTRLFILENAME  "(OffscreenOwner)"
#endif

// �V���h�E�}�b�v�̒��S���W
float3 HgShadow_Org : CONTROLOBJECT < string Name = CTRLFILENAME; >;
static float3 HgShadow_SMapOrg = HgShadow_Org + float3(0.0f, 12.0f, 0.0f);


#ifndef MIKUMIKUMOVING

// �R���g���[���p�����[�^(MME)
float HgShadow_FarZ  : CONTROLOBJECT < string name = CTRLFILENAME; string item = "Rz"; >;   // �}�b�v�͈͒����l
float HgShadow_CSMParam  : CONTROLOBJECT < string name = CTRLFILENAME; string item = "Ry"; >; // CSM�������p�����[�^

static float HgShadow_NearAll = ShadowViewNear;
static float HgShadow_FarAll  = max(ShadowViewFar + degrees(HgShadow_FarZ), HgShadow_NearAll+1.0f);
static float HgShadow_Lamda   = clamp(0.97f - 0.97f*degrees(HgShadow_CSMParam), 0.0f, 1.0f);
static float HgShadow_Lamda2  = 1.0f + saturate(-degrees(HgShadow_CSMParam));

#else

// �R���g���[���p�����[�^(MMM)
shared float HgShadow_MMM_ShadowViewFar;
shared float HgShadow_MMM_CascadedParam;
static float HgShadow_NearAll = ShadowViewNear;
static float HgShadow_FarAll  = HgShadow_MMM_ShadowViewFar;
static float HgShadow_Lamda   = clamp(0.97f - 0.97f*HgShadow_MMM_CascadedParam, 0.0f, 1.0f);
static float HgShadow_Lamda2  = 1.0f + saturate(-HgShadow_MMM_CascadedParam);

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �r���[�ϊ��s��̍쐬(LookPos:���_�ʒu, LookDir:���_����, LookUpDir:���_�����)

float4x4 HgShadow_CreateViewMatrix(float3 LookPos, float3 LookDir, float3 LookUpDir)
{
   // z�������x�N�g��
   float3 viewZ = LookDir;

   // x�������x�N�g��
   float3 viewX = cross( LookUpDir, LookDir ); 

   // x�������x�N�g���̐��K��(LookDir��LookUpDir�̕�������v����ꍇ�͓��ْl�ƂȂ�)
   if( !any(viewX) ) viewX = float3(1.0f, 0.0f, 0.0f);
   viewX = normalize(viewX);

   // y�������x�N�g��
   float3 viewY = cross( viewZ, viewX );  // ���ɐ����Ȃ̂ł���Ő��K��

   // �r���[���W�ϊ��̉�]�s��
   float3x3 viewRot = float3x3( viewX.x, viewY.x, viewZ.x,
                                viewX.y, viewY.y, viewZ.y,
                                viewX.z, viewY.z, viewZ.z );

   // �r���[�ϊ��s��
   return float4x4( viewRot[0],  0.0f,
                    viewRot[1],  0.0f,
                    viewRot[2],  0.0f,
                   -mul( LookPos, viewRot ), 1.0f );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CFSUSM�ɂ�郉�C�g�����̃r���[�ˉe�ϊ�

float4 HgShadow_CFSUSM_GetLightProjPosition(float4 WPos, int mapIndex)
{
    // ���C�g�����̃r���[�ϊ��s��
    float4x4 LtViewMat = HgShadow_CreateViewMatrix(HgShadow_SMapOrg, HgShadow_LightDirection, float3(0.0f, 1.0f, 0.0f));

    // ���������}�b�v�͈̔�(�}�b�v���S����̋����ɉ�����CSM�@�Ɠ�������)
    float nearAll = HgShadow_NearAll;
    float farAll  = HgShadow_FarAll;
    float lamda   = HgShadow_Lamda;
    float lamda2  = HgShadow_Lamda2;
    float ixf = pow(float(mapIndex+1)/float(HgShadow_MapCount), lamda2);
    float MapLen  = lamda * nearAll * pow(farAll/nearAll, ixf)
                  + (1.0f-lamda) * (nearAll + (float(mapIndex+1)/float(HgShadow_MapCount)) * (farAll-nearAll));

    // �}�b�v�������E�̃��j�A��ǂ܂Ȃ��悤�ɂ��邽�߂̏k���W��
    float2 sc = float2( (0.5f*SMAPSIZE_WIDTH - HgShadow_SCParam) / (0.5f*SMAPSIZE_WIDTH),
                        (0.5f*SMAPSIZE_HEIGHT - HgShadow_SCParam) / (0.5f*SMAPSIZE_HEIGHT) );

    // ���C�g�����̎ˉe�ϊ��s��
    float4x4 LtProjMat = float4x4( sc.x/MapLen, 0,           0,       0,
                                   0,           sc.y/MapLen, 0,       0,
                                   0,           0,           0.0001f, 0,
                                   0,           0,           0.5f,    1 );

    // ���C�g�����̎ˉe�ϊ����W
    float4 PPos = mul( WPos, mul(LtViewMat, LtProjMat) );

    return PPos;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �����̃}�b�v���琸�x�̗ǂ����2�}�b�v�̃e�N�X�`�����W�Ɛ[�x��I�яo��

struct HgShadow_SMapDat {
    float4 Tex1;   // 1�Ԑ��x���悢ZCalcTex(xy:�}�b�v���W, z:ZPlot, w:�}�b�v�ԍ�)
    float4 Tex2;   // 2�Ԗڂɐ��x���悢ZCalcTex(xy:�}�b�v���W, z:ZPlot, w:�}�b�v�ԍ�)
    float Weight;  // Tex1����߂�E�G�C�g
};

HgShadow_SMapDat HgShadow_CFSUSM_GetTexCoord(float4 ZCalcTex0, float4 ZCalcTex1, float4 ZCalcTex2, float4 ZCalcTex3, float4 MMD_ZCalcTex)
{
    HgShadow_SMapDat Out;
    Out.Tex1 = float4(-10.0f, -10.0f, 1.0f, 999.0f);
    Out.Tex2 = float4(-10.0f, -10.0f, 1.0f, 999.0f);
    Out.Weight = 0.0f;

    // �k���������̕␳�l
    float2 sc = float2( (0.5f*SMAPSIZE_WIDTH) / (0.5f*SMAPSIZE_WIDTH - HgShadow_SCParam),
                        (0.5f*SMAPSIZE_HEIGHT) / (0.5f*SMAPSIZE_HEIGHT - HgShadow_SCParam) );

    // �e�N�X�`�����W�ɕϊ�
    ZCalcTex0.xy /= ZCalcTex0.w;
    ZCalcTex1.xy /= ZCalcTex1.w;
    ZCalcTex2.xy /= ZCalcTex2.w;
    ZCalcTex3.xy /= ZCalcTex3.w;
    MMD_ZCalcTex /= MMD_ZCalcTex.w;
    float4 TransTexCoord;
    float2 TransTexCoord0;
    float2 TransTexCoord1;
    float2 TransTexCoord2;
    float2 TransTexCoord3;
    float2 TransTexCoord4;
    TransTexCoord0.x = (1.0f + sc.x*ZCalcTex0.x)*0.5f;
    TransTexCoord0.y = (1.0f - sc.y*ZCalcTex0.y)*0.5f;
    TransTexCoord1.x = (1.0f + sc.x*ZCalcTex1.x)*0.5f;
    TransTexCoord1.y = (1.0f - sc.y*ZCalcTex1.y)*0.5f;
    TransTexCoord2.x = (1.0f + sc.x*ZCalcTex2.x)*0.5f;
    TransTexCoord2.y = (1.0f - sc.y*ZCalcTex2.y)*0.5f;
    TransTexCoord3.x = (1.0f + sc.x*ZCalcTex3.x)*0.5f;
    TransTexCoord3.y = (1.0f - sc.y*ZCalcTex3.y)*0.5f;
    TransTexCoord4.x = (1.0f + MMD_ZCalcTex.x)*0.5f;
    TransTexCoord4.y = (1.0f - MMD_ZCalcTex.y)*0.5f;

    // ���i���ߌi�̏��Ƀ}�b�v���ɂ��邩���ׂď����o��(w�͎g����}�b�v�ԍ�)
    #ifndef MIKUMIKUMOVING
    #if UseMMDShadowMap==2
    if( !any( saturate(TransTexCoord4) - TransTexCoord4 ) ) {
        // CLSPSM�}�b�v�͈͊O�Ȃ�ŉ��i�}�b�v�Ƃ���MMD�W���}�b�v���g�p����
        Out.Tex1 = float4( TransTexCoord4.xy,
                           MMD_ZCalcTex.z,
                           4.0f );
        Out.Weight = 1.0f;
    }
    #endif
    #endif

    if( !any( saturate(TransTexCoord3) - TransTexCoord3 ) ) {
        TransTexCoord3.x = (1.0f + ZCalcTex3.x)*0.5f;
        TransTexCoord3.y = (1.0f - ZCalcTex3.y)*0.5f;

        Out.Tex2 = Out.Tex1;
        Out.Tex1 = float4( (TransTexCoord3.x + 1.0f) * 0.5f,
                           (TransTexCoord3.y + 1.0f) * 0.5f,
                           ZCalcTex3.z,
                           3.0f );
        Out.Weight = clamp(10.0f*(1.0f - max(abs(ZCalcTex3.x), abs(ZCalcTex3.y))), 0.0f, 1.0f);
    }

    if( !any( saturate(TransTexCoord2) - TransTexCoord2 ) ) {
        TransTexCoord2.x = (1.0f + ZCalcTex2.x)*0.5f;
        TransTexCoord2.y = (1.0f - ZCalcTex2.y)*0.5f;

        Out.Tex2 = Out.Tex1;
        Out.Tex1 = float4( TransTexCoord2.x * 0.5f,
                           (TransTexCoord2.y + 1.0f) * 0.5f,
                           ZCalcTex2.z,
                           2.0f );
        Out.Weight = clamp(10.0f*(1.0f - max(abs(ZCalcTex2.x), abs(ZCalcTex2.y))), 0.0f, 1.0f);
    }

    if( !any( saturate(TransTexCoord1) - TransTexCoord1 ) ) {
        TransTexCoord1.x = (1.0f + ZCalcTex1.x)*0.5f;
        TransTexCoord1.y = (1.0f - ZCalcTex1.y)*0.5f;

        Out.Tex2 = Out.Tex1;
        Out.Tex1 = float4( (TransTexCoord1.x + 1.0f) * 0.5f,
                           TransTexCoord1.y * 0.5f,
                           ZCalcTex1.z,
                           1.0f );
        Out.Weight = clamp(10.0f*(1.0f - max(abs(ZCalcTex1.x), abs(ZCalcTex1.y))), 0.0f, 1.0f);
    }

    if( !any( saturate(TransTexCoord0) - TransTexCoord0 ) ) {
        TransTexCoord0.x = (1.0f + ZCalcTex0.x)*0.5f;
        TransTexCoord0.y = (1.0f - ZCalcTex0.y)*0.5f;

        Out.Tex2 = Out.Tex1;
        Out.Tex1 = float4( TransTexCoord0.x * 0.5f,
                           TransTexCoord0.y * 0.5f,
                           ZCalcTex0.z,
                           0.0f );
        Out.Weight = clamp(10.0f*(1.0f - max(abs(ZCalcTex0.x), abs(ZCalcTex0.y))), 0.0f, 1.0f);
    }

    #ifndef MIKUMIKUMOVING
    #if UseMMDShadowMap==1
    if( !any( saturate(TransTexCoord4) - TransTexCoord4 ) ) {
        // �ŋߌi�}�b�v�Ƃ���MMD�W���}�b�v���g�p����
        Out.Tex2 = Out.Tex1;
        Out.Tex1 = float4( TransTexCoord4.xy,
                           MMD_ZCalcTex.z,
                           4.0f );
        Out.Weight = clamp(10.0f*(1.0f - max(abs(MMD_ZCalcTex.x), abs(MMD_ZCalcTex.y))), 0.0f, 1.0f);
    }
    #endif
    #endif

    if(Out.Tex2.w > 4.5f) Out.Weight = 1.0f;  // 1�̃}�b�v�����Q�Ƃ��Ă��Ȃ��ꍇ

    return Out;
}


