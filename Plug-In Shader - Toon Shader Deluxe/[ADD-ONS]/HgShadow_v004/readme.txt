HgShadow.fx ver0.0.4

��Ƃ��Ƃ񍂕i�ʂȉe��ǋ����Ă݂悤!��Ƃ������j�ō쐬�����e�����G�t�F�N�g�B
�ȉ��̂悤�ȓ���������܂��B

�E�V���h�E�}�b�v�Ƃ���CFSUSM(Cascaded Fixation Space Uniform Shadow Maps�F������ԌŒ萳���V���h�E�}�b�v)��
  CLSPSM(Cascaded Light Space Perspective Shadow Maps�F�������C�g��ԓ����V���h�E�}�b�v)��2��ނ��������Ă��܂��B
  �󋵂ɉ����Ăǂ��炩������p�����[�^�Ő؂�ւ��Ďg�p���܂��B

�ECFSUSM��1�̃I�t�X�N���[����4��������,�p�[�X�����̃}�b�v�����ꂼ��ߌi�p���牓�i�p�ɋ�ԌŒ�Ŕz�u�����V���h�E�}�b�v�ł��B
  ��ԌŒ�Ȃ̂ŃJ��������ɂ��e���E�̂�������N����܂���B�����}�b�v���S�ʒu���痣���Ɖe�̐��x�������Ȃ�܂��B
  �p�����[�^���������₷�����S�Ҍ����̃}�b�v�ł��B(���Ȃ݂�CFSUSM�Ƃ����͍̂�҂�����ɖ��t��������ł�)

�ECLSPSM��1�̃I�t�X�N���[����4��������,CSM�@�Ɋ�Â��J����������𕪊����āA���ꂼ����ߌi�p���牓�i�p��
  LSPSM�@�Ɋ�Â��p�[�X�|�������}�b�v��z�u�����V���h�E�}�b�v�ł��B
  �p�[�X�o�����X���ǂ��ߌi�E���i���ɗǍD�ȉe�������鍂���x�ȃ}�b�v�ł����A�V�[���ɉ����ēK�؂ȃp�����[�^��^���Ȃ���
  �G�C���A�X(�e���E�̃M�U�M�U)���������ăJ��������ɂ�邿������ڗ����Ă��܂��܂��B
  �p�����[�^�����ɂ̓R�c���K�v�ŁA���E�㋉�Ҍ����̃}�b�v�ł��B

�EMMD�W���V���h�E�}�b�v���ŋߌi�܂��͍ŉ��i�̃}�b�v�Ƃ��āA�{�G�t�F�N�g�̃V���h�E�}�b�v�Ƒg�ݍ��킹��
  �g�p���邱�ƂŁA���L�͈́E�����x�ȉe�������\(MMM�W���V���h�E�}�b�v�͖��Ή�)�B

�E�V���h�E�}�b�v����荂���x�����邽�߂̃p�����[�^�����@�\�ƁA�������x������G�t�F�N�g��t���B

�E�\�t�g�V���h�E�ɑΉ��A�ڂ����̋������Օ�����,�[�x,������������p�x,����p�ɂ���Ē������Ă���A
  ��莩�R�ɋ߂��ڂ������ɂȂ��Ă��܂��B

�E�ٍ�VolumeShadow�Ƃ̋��p���\�ł��BVolumeShadow�̉e���\�t�g�V���h�E�̑ΏۂɂȂ�܂��B

�E���Ȃ�d���ł��B



�������
SM3.0�Ή��O���t�B�b�N�{�[�h���K�{�ɂȂ�܂��B
MMEv0.37, MMEv0.37x64�CMMMv125d�CMMM64v125d�œ���m�F���s���Ă��܂��B���o�[�W�����ł͓��삵�Ȃ��\��������܂��B



���g�p���@
(1)�G�t�F�N�g�t�@�C���ɒ��ړ��͂���p�����[�^�� HgShadow_Header.fxh �ɂ܂Ƃ߂Ă���܂��B�\�ߕK�v�ɉ����ĕύX���Ă��������B
   ���ɃV���h�E�}�b�v�̎�� CFSUSM or CLSPSM �ǂ����I�Ԃ��Ō�̃p�����[�^�������@���ς���Ă��܂��B
   �f�t�H���g�̃V���h�E�}�b�v�� CFSUSM �ɂȂ��Ă��܂��BCLSPSM �ɂ���ɂ̓p�����[�^�̐؂�ւ����K�v�ł��B
(2)MMD/MMM�̑S�̂̃Z���t�e�ݒ��ON�ɂ��ĉ������B���f���E�A�N�Z�̉e��ON�ɂ��ĉ������B
(3)HgShadow.x��MMD�Ƀ��[�h���Ă��������BMMM�ł�HgShadow.fx�𒼐ڃ��[�h���܂��B
(4)HgShadow.x�̕`�揇�����o���邾���O�̕��ɂ��Ă��������BMMM�ł�HgShadow.x���O�̏����̃��f���͐���ɕ`�悳��܂���B
(5)�`�悷�邷�ׂẴ��f���E�A�N�Z�T���Ɉȉ��̃G�t�F�N�g�t�@�C����K�p���܂��B
  MME�̏ꍇ
    �MMEffect�����G�t�F�N�g�������Main�^�u���e�`�悷�邷�ׂẴ��f���E�A�N�Z�T����I������ full_HgShadow.fx ��K�p���܂��B
  MMM�̏ꍇ
    full_HgShadow_MMM.fx ��MMM�Ƀ��[�h���āA���C���̢�G�t�F�N�g���蓖�ģ���e�`�悷��S���f���E�A�N�Z�T���ɓK�p�B
    (�Ή����Ă���̂̓��C�g1�̂݁A���C�g2,���C�g3�͕W���̉e���`�悳��܂��B)
  ���X�J�C�h�[���Ȃǉe�������s�v�̃��f���ɂ͓K�p����K�v�͂���܂���B
(6)HgShadow.x�̃A�N�Z�T���p�����[�^���ȉ��̑��삪�\�ł��B
  MME�̏ꍇ
    X,Y,Z,Rz : �V���h�E�}�b�v���œK�����邽�߂̃p�����[�^(��q)
    Si : �\�t�g�V���h�E�ɂ��e�̂ڂ����x
    Tr : �Օ������ɂ���Ăڂ����̋�����ς���x�����𒲐����܂�
    Rx : �e�̔Z�x�ύX( Rx+1 ���ݒ�Z�x�A-1�ŉe�������܂� )
    Ry(CFSUSM�̏ꍇ) : �V���h�E�}�b�v���œK�����邽�߂̃p�����[�^(��q)
    Ry(CLSPSM�̏ꍇ) : �ߖT�e�����p�����[�^ -1�`+1�Őݒ�
                       �傫������Ƃ�����̂���ߖT�e�������ł��܂��B�����������ė~�����Ȃ��ߖT�e�܂ŏ����Ă��܂��̂ŗv����
  MMM�̏ꍇ
    MMM�ł�HgShadow.fx�̃G�t�F�N�g�v���p�e�B��蓯�l�̑���E�ݒ肪�s���܂��B



��PMD�EPMX�̑g�ݍ��݃R���g���[�����[�t�ɂ���
�e�������郂�f����PMD�EPMX�̏ꍇ�̓��f���ɃR���g���[���p�̃_�~�[���[�t��ǉ����邱�ƂŁA���f�����Ɍʂ�
�������o����悤�ɂȂ�܂��B�Ή����Ă��郂�[�t���͈ȉ��̒ʂ�ł��B

   ShadowBlur+ : ���f���̉e�̂ڂ����x���グ�܂�
   ShadowBlur- : ���f���̉e�̂ڂ����x�������܂�
   ShadowDen+  : ���f���̉e�̔Z�x���グ�܂�
   ShadowDen-  : ���f���̉e�̔Z�x�������܂�

   ���Option��t�H���_�ɂ���PMDE�X�N���v�g��R���g���[�����[�t�ǉ�.cx����g����,�����̃��[�t���ꊇ�ǉ����邱�Ƃ��o���܂��B



��MMD�W���V���h�E�}�b�v�̎g�p�ɂ���
���̃G�t�F�N�g�ł�MMD�W���V���h�E�}�b�v���ŋߌi�܂��͍ŉ��i�̃}�b�v�Ƃ��āACFSUSM,CLSPSM�V���h�E�}�b�v�̓K�p�͈͊O��
�⊮���邱�Ƃ��o���܂��B�f�t�H���g�ł͍ŉ��i�̃}�b�v�Ƃ��Ďg�p����悤�ɐݒ肳��Ă��܂��B���L�͈́E�����x��
�e�������s���ɂ͎��̂悤�ȃp�����[�^�ݒ肪�K�v�ł��B
(1)�ŉ��i�}�b�v�Ƃ��Ďg�p����ꍇ
   �@HgShadow_Header.fxh�̃p�����[�^�� UseMMDShadowMap 2 �ɂ��܂�(�f�t�H���g�ݒ�)�B
   �AMMD�̢�Z���t�V���h�E���죃p�l����艓�i�D��̐ݒ�ɂ��܂�(mode2, �e�͈�9800�ȏオ�I�X�X��)
(2)�ŋߌi�}�b�v�Ƃ��Ďg�p����ꍇ
   �@HgShadow_Header.fxh�̃p�����[�^�� UseMMDShadowMap 1 �ɂ��܂��B
   �AMMD�̢�Z���t�V���h�E���죃p�l�����ߌi�D��̐ݒ�ɂ��܂�(mode1, �e�͈�5000�ȉ����I�X�X��)
     �ŋߌi�̏ꍇ��mode2�ɂ����CFSUSM,CLSPSM�}�b�v��S�ď㏑�����Ă��܂��̂ŕK��mode1�ɂ��邱��

��MMM�ł͕W���V���h�E�}�b�v�̎g�p�͖��Ή��ł��BCFSUSM,CLSPSM�V���h�E�}�b�v�݂̂ŕK�v�ȗ̈���J�o�[���Ă��������B



���V���h�E�}�b�v�p�����[�^�̍œK���ɂ���
���ꂼ��̃V�[���ɍ��킹�Ă�荂�i�ʂȉe�𓾂�ɂ̓V���h�E�}�b�v�p�����[�^�̍œK�����K�v�ɂȂ�܂��B
�V���h�E�}�b�v�œK���ݒ�ɕK�v�ȑ���p�����[�^�͈ȉ��̒ʂ�ł��B

(1)�V���h�E�}�b�v��CFSUSM�̏ꍇ

  MME�̏ꍇ�AHgShadow.x�̃A�N�Z�T���p�����[�^���
    X,Y,Z : �A�N�Z�T���̍��W���V���h�E�}�b�v�̒��S�ʒu�ɂȂ�܂��B���W�ʒu�̓{�[���ɃA�T�C�������ꍇ��
            �A�T�C����̈ʒu�����S���W�ɂȂ�܂��B���S�ʒu���痣���Ɖe�̐��x�������Ȃ�܂��B
            �V�[���ɉ����ĕ`�悵�����Ώۂ̒��S�Ɉړ������Ă��������B
    Rz : �V���h�E�}�b�v�Q�Ɣ͈͓��ɂȂ�ŉ��l�𒲐��A�e�`�悷��͈͂������Őݒ肵�܂��B
         HgShadow_Header.fxh�ŏ����l ShadowViewFar(�f�t�H���g1000) ��ݒ肵�� ShadowViewFar�{Rz ���}�b�v�̓K�p�͈͂ɂȂ�܂��B
         �����܂ŕ\������Ă���V�[���ł͂������グ�Ȃ��Ɖ����e���\������܂���B
         �t�ɋߌi�݂̂̃V�[���ł͂����������邱�ƂŃ}�b�v�̉𑜓x�������ł��܂��B
    Ry : �V���h�E�}�b�v�𕪊�����ۂ̊e�}�b�v�̊����𒲐��A-1 �` +1 �Őݒ肵�܂��B
         �ߌi�̐��x��ǂ����������̓}�C�i�X�l�ɁA���i�̐��x��ǂ����������̓v���X�l�ɂ��Ă��������B

  MMM�̏ꍇ�AHgShadow.fx�̃G�t�F�N�g�v���p�e�B���
    �}�b�v�͈�  : MME�� ShadowViewFar�{Rz �Ɠ����ݒ�ɂȂ�܂�
    CascadParam : MME�� Ry �Ɠ����ݒ�ɂȂ�܂�

(2)�V���h�E�}�b�v��CLSPSM�̏ꍇ

  MME�̏ꍇ�AHgShadow.x�̃A�N�Z�T���p�����[�^���
    X  : �V���h�E�}�b�v��K�p����J��������̋����̍ŋߒl(Near�l)�𒲐��A
         HgShadow_Header.fxh�ŏ����l ShadowViewNear(�f�t�H���g2)��ݒ肵�� ShadowViewNear�{X ��Near�l�ɂȂ�܂��B
         ���̃p�����[�^�̓V���h�E�}�b�v�̐��x�ɍł��傫�ȉe����^���܂��B
         �Y�[���A�b�v�ȊO�̎��� X=5�`10 ���x�ɂ��Ă��������ߌi�̐��x�������Ȃ�܂��B
         �������Y�[���A�b�v�ŃI�u�W�F�N�g�̋�����Near�l�ȉ��ɂȂ�Ƌɒ[�ɐ��x�������Ȃ�̂ŗv���ӁB
         ���i�݂̂̕\���ł͉�ʂɕ\������Ă��郂�f���ŋߐ[�x��2/3���x�ɂ���Ɨǂ������ɂȂ�܂��B
    Y  : �V���h�E�}�b�v��K�p����J��������̋����̍ŉ��l(Far�l)�𒲐��A
         HgShadow_Header.fxh�ŏ����l ShadowViewFar(�f�t�H���g1000) ��ݒ肵�� ShadowViewFar�{Y ��Far�l�ɂȂ�܂��B
         �����܂ŕ\������Ă���V�[���ł͂������グ�Ȃ��Ɖ����e���\������܂���B
         �t�ɋߌi�݂̂̃V�[���ł͂����������邱�ƂŃ}�b�v�̉𑜓x�������ł��܂��B
    Z  : �V���h�E�}�b�v�𕪊�����J���������𒲐��A-1 �` +1 �Őݒ肵�܂��B
         0�̎���CSM�@�Ɋ�Â��������@�ɂȂ��Ă��܂��B�傫�������Near�`Far�̊Ԃ��ϓ������߂Â��悤��
         ������������U���A����������Ƃ��ߌi�ɑ����̃}�b�v���\�[�X�������悤�Ɋ���U���܂��B
    Rz : ���������X�̃}�b�v�̃p�[�X�x�𒲐����܂��A-1 �` +1 �Őݒ肵�܂��B
         0�̎���LSPSM�@�Ɋ�Â����p�[�X�����ɂȂ��Ă��܂��B�傫������ƃp�[�X�̊|�������キ�Ȃ�
         ����������ƃp�[�X�̊|���肪�����Ȃ�܂��B���ۂ͉��i�̕`���ł͂قƂ�Ǖω��͂Ȃ��̂�
         �ߌi�̃Y�[���A�b�v�������f���̃}�b�v�𑜓x�𒲐����鎞�Ɏg�p���܂��B

  MMM�̏ꍇ�AHgShadow.fx�̃G�t�F�N�g�v���p�e�B���
    Near�l      : MME�� ShadowViewNear�{X �Ɠ����ݒ�ɂȂ�܂�
    Far�l       : MME�� ShadowViewFar�{Y �Ɠ����ݒ�ɂȂ�܂�
    CascadParam : MME�� Z �Ɠ����ݒ�ɂȂ�܂�
    PersParam   : MME�� Rz �Ɠ����ݒ�ɂȂ�܂�

  ���V���h�E�}�b�v�p�����[�^�̍œK���͊���Ȃ��Ɠ���̂ŁA
    �ŏ��̂�����Near�l��Far�l�݂̂Œ������������ǂ���������܂���B



���V���h�E�}�b�v�e�X�g�p�G�t�F�N�g�ɂ���
���̃G�t�F�N�g�ɂ̓V���h�E�}�b�v�̐��x���������邽�߂̃e�X�g�p�G�t�F�N�g���t������Ă��܂��B
�Option��t�H���_�ɂ���ȉ��̃G�t�F�N�g���g�p���邱�ƂŃV���h�E�}�b�v�̍œK�p�����[�^�l�������₷���Ȃ�܂��B

(1)HgShadow_TestAliasingError.fx�ɂ���
   �e��������AliasingError����������G�t�F�N�g�ł��BAliasingError�Ƃ����̂̓V���h�E�}�b�v��1�̃s�N�Z���ɑ΂��A
   ������Q�Ƃ����ʏ�̃s�N�Z�����Ƃ̊����𐔒l���������̂ŁA���̒l��1�ȏ�ɂȂ�ƃG�C���A�X(�e���E�̃M�U�M�U)
   ���������܂��B�V���h�E�}�b�v�̐��x�𑪂�ڈ��ɂȂ��Ă��܂��B
   ����AliasingError����ʏ�̂قƂ�ǂ̗̈��1�ȉ��ɂȂ��Ă���΁A��p�����[�^�͍œK�ł��飂Ɣ��f�ł��܂��B

   �g�p���@(HgShadow�����łɐݒ肳��Ă����Ԃ�)
    �@HgShadow_TestAliasingError.x��MMD�Ƀ��[�h���Ă��������BMMM�ł�HgShadow_TestAliasingError.fx�𒼐ڃ��[�h���܂��B
    �A�`�揇����HgShadow.x�̌�ɂ��Ă��������B
    �B��ʏ��AliasingError�̒l���F�������ꂽ��Ԃŕ\������܂��B�ΐF��1�ŐԖ��������ق�AliasingError�l������
      �V���h�E�}�b�v�̐��x���������Ƃ������Ă��܂��BHgShadow.x�̃p�����[�^��ύX���ĉ�ʑS�̂̐F���o�������
      �΁`�͈̔͂Ɏ��܂�悤�ɒ������܂��B��ʍ��ɖ}�Ⴊ�\������Ă���̂ŎQ�l�ɂ��Ă��������B
    �C��ʏ�ɕ\�������O���b�h��(������Ԃł�)1�}�X�ŃV���h�E�}�b�v��16�~16�s�N�Z���ɑ������Ă��܂��B
    �DHgShadow_TestAliasingError.x��Si,Tr�ŃO���b�h��,�\���F���ߒl��ύX�ł��܂��B
    �E�p�����[�^�������ς񂾂碕\����`�F�b�N���O���Ĕ�\���ɂ��Ă��������B�e�̐��x�͒����O�ɔ�ׂČ��サ�Ă���͂��ł��B

(2)HgShadow_TestViewShadowmap.fx�ɂ���
   �{�G�t�F�N�g�ō쐬���ꂽCFSUSM,CLSPSM�V���h�E�}�b�v����������G�t�F�N�g�ł��B
   MMD��Shift+G�ŕ\�������W���V���h�E�}�b�v�Ɗ�{�I�ɓ����@�\�ł��B

   �g�p���@(HgShadow�����łɐݒ肳��Ă����Ԃ�)
    �@HgShadow_TestViewShadowmap.x��MMD�Ƀ��[�h���Ă��������BMMM�ł�HgShadow_TestViewShadowmap.fx�𒼐ڃ��[�h���܂��B
    �A�`�揇���͏o���邾�����̕��ɂ��Ă��������B
    �B��ʉE��ɃV���h�E�}�b�v���\������܂��B
    �CHgShadow_TestViewShadowmap.x��Si,Tr�ŕ\���V���h�E�}�b�v�̃T�C�Y�ύX�ƕ\���F���ߒl��ύX�ł��܂��B

(3)MMD_MMM_TestAliasingError.fx�ɂ���
   MMD�EMMM�W���̃V���h�E�}�b�v��AliasingError���������܂��BHgShadow�Ƃ͒��ڊ֌W�̂Ȃ��P�Ȃ�I�}�P�ł��B
   �W���V���h�E�}�b�v�̃p�����[�^�ݒ莞�ɂ����p���������B�g������HgShadow_TestAliasingError.fx�Ɠ����ł��B



��VolumeShadow�Ƃ̋��p�ɂ���
���̃G�t�F�N�g�ł�VolumeShadow.fx�ɂ��V���h�E�{�����[���̉e��{�G�t�F�N�g�Ő������ꂽ�e�Ƌ��p���邱�Ƃ��o���܂��B
���p�ݒ���s����VolumeShadow�̐����e�͖{�G�t�F�N�g�̐����e�ƍ�������A���Ƀ\�t�g�V���h�E�̏������s���o�͂���܂��B
   �g�p���@(HgShadow�����łɐݒ肳��Ă����Ԃ�)
    �@VolumeShadow�p���f���ɃV���h�E�{�����[���ǉ��̃��f���ύX�����܂��B�ύX���@��VolumeShadow��readme.txt���Q�Ƃ��������B
    �AHgShadow_Header.fxh �̃p�����[�^�� WithVolumeShadow 1 �ɂ��܂��B
    �BVolumeShadow.x�ƃV���h�E�{�����[���ǉ����f����MMD�Ƀ��[�h���܂��B
    �CVolumeShadow.x�̕`�揇����HgShadow.x�̌�ɂ��Ă��������B
    �D�MMEffect�����G�t�F�N�g������̢HgS_SMap��^�u���V���h�E�{�����[���ǉ����f����I�����Ĕ�\���ݒ�ɂ��܂��B
    �E��͒ʏ��HgShadow�ݒ�Ɠ����ł��B�V���h�E�{�����[���ǉ����f���ɂ�full_HgShadow.fx��K�p���܂��B
   ��VolumeShadow�Ő������ꂽ�e�̓\�t�g�V���h�E�ŎՕ������ɉ������ڂ����������邱�Ƃ͏o���܂���B�ψ�̂ڂ����ɂȂ�܂��B



�����̃V�F�[�_�G�t�F�N�g�̉��ϕ��@�ɂ���
  �����̃V�F�[�_�G�t�F�N�g�ɑΉ�������ɂ́A�V�F�[�_�G�t�F�N�g�t�@�C���̕ύX���K�v�ɂȂ�܂��B
   �@HgShadow_ObjHeader.fxh���V�F�[�_�G�t�F�N�g�̃t�H���_�ɃR�s�[���܂��B
   �Afull_HgShadow.fx,full_HgShadow_MMM.fx�̉��ωӏ��Ɠ����ύX���e�V�F�[�_�G�t�F�N�g�ōs���܂��B
     �ύX�ӏ��ɂ��Ă�full_HgShadow.fx,full_HgShadow_MMM.fx�̃R�����g�ɏ����Ă���̂ŎQ�l�ɂ��Ă��������B



���Z�p���
�{�G�t�F�N�g�쐬�ɂ�����ȉ��̃T�C�g���Q�l�ɂ����Ă��������܂����B
LSPSM�ɂ��āFhttp://www.cg.tuwien.ac.at/research/vr/lispsm/
CSM�ɂ��āFhttp://developer.download.nvidia.com/SDK/10.5/opengl/src/cascaded_shadow_maps/doc/cascaded_shadow_maps.pdf



���X�V����
v0.0.4  2014/7/27   ������ԌŒ�V���h�E�}�b�v(CFSUSM)��ǉ�,�f�t�H�ݒ�ɂ���(CLSPSM�Ƃ̓p�����[�^�X�C�b�`�Ő؂�ւ���)
                    �����}�b�v�̋��E�t�߂��u�����h���ă}�b�v���x�����炩�ɐ��ڂ���悤�ɂ���
                    32bit��MME�ɂ����ď����p�����[�^�ŃG���[���o�Ȃ��悤�ɂ���
                    MMM�̃p�����[�^�ݒ���@�Ɋւ�������d�l�̕ύX
v0.0.3  2014/7/10   �V���h�E�}�b�v�}���`�T���v���̎�舵���̊ԈႢ���C��
                    �Օ�������@�̌������Ɛ��x����̂��߂ׂ̍����C��
                    �e�Z�x�̌v�Z���@���ďC��
v0.0.2  2014/7/5    �R���g���[�����[�t�ɂ�郂�f�����̌ʒ������o����@�\�ǉ�
                    �ڂ������̋��E���菈�����@���C��
                    �e�Z�x�̌v�Z���@���ꕔ�C��
v0.0.1  2014/6/30   ����Ō��J



���Ɛӎ���
�����p�E���ρE�񎟔z�z�͎��R�ɂ���Ă��������Ă��܂��܂���B�A�����s�v�ł��B
�����������̍s�ׂ͑S�Ď��ȐӔC�ł���Ă��������B
���̃v���O�����g�p�ɂ��A�����Ȃ鑹�Q���������ꍇ�ł������͈�؂̐ӔC�𕉂��܂���B


by �j��P
Twitter : @HariganeP


