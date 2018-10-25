appconfig={}

def initialize(env):
    """ Initialize db options """

    #JADEconfig={}
    #JADEconfig['liblist']="*LIBL"
    #JADEconfig['isCmpDs']="false"
    #appconfig['JADE']=JADEconfig
    
    JADE2config={}
    JADE2config['liblist']="*LIBL"
    JADE2config['isCmpDs']="false"
    appconfig['JADE2_']=JADE2config
    
    DMGconfig={}
    DMGconfig['liblist']="LIBCXCOM00,*LIBL"
    DMGconfig['isCmpDs']="false"
    appconfig['DMG']=DMGconfig
    
    #eDMG config
    eDMGconfig={}
    eDMGconfig['liblist']="*LIBL"
    eDMGconfig['isCmpDs']="false"
    appconfig['AS400GDMG_']=eDMGconfig
    
    #ebp config
    ebpconfig={}
    ebpconfig['liblist']="*LIBL"
    ebpconfig['isCmpDs']="false"
    appconfig['AS400EBP_']=ebpconfig
    
    
    eDMGconfig2={}
    eDMGconfig2['isCmpDs']="false"
    eDMGconfig2['currentSchema']="CARE"
    eDMGconfig2['clientProgramName']="DMG"
    appconfig['LNXGDMG_']=eDMGconfig2
    
    #ch4 config
    ch4config={}
    ch4config['liblist']="*LIBL"
    ch4config['isCmpDs']="false"
    appconfig['AS400CH4_']=ch4config
    
    ch4config2={}
    ch4config2['isCmpDs']="false"
    ch4config2['currentSchema']="CARE"
    ch4config2['clientProgramName']="CH4"
    appconfig['LNXCH4_']=ch4config2

    #mct config
    mctconfig={}
    mctconfig['liblist']="*LIBL"
    mctconfig['isCmpDs']="false"
    appconfig['AS400MCT_']=mctconfig
    
    mctconfig2={}
    mctconfig2['isCmpDs']="false"
    mctconfig2['currentSchema']="CARE"
    mctconfig2['clientProgramName']="MCT"
    appconfig['LNXMCT_']=mctconfig2
    
    #efac config AS400
    efacconfig={}
    efacconfig['liblist']="*LIBL"
    efacconfig['isCmpDs']="false"
    appconfig['AS400EFAC_']=efacconfig
    
    efacconfig2={}
    efacconfig2['isCmpDs']="false"
    efacconfig2['currentSchema']="CARE"
    efacconfig2['clientProgramName']="EFAC"
    appconfig['LNXEFAC_']=efacconfig2
    
    
    MDISconfig={}
    MDISconfig['liblist']="JADEPRF"
    MDISconfig['isCmpDs']="false"
    appconfig['MDIS']=MDISconfig
    
    TRA2config={}
    TRA2config['liblist']="*LIBL"
    TRA2config['isCmpDs']="false"
    appconfig['TRA2_']=TRA2config

    DPZconfig={}
    DPZconfig['liblist']="*LIBL"
    DPZconfig['isCmpDs']="false"
    appconfig['DPZ']=DPZconfig

    WCMconfig={}
    WCMconfig['liblist']="*LIBL"
    WCMconfig['isCmpDs']="false"
    appconfig['WCM_DS']=WCMconfig
    
    BL2config={}
    BL2config['liblist']="*LIBL"
    BL2config['isCmpDs']="false"
    BL2config['currentSchema']="DIL"
    appconfig['BL2']=BL2config

    MCA_DILconfig={}
    MCA_DILconfig['liblist']="*LIBL"
    MCA_DILconfig['isCmpDs']="false"
    MCA_DILconfig['currentSchema']="DIL"
    appconfig['MCA_DIL']=MCA_DILconfig
    
    #wsconfig={}
    #wsconfig['isCmpDs']="true"
    #appconfig['wsconfig']=wsconfig
    
    #bpeconfig={}
    #bpeconfig['isCmpDs']="false"
    #bpeconfig['currentSchema']="JBPM"
    #appconfig['BPE_']=bpeconfig

    bpe2config={}
    bpe2config['isCmpDs']="false"
    bpe2config['currentSchema']="ORC"+env
    appconfig['BPE2']=bpe2config
    
    bgl2config={}
    bgl2config['isCmpDs']="false"
    bgl2config['currentSchema']="DBBGLBGL"
    appconfig['BGL2']=bgl2config
    
    dcadmconfig={}
    dcadmconfig['isCmpDs']="false"
    dcadmconfig['currentSchema']="ADM"
    appconfig['DCADM']=dcadmconfig

    dcidxconfig={}
    dcidxconfig['isCmpDs']="false"
    dcidxconfig['currentSchema']="IDX"
    dcidxconfig['isolationLevel']="1"    
    appconfig['DCIDX']=dcidxconfig

    
#     dcadm5xxconfig={}
#     dcadm5xxconfig['isCmpDs']="false"
#     dcadm5xxconfig['currentSchema']="ADM"
#     dcadm5xxconfig['isolationLevel']="1"    
#     appconfig['DCADM5XX']=dcadm5xxconfig
    
    intgconfig={}
    intgconfig['isCmpDs']="false"
    intgconfig['currentSchema']="INTG"
    appconfig['INTG_']=intgconfig
    appconfig['INTGDPZ']=intgconfig
    appconfig['INTGDMG']=intgconfig
    
    dddconfig={}
    dddconfig['isCmpDs']="false"
    dddconfig['currentSchema']="DDD"+env
    appconfig['DDD_']=dddconfig

    bmdconfig={}
    bmdconfig['isCmpDs']="false"
    bmdconfig['currentSchema']="MONDB"+env
    appconfig['BMD']=bmdconfig
    
    stmiditconfig={}
    stmiditconfig['isCmpDs']="false"
    stmiditconfig['currentSchema']="COREADM"
    appconfig['DCADMIDIT']=stmiditconfig
    
    stmiditconfigcoreadm={}
    stmiditconfigcoreadm['isCmpDs']="false"
    stmiditconfigcoreadm['currentSchema']="COREADM"
    appconfig['IDITDS']=stmiditconfigcoreadm
    
    stmiditidxconfig={}
    stmiditidxconfig['isCmpDs']="false"
    stmiditidxconfig['currentSchema']="COREADM"
    stmiditidxconfig['isolationLevel']="1"
    appconfig['DCIDXIDIT']=stmiditidxconfig

    fitdcadmconfig={}
    fitdcadmconfig['isCmpDs']="false"
    fitdcadmconfig['currentSchema']="ADM"
    appconfig['DCADMICAT']=fitdcadmconfig

    fitdcidxconfig={}
    fitdcidxconfig['isCmpDs']="false"
    fitdcidxconfig['currentSchema']="IDX"
    fitdcidxconfig['isolationLevel']="1"    
    appconfig['DCIDXICAT']=fitdcidxconfig
    
    stmmigsconfig={}
    stmmigsconfig['isCmpDs']="false"
    stmmigsconfig['currentSchema']="MIGSYNC"
    appconfig['DCADMMIGS']=stmmigsconfig

    stmfitmigsluwconfig={}
    stmfitmigsluwconfig['isCmpDs']="false"
    stmfitmigsluwconfig['currentSchema']="MIGSYNC"
    appconfig['MIGS_5XX_LUW']=stmfitmigsluwconfig

    stmfitmigsas4config={}
    stmfitmigsas4config['isCmpDs']="false"
    stmfitmigsas4config['currentSchema']="MIGSYNC"
    stmfitmigsas4config['dateFormat']="ISO"
    stmfitmigsas4config['liblist']="*LIBL"
    stmfitmigsas4config['Naming']="system"
    stmfitmigsas4config['timeFormat']="iso"
    appconfig['MIGS_5XX_AS400']=stmfitmigsas4config

    stmsatconfig={}
    stmsatconfig['isCmpDs']="false"
    stmsatconfig['currentSchema']="ADM"
    appconfig['DCADM']=stmsatconfig
    
    stmsatidxconfig={}
    stmsatidxconfig['isCmpDs']="false"
    stmsatidxconfig['currentSchema']="IDX"
    stmsatidxconfig['isolationLevel']="1"
    appconfig['DCIDX']=stmsatidxconfig
    
    stmsatddraconfig={}
    stmsatddraconfig['isCmpDs']="false"
    stmsatddraconfig['currentSchema']="DDRA"
    appconfig['DCDDRA']=stmsatddraconfig
    
    stmsatddraconfig={}
    stmsatddraconfig['isCmpDs']="false"
    stmsatddraconfig['currentSchema']="DOH"
    appconfig['DCDOH']=stmsatddraconfig
