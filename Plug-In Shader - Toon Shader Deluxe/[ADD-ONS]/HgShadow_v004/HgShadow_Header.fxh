////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HgShadow_Header.fxh : HgShadow �V���h�E�}�b�v�쐬�ɕK�v�Ȋ�{�p�����[�^��`�w�b�_�t�@�C��
//  �����̃p�����[�^�𑼂̃G�t�F�N�g�t�@�C���� #include ���Ďg�p���܂��B
//  �쐬: �j��P
//
//  �����̃t�@�C�����X�V���Ă�MME�ɂ�鎩���X�V�͍s���܂���B
//  ���t�@�C���X�V��ɢMMEffect�����S�čX�V��ŎQ�Ƃ��Ă���G�t�F�N�g�t�@�C�����X�V����K�v������܂��B
//  ��MMM�ł�HgShadow.fx���[�h�O�ɕύX���Ă��������B�ύX���e�����f����Ȃ��ꍇ��MMM��Cache�t�H���_����S�č폜���čăg���C�B
//
////////////////////////////////////////////////////////////////////////////////////////////////
// �����̃p�����[�^��ύX���Ă�������


////////////////////// �V���h�E�}�b�v�֘A�̃p�����[�^ ////////////////////////

// �V���h�E�}�b�v�̎�ޑI��( 0:CFSUSM, 1:CLSPSM )
#define ShadowMapType  0
// CFSUSM(Cascaded Fixation Space Uniform Shadow Maps)������ԌŒ萳���V���h�E�}�b�v�ɂ���
//   1�̃I�t�X�N���[����4��������,�p�[�X�̂Ȃ��}�b�v�����ꂼ��ߌi�p���牓�i�p�ɋ�ԌŒ�Ŕz�u�����V���h�E�}�b�v�ł��B
//   ��ԌŒ�Ȃ̂ŃJ��������ɂ��e���E�̂�������N����܂���B�����}�b�v���S�ʒu���痣���Ɖe�̐��x�������Ȃ�܂��B
//   �p�����[�^���������₷�����S�Ҍ����̃}�b�v�ł��B
// CLSPSM(Cascaded Light Space Perspective Shadow Maps)�������C�g��ԓ����V���h�E�}�b�v�ɂ���
//   1�̃I�t�X�N���[����4��������,CSM�@�Ɋ�Â��J����������𕪊�����,���ꂼ����ߌi�p���牓�i�p��
//   LSPSM�@�Ɋ�Â��p�[�X�|�������}�b�v��z�u�����V���h�E�}�b�v�ł��B
//   �p�[�X�̃o�����X���ǂ��ߌi,���i���ɗǍD�ȉe�������鍂���x�ȃ}�b�v�ł����A�V�[���ɉ����ēK�؂ȃp�����[�^��^���Ȃ���
//   �G�C���A�X(�e���E�̃M�U�M�U)���������ăJ��������ɂ�邿������ڗ����Ă��܂��܂��B
//   �p�����[�^�����ɂ̓R�c���K�v��,���E�㋉�Ҍ����̃}�b�v�ɂȂ�܂��B


// �V���h�E�}�b�v�o�b�t�@�T�C�Y
#define ShadowMapSize   2048


// CFSUSM�ł̓V���h�E�}�b�vCSM�����ɂ�����ŋߒl
// CLSPSM�ł̓V���h�E�}�b�v�Q�Ɣ͈͓��ɂȂ�J����������̍ŋߒl(MMD�̢X�, MMM�̢Near�l��Œ�����)
#define ShadowViewNear  2.0


// CFSUSM�ł̓V���h�E�}�b�v�Q�Ɣ͈͓��ɂȂ�ŉ��l(MMD�̢Rz�, MMM�̢�}�b�v�͈ͣ�Œ�����)
// CLSPSM�ł̓V���h�E�}�b�v�Q�Ɣ͈͓��ɂȂ�J����������̍ŉ��l(MMD�̢Y�, MMM�̢Far�l��Œ�����)
#define ShadowViewFar   1000.0


// �V���h�E�}�b�v�ōl�����锼�����ގ��̃����ߒl�ɑ΂���臒l
#define ShadowAlphaThreshold   0.5


// �V���h�E�}�b�v�ŃG�b�W�̐[�x���l�����邩�ǂ���
#define DrawShadowMapEdge  1
// 0 : �l�����Ȃ�
// 1 : �l������


// MMD�W���V���h�E�}�b�v�̎g�p
#define UseMMDShadowMap   2
// 0 : �g�p���Ȃ�
// 1 : �ŋߌi�̃}�b�v�Ƃ��Ďg�p����
// 2 : �ŉ��i�̃}�b�v�Ƃ��Ďg�p����
// ��MMM�ł͕W���V���h�E�}�b�v�͎g��Ȃ��̂Őݒ�s�p


////////////////////// �\�t�g�V���h�E�֘A�̃p�����[�^ ////////////////////////

// �\�t�g�V���h�E�̃N�I���e�B���[�h(0�`3�őI��, �������オ��قǏd���Ȃ�܂�)
#define SoftShadowQuality  3
// 0 : �\�t�g�V���h�E����
// 1 : �ȈՓI�ȃ\�t�g�V���h�E(�V���h�E�}�b�v�̊ȈՃ}���`�T���v���{��ʏ��9�_�T���v�����O�̂�)
// 2 : �����Â����\�t�g�V���h�E(1�̕��@�{��ʃ}�b�v�̋ߖT�t�B���^�����O�ǉ�)
// 3 : ����ɋÂ����\�t�g�V���h�E(2�̕��@�{�Օ������ɂ��ڂ����x�����̒����@�\�ǉ�)


// �V���h�E�}�b�v�}���`�T���v���̃T���v�����O��(1�`13�őI��)
#define ShadowMapSampCount  9


// �ߖT�t�B���^�����O�̃T���v�����O��(5�`65�őI��, �傫������قǂڂ������Y��ɂȂ�,���d���Ȃ�)
#define ViewportMapSampCount  13
// �����ڂ������|�������ɂ����̒l���������Ƃڂ����Ƀ������o�܂�


// �\�t�g�V���h�E�̂ڂ������x��l(�傫������Ə�����Ԃ̂ڂ����������Ȃ�)
#define InitBlurPower  2.0


////////////////////// ���̑��̐���X�C�b�`�p�����[�^ ////////////////////////

// VolumeShadow.fx �Ƃ̋��p�����邩�ǂ���
#define WithVolumeShadow  0
// 0 : ���p���Ȃ�
// 1 : ���p����
// ��MMM�ł͖��Ή��Ȃ̂Őݒ�s�p


// �e�����o�b�t�@�̃A���`�G�C���A�X��on/off
#define BufferAntiAlias   1
// 0 : off
// 1 : on
// �ʏ��on�ɂ��Ă����܂���,�Ή����Ă��Ȃ��O���{�����邽��,���܂����삵�Ȃ��ꍇ��off�ɂ��Ă�������


// �e�����o�b�t�@�t�H�[�}�b�g�̕����������x
#define BufferFmtQuality  0
// 0 : 16bit
// 1 : 32bit


// ����Ȃ��l�͂������牺�͂�����Ȃ��ł�

////////////////////////////////////////////////////////////////////////////////////////////////

#define CFSUSM  0
#define CLSPSM  1

#ifdef HGSHADOW_MAPDRAW

#if (ShadowMapType == CLSPSM)
    #include "HgShadow_CLSPSM.fxh"
    #define HgShadow_GetShadowMapLightProjPosition  HgShadow_CLSPSM_GetLightProjPosition
    #define HgShadow_GetShadowMapTexCoord  HgShadow_CLSPSM_GetTexCoord
#else
    #include "HgShadow_CFSUSM.fxh"
    #define HgShadow_GetShadowMapLightProjPosition  HgShadow_CFSUSM_GetLightProjPosition
    #define HgShadow_GetShadowMapTexCoord  HgShadow_CFSUSM_GetTexCoord
#endif

#endif

#ifdef HGSHADOW_TEST

#if (ShadowMapType == CLSPSM)
    #include "../HgShadow_CLSPSM.fxh"
    #define HgShadow_GetShadowMapLightProjPosition  HgShadow_CLSPSM_GetLightProjPosition
    #define HgShadow_GetShadowMapTexCoord  HgShadow_CLSPSM_GetTexCoord
#else
    #include "../HgShadow_CFSUSM.fxh"
    #define HgShadow_GetShadowMapLightProjPosition  HgShadow_CFSUSM_GetLightProjPosition
    #define HgShadow_GetShadowMapTexCoord  HgShadow_CFSUSM_GetTexCoord
#endif

#endif

