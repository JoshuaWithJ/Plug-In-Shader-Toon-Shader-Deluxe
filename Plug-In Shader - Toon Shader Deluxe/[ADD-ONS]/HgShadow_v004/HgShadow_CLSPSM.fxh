////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HgShadow_CLSPSM.fxh : HgShadow �V���h�E�}�b�v��{�v�Z
//  �������C�g��ԓ����V���h�E�}�b�v CLSPSM(Cascaded Light Space Perspective Shadow Maps) �̍쐬
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

// ���W�ϊ��s��
float4x4 HgShadow_WorldMatrix   : WORLD;
float4x4 HgShadow_ViewMatrix    : VIEW;
float4x4 HgShadow_ProjMatrix    : PROJECTION;
float4x4 HgShadow_InvViewMatrix : VIEWINVERSE;

// �J�����ʒu
float3 HgShadow_CameraPosition  : POSITION  < string Object = "Camera"; >;

// �J��������(���K���ς�)
float3 HgShadow_CameraDirection : DIRECTION < string Object = "Camera"; >;

// ���C�g����(���K���ς�)
float3 HgShadow_LightDirection  : DIRECTION < string Object = "Light"; >;


#ifndef MIKUMIKUMOVING

// �R���g���[���p�����[�^(MME)
#ifdef HGSHADOW_TEST
    #define CTRLFILENAME  "HgShadow.x"
#else
    #define CTRLFILENAME  "(OffscreenOwner)"
#endif
float HgShadow_NearZ : CONTROLOBJECT < string name = CTRLFILENAME; string item = "X"; >;     // Near�ʒu�����l
float HgShadow_FarZ  : CONTROLOBJECT < string name = CTRLFILENAME; string item = "Y"; >;     // Nar�ʒu�����l
float HgShadow_CSMParam  : CONTROLOBJECT < string name = CTRLFILENAME; string item = "Z"; >; // CSM�������p�����[�^
float HgShadow_LtLen : CONTROLOBJECT < string name = CTRLFILENAME; string item = "Rz"; >;    // LightSpace�p�[�X�����l

static float HgShadow_NearAll = max(ShadowViewNear + HgShadow_NearZ, 1.0f);
static float HgShadow_FarAll  = max(ShadowViewFar + HgShadow_FarZ, HgShadow_NearAll+1.0f);
static float HgShadow_Lamda   = clamp(0.97f - 0.97f*HgShadow_CSMParam, 0.0f, 1.0f);
static float HgShadow_Lamda2  = 1.0f + saturate(-HgShadow_CSMParam);
static float HgShadow_NearLen = degrees(HgShadow_LtLen);

#else

// �R���g���[���p�����[�^(MMM)
shared float HgShadow_MMM_ShadowViewNear;
shared float HgShadow_MMM_ShadowViewFar;
shared float HgShadow_MMM_CascadedParam;
shared float HgShadow_MMM_PerspectiveParam;
static float HgShadow_NearAll = HgShadow_MMM_ShadowViewNear;
static float HgShadow_FarAll  = HgShadow_MMM_ShadowViewFar;
static float HgShadow_Lamda   = clamp(0.97f - 0.97f*HgShadow_MMM_CascadedParam, 0.0f, 1.0f);
static float HgShadow_Lamda2  = 1.0f + saturate(-HgShadow_MMM_CascadedParam);
static float HgShadow_NearLen = HgShadow_MMM_PerspectiveParam;

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
   if( !any(viewX) ) viewX = HgShadow_ViewMatrix._11_21_31;
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
// CLSPSM�ɂ�郉�C�g�����̃r���[�ˉe�ϊ�

float4 HgShadow_CLSPSM_GetLightProjPosition(float4 WPos, int mapIndex)
{
    // �J���������ƃ��C�g�����̂Ȃ��p
    float cosAng = dot(HgShadow_CameraDirection, HgShadow_LightDirection);
    float sinAng = sqrt(1.0f - cosAng * cosAng);

    // ���C�g�����̃r���[�ϊ��s��
    float4x4 ltViewMat = HgShadow_CreateViewMatrix(HgShadow_CameraPosition, HgShadow_LightDirection, HgShadow_CameraDirection);

    // ���[���h���W�֖߂�+���C�g�����̃r���[�ϊ��s��
    float4x4 InvView_ltViewMat = mul(HgShadow_InvViewMatrix, ltViewMat);

    // ���������J�����������Near��Far�̈ʒu(CSM�@�ɂ�镪��)
    float nearAll = HgShadow_NearAll;
    float farAll  = HgShadow_FarAll;
    float lamda   = HgShadow_Lamda;
    float lamda2  = HgShadow_Lamda2;
    float ixn = pow(float(mapIndex)/float(HgShadow_MapCount), lamda2);
    float ixf = pow(float(mapIndex+1)/float(HgShadow_MapCount), lamda2);
    float camNear = lamda * nearAll * pow(farAll/nearAll, ixn)
                  + (1.0f-lamda) * (nearAll + (float(mapIndex)/float(HgShadow_MapCount)) * (farAll-nearAll));
    float camFar  = lamda * nearAll * pow(farAll/nearAll, ixf)
                  + (1.0f-lamda) * (nearAll + (float(mapIndex+1)/float(HgShadow_MapCount)) * (farAll-nearAll));
    float2 nearPos = float2(camNear / HgShadow_ProjMatrix._11, camNear / HgShadow_ProjMatrix._22 );
    float2 farPos  = float2(camFar / HgShadow_ProjMatrix._11, camFar / HgShadow_ProjMatrix._22 );

    // �R���g���[���p�����[�^�ɂ��Near�����l
    float ixf0 = pow(1.0f/float(HgShadow_MapCount), lamda2);
    float camFar0  = lamda * nearAll * pow(farAll/nearAll, ixf0)
                  + (1.0f-lamda) * (nearAll + (1.0f/float(HgShadow_MapCount)) * (farAll-nearAll));
    float offsetNear = HgShadow_NearLen * (camFar-camNear) / (camFar0-nearAll);

    // �J����������̒��_�r���[���W
    float4 VFrustumPos[8] = { float4(-nearPos.x,  nearPos.y, camNear, 1.0f),
                              float4(-nearPos.x, -nearPos.y, camNear, 1.0f),
                              float4( nearPos.x, -nearPos.y, camNear, 1.0f),
                              float4( nearPos.x,  nearPos.y, camNear, 1.0f),
                              float4(-farPos.x,   farPos.y,  camFar,  1.0f),
                              float4(-farPos.x,  -farPos.y,  camFar,  1.0f),
                              float4( farPos.x,  -farPos.y,  camFar,  1.0f),
                              float4( farPos.x,   farPos.y,  camFar,  1.0f) };

    // ���[���h���W�֖߂�+���C�g�����̍��W
    [unroll]
    for(int i=0; i<8; i++){
        VFrustumPos[i] = mul( VFrustumPos[i], InvView_ltViewMat );
    }

    // �������AABB(Axis Aligned Bounding Box)���쐬
    float3 minAABB = float3( 1e30,  1e30,  1e30);
    float3 maxAABB = float3(-1e30, -1e30, -1e30);
    [unroll]
    for(int j=0; j<8; j++){
        minAABB = min( VFrustumPos[j].xyz, minAABB );
        maxAABB = max( VFrustumPos[j].xyz, maxAABB );
    }

    // �}�b�v�������E�̃��j�A��ǂ܂Ȃ��悤�ɂ��邽�߂̏k���W��
    float2 sc = float2( (0.5f*SMAPSIZE_WIDTH - HgShadow_SCParam) / (0.5f*SMAPSIZE_WIDTH),
                        (0.5f*SMAPSIZE_HEIGHT - HgShadow_SCParam) / (0.5f*SMAPSIZE_HEIGHT) );

    float4 PPos;  // ���C�g�����̃��[���h�r���[�ˉe�ϊ����W

    if(sinAng > 0.00001f){
    // �J���������ƃ��C�g�����̂Ȃ��p�� 0��,180���łȂ��ꍇ

        // LightSpace��Near��Far
        //float lsNear = max( camNear + sqrt(camNear*camFar) + offsetNear, 1.0f ) / sinAng; // LSPSM���_���̕��@
        float lsNear = max( camNear + sqrt(nearAll*camFar) + offsetNear, 1.0f ) / sinAng;  // CSM�ł͂��̕����p�[�X�o�����X���ǂ���
        float lsFar = lsNear + maxAABB.y - minAABB.y;

        // LightSpace�̎��_�ʒu
        float3 lsPos = float3(0.0f, minAABB.y - lsNear, (maxAABB.z + minAABB.z)*0.5f);

        // LightSpace���_�̃r���[�ϊ��s��
        float4x4 lsViewMat = HgShadow_CreateViewMatrix(lsPos, float3(0,1,0), float3(0,0,-1));

        // �������LightSpace���_�̃r���[���W
        [unroll]
        for(int i=0; i<8; i++){
            VFrustumPos[i] = mul( VFrustumPos[i], lsViewMat );
        }

        // �ő压��ptan(a/2)
        float2 maxViewAng = float2(0.0f, 0.0f);
        [unroll]
        for(int j=0; j<8; j++){
            maxViewAng = max( abs(VFrustumPos[j].xy/VFrustumPos[j].z), maxViewAng );
        }

        // �ˉe�ϊ���̖������ʈʒu
        float InfZ = lsFar / (lsFar - lsNear);

        // LightSpace���_�̎ˉe�ϊ��s��
        float4x4 lsProjMat = float4x4( 1.0f/maxViewAng.x,              0.0f,         0.0f,  0.0f,
                                                    0.0f, 1.0f/maxViewAng.y,         0.0f,  0.0f,
                                                    0.0f,              0.0f,         InfZ,  1.0f,
                                                    0.0f,              0.0f, -lsNear*InfZ,  0.0f );

        // LightSpace���_�̎ˉe���W�����C�g�����̎ˉe���W�ɕϊ����邽�߂̍s��
        const float4x4 ltTransMat = float4x4( 1.0f,  0.0f,  0.0f,  0.0f,
                                              0.0f,  0.0f, -0.5f,  0.0f,
                                              0.0f,  2.0f,  0.0f,  0.0f,
                                              0.0f, -1.0f,  0.5f,  1.0f );

        // �ϊ��s�������
        float4x4 lightViewProjMatrix = mul( mul( mul(ltViewMat, lsViewMat), lsProjMat ), ltTransMat );
        lightViewProjMatrix._11_21_31_41 *= sc.x;
        lightViewProjMatrix._12_22_32_42 *= sc.y;

        // ���C�g�����̎ˉe�ϊ����W
        PPos = mul( WPos, lightViewProjMatrix );

        // Z�l�ɂ̓p�[�X���|���Ȃ�(�Ǝ��d�l)
        float Z = mul( WPos, mul(ltViewMat, lsViewMat)).y;
        PPos.z = -Z * 0.0001f + 0.5f;  // �[�x-5000�`+5000�͈̔͂��ˉe��Ԃ̎�������ɔ[�߂�

    }else{
    // �J���������ƃ��C�g�����̂Ȃ��p�� 0��,180���̏ꍇ�̓p�[�X�Ȃ��̃V���h�E�}�b�v

        // ���C�g�����̃r���[�ϊ��s��
        float4x4 LtViewMat = float4x4( ltViewMat[0],
                                       ltViewMat[1],
                                       ltViewMat[2],
                                      -float3( (minAABB.x+maxAABB.x)*0.5f, (minAABB.y+maxAABB.y)*0.5f, (minAABB.z+maxAABB.z)*0.5f ), 1 );

        // ���C�g�����̎ˉe�ϊ��s��
        float4x4 LtProjMat = float4x4( 2.0f*sc.x/(maxAABB.x-minAABB.x),  0,       0, 0,
                                       0,  2.0f*sc.y/(maxAABB.y-minAABB.y),       0, 0,
                                       0,  0,                               0.0001f, 0,
                                       0,  0,                                  0.5f, 1 );

        // ���C�g�����̎ˉe�ϊ����W
        PPos = mul( WPos, mul(LtViewMat, LtProjMat) );
    }

    return PPos;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// �����̃}�b�v���琸�x�̗ǂ����2�}�b�v�̃e�N�X�`�����W�Ɛ[�x��I�яo��

struct HgShadow_SMapDat {
    float4 Tex1;   // 1�Ԑ��x���悢ZCalcTex(xy:�}�b�v���W, z:ZPlot, w:�}�b�v�ԍ�)
    float4 Tex2;   // 2�Ԗڂɐ��x���悢ZCalcTex(xy:�}�b�v���W, z:ZPlot, w:�}�b�v�ԍ�)
    float Weight;  // Tex1����߂�E�G�C�g
};

HgShadow_SMapDat HgShadow_CLSPSM_GetTexCoord(float4 ZCalcTex0, float4 ZCalcTex1, float4 ZCalcTex2, float4 ZCalcTex3, float4 MMD_ZCalcTex)
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


