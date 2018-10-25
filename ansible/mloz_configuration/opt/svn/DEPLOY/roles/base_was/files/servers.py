"""
This Python file contain all configuration for servers.

There's no function here, just the big dictionary 'serverconfig'.
"""

serverconfig={}

# BL2 config
udbbl2_105config={}
udbbl2_105config['serverName']="s998jrlnx083.ref.cpc998.be"
udbbl2_105config['dsPort']=50004
serverconfig['udbbl2105']=udbbl2_105config


#iSeries
airbusconfig={}
airbusconfig['databaseName']="AIRBUS"
airbusconfig['serverName']="airbus.jablux.cpc998.be"
airbusconfig['minconn']=0
airbusconfig['maxconn']=30
airbusconfig['timeout']=7200
serverconfig['AIRBUS']=airbusconfig

refconfig={}
refconfig['databaseName']="REFGFDI"
refconfig['serverName']="ref.ref.cpc998.be"
refconfig['minconn']=0
refconfig['maxconn']=30
refconfig['timeout']=7200
serverconfig['REF']=refconfig

darwinconfig={}
darwinconfig['databaseName']="DARWIN"
darwinconfig['serverName']="darwin.beagle.cpc998.be"
darwinconfig['minconn']=0
darwinconfig['maxconn']=30
darwinconfig['timeout']=7200
serverconfig['DARWIN']=darwinconfig

alphaconfig={}
alphaconfig['databaseName']="GFDIDB2"
alphaconfig['serverName']="s44g5036.gfdi.be"
serverconfig['ALPHA']=alphaconfig

betaconfig={}
betaconfig['databaseName']="BETAGFDI"
betaconfig['serverName']="s444b58a.gfdi.be"
betaconfig['minconn']=0
betaconfig['maxconn']=20
betaconfig['timeout']=3600
serverconfig['BETA']=betaconfig

itgconfig={}
itgconfig['databaseName']="ITGGFDI"
itgconfig['serverName']="s999fitios102.steam.gfdi.be"
itgconfig['minconn']=0
itgconfig['maxconn']=20
itgconfig['timeout']=3600
serverconfig['ITG']=itgconfig

testconfig={}
testconfig['databaseName']="TESTGFDI"
testconfig['serverName']="test.gfdi.be"
testconfig['minconn']=0
testconfig['maxconn']=20
testconfig['timeout']=3600
serverconfig['TEST']=testconfig

#DB2 Teams

#procomconfig={}
#procomconfig['serverName']="procomdb.jablux.gfdi.be"
#serverconfig['procomdb']=procomconfig

#doccendbconfig={}
#doccendbconfig['serverName']="doccendb.gfdi.be"
#serverconfig['doccendb']=doccendbconfig

udbiacc97config={}
udbiacc97config['serverName']="s999lnx68.gfdi.be"
udbiacc97config['dsPort']=50004
serverconfig['udbiacc97']=udbiacc97config

udbicom97config={}
udbicom97config['serverName']="s999lnx68.gfdi.be"
udbicom97config['dsPort']=50008
serverconfig['udbicom97']=udbicom97config

udbiteams97config={}
udbiteams97config['serverName']="s999jdlnx105.teams.gfdi.be"
udbiteams97config['dsPort']=50004
serverconfig['udbiteams97']=udbiteams97config

#udbifar97config={}
#udbifar97config['serverName']="s999lnx68.gfdi.be"
#udbifar97config['dsPort']=50012
#serverconfig['udbifar97']=udbifar97config

#udbiind97config={}
#udbiind97config['serverName']="s999lnx68.gfdi.be"
#udbiind97config['dsPort']=50016
#serverconfig['udbiind97']=udbiind97config

udbimed97config={}
udbimed97config['serverName']="s999lnx68.gfdi.be"
udbimed97config['dsPort']=50020
serverconfig['udbimed97']=udbimed97config

udbitar97config={}
udbitar97config['serverName']="s999lnx68.gfdi.be"
udbitar97config['dsPort']=50024
serverconfig['udbitar97']=udbitar97config

udbifoa97config={}
udbifoa97config['serverName']="s999lnx68.gfdi.be"
udbifoa97config['dsPort']=50028
serverconfig['udbifoa97']=udbifoa97config

#DB2 PreProduction

udbialf97config={}
udbialf97config['serverName']="db2-alpha03.jablux.gfdi.be"
udbialf97config['dsPort']=50004
#udbialf97config['altServerName']="db2-alpha04.jablux.gfdi.be"
#udbialf97config['altDsPort']=50004
serverconfig['udbialf97']=udbialf97config

dddialfconfig={}
dddialfconfig['serverName']="db2-alpha03.jablux.gfdi.be"
dddialfconfig['dsPort']=50004
#dddialfconfig['altServerName']="db2-alpha04.jablux.gfdi.be"
#dddialfconfig['altDsPort']=50004
serverconfig['dddialf']=dddialfconfig

udbialt97config={}
udbialt97config['serverName']="db2-alpha04.jablux.gfdi.be"
udbialt97config['dsPort']=50008
#udbialt97config['altServerName']="db2-alpha03.jablux.gfdi.be"
#udbialt97config['altDsPort']=50008
serverconfig['udbialt97']=udbialt97config

dddialtconfig={}
dddialtconfig['serverName']="db2-alpha04.jablux.gfdi.be"
dddialtconfig['dsPort']=50008
#dddialtconfig['altServerName']="db2-alpha03.jablux.gfdi.be"
#dddialtconfig['altDsPort']=50008
serverconfig['dddialt']=dddialtconfig

udbibet97config={}
udbibet97config['serverName']="db2-beta03.jablux.gfdi.be"
udbibet97config['dsPort']=50004
udbibet97config['altServerName']="db2-beta04.jablux.gfdi.be"
udbibet97config['altDsPort']=50004
udbibet97config['minconn']=0
udbibet97config['maxconn']=20
udbibet97config['timeout']=3600
serverconfig['udbibet97']=udbibet97config

udbistmfit105config={}
udbistmfit105config['serverName']="fit-db2-02.steam.gfdi.be"
udbistmfit105config['dsPort']=50004
udbistmfit105config['minconn']=0
udbistmfit105config['maxconn']=20
udbistmfit105config['timeout']=3600
udbistmfit105config['resultSetHoldability']=1
serverconfig['stmfit105']=udbistmfit105config

udbistmref105config={}
udbistmref105config['serverName']="s998jraix020.ref.cpc998.be"
udbistmref105config['dsPort']=50004
udbistmref105config['minconn']=0
udbistmref105config['maxconn']=20
udbistmref105config['timeout']=3600
udbistmref105config['resultSetHoldability']=1
udbistmref105config['altServerName']="s998jraix019.ref.cpc998.be"
serverconfig['stmref105']=udbistmref105config

udbifit97config={}
udbifit97config['serverName']="fit-db2-01.steam.gfdi.be"
udbifit97config['dsPort']=50004
udbifit97config['minconn']=0
udbifit97config['maxconn']=20
udbifit97config['timeout']=3600
serverconfig['udbifit97']=udbifit97config

dddibetconfig={}
dddibetconfig['serverName']="db2-beta03.jablux.gfdi.be"
dddibetconfig['dsPort']=50004
dddibetconfig['altServerName']="db2-beta04.jablux.gfdi.be"
dddibetconfig['altDsPort']=50004
serverconfig['dddibet']=dddibetconfig

udbicpk97config={}
udbicpk97config['serverName']="db2-corpak03.jablux.gfdi.be"
udbicpk97config['dsPort']=50004
udbicpk97config['altServerName']="db2-corpak04.jablux.gfdi.be"
udbicpk97config['altDsPort']=50004
serverconfig['udbicpk97']=udbicpk97config

dddicpkconfig={}
dddicpkconfig['serverName']="db2-corpak03.jablux.gfdi.be"
dddicpkconfig['dsPort']=50004
dddicpkconfig['altServerName']="db2-corpak04.jablux.gfdi.be"
dddicpkconfig['altDsPort']=50004
serverconfig['dddicpk']=dddicpkconfig

udbitst97config={}
udbitst97config['serverName']="db2-test03.jablux.gfdi.be"
udbitst97config['dsPort']=50004
udbitst97config['altServerName']="db2-test04.jablux.gfdi.be"
udbitst97config['altDsPort']=50004
udbitst97config['minconn']=0
udbitst97config['maxconn']=20
udbitst97config['timeout']=3600
serverconfig['udbitst97']=udbitst97config

#DB2 Production

udbicat297config={}
udbicat297config['serverName']="db2-cat200prd.jablux.cpc998.be"
udbicat297config['dsPort']=50004
udbicat297config['altServerName']="db2-cat200drp.jablux.cpc998.be"
udbicat297config['altDsPort']=50004
udbicat297config['minconn']=0
udbicat297config['maxconn']=30
udbicat297config['timeout']=7200
serverconfig['udbicat297']=udbicat297config

udbicat497config={}
udbicat497config['serverName']="db2-cat400prd.jablux.cpc998.be"
udbicat497config['dsPort']=50004
udbicat497config['altServerName']="db2-cat400drp.jablux.cpc998.be"
udbicat497config['altDsPort']=50004
udbicat497config['minconn']=0
udbicat497config['maxconn']=30
udbicat497config['timeout']=7200
serverconfig['udbicat497']=udbicat497config

udbicat597config={}
udbicat597config['serverName']="db2-cat500prd.jablux.cpc998.be"
udbicat597config['dsPort']=50004
udbicat597config['altServerName']="db2-cat500drp.jablux.cpc998.be"
udbicat597config['altDsPort']=50004
udbicat597config['minconn']=0
udbicat597config['maxconn']=30
udbicat597config['timeout']=7200
serverconfig['udbicat597']=udbicat597config

udbicatf97config={}
udbicatf97config['serverName']="s998jplnx096.jablux.cpc998.be"
udbicatf97config['dsPort']=50004
serverconfig['udbicatf97']=udbicatf97config

udbiint297config={}
udbiint297config['serverName']="db2-int200prd.jablux.cpc998.be"
udbiint297config['dsPort']=50004
udbiint297config['altServerName']="db2-int200drp.jablux.cpc998.be"
udbiint297config['altDsPort']=50004
serverconfig['udbiint297']=udbiint297config

udbiint497config={}
udbiint497config['serverName']="db2-int400prd.jablux.cpc998.be"
udbiint497config['dsPort']=50004
udbiint497config['altServerName']="db2-int400drp.jablux.cpc998.be"
udbiint497config['altDsPort']=50004
serverconfig['udbiint497']=udbiint497config

udbiint597config={}
udbiint597config['serverName']="db2-int500prd.jablux.cpc998.be"
udbiint597config['dsPort']=50004
udbiint597config['altServerName']="db2-int500drp.jablux.cpc998.be"
udbiint597config['altDsPort']=50004
serverconfig['udbiint597']=udbiint597config

udbiintf97config={}
udbiintf97config['serverName']="s998jplnx096.jablux.cpc998.be"
udbiintf97config['dsPort']=50008
serverconfig['udbiintf97']=udbiintf97config

udbiorc297config={}
udbiorc297config['serverName']="db2-orc200prd.jablux.cpc998.be"
udbiorc297config['dsPort']=50004
udbiorc297config['altServerName']="db2-orc200drp.jablux.cpc998.be"
udbiorc297config['altDsPort']=50004
serverconfig['udbiorc297']=udbiorc297config

udbiorc497config={}
udbiorc497config['serverName']="db2-orc400prd.jablux.cpc998.be"
udbiorc497config['dsPort']=50004
udbiorc497config['altServerName']="db2-orc400drp.jablux.cpc998.be"
udbiorc497config['altDsPort']=50004
serverconfig['udbiorc497']=udbiorc497config

udbiorc597config={}
udbiorc597config['serverName']="db2-orc500prd.jablux.cpc998.be"
udbiorc597config['dsPort']=50004
udbiorc597config['altServerName']="db2-orc500drp.jablux.cpc998.be"
udbiorc597config['altDsPort']=50004
serverconfig['udbiorc597']=udbiorc597config

udbiorcf97config={}
udbiorcf97config['serverName']="s998jplnx096.jablux.cpc998.be"
udbiorcf97config['dsPort']=50012
serverconfig['udbiorcf97']=udbiorcf97config

udbiddd2config={}
udbiddd2config['serverName']="db2-orcrpgprd.jablux.cpc998.be"
udbiddd2config['dsPort']=50004
udbiddd2config['altServerName']="db2-orcrpgdrp.jablux.cpc998.be"
udbiddd2config['altDsPort']=50004
serverconfig['udbiddd2']=udbiddd2config

udbiddd4config={}
udbiddd4config['serverName']="db2-orcrpgprd.jablux.cpc998.be"
udbiddd4config['dsPort']=50008
udbiddd4config['altServerName']="db2-orcrpgdrp.jablux.cpc998.be"
udbiddd4config['altDsPort']=50008
serverconfig['udbiddd4']=udbiddd4config

udbiddd5config={}
udbiddd5config['serverName']="db2-orcrpgprd.jablux.cpc998.be"
udbiddd5config['dsPort']=50012
udbiddd5config['altServerName']="db2-orcrpgdrp.jablux.cpc998.be"
udbiddd5config['altDsPort']=50012
serverconfig['udbiddd5']=udbiddd5config

udbidddfconfig={}
udbidddfconfig['serverName']="db2-orcrpgprd.jablux.cpc998.be"
udbidddfconfig['dsPort']=50016
serverconfig['udbidddf']=udbidddfconfig

udbibmdconfig={}
udbibmdconfig['serverName']="db2-bmdprd.jablux.cpc998.be"
udbibmdconfig['dsPort']=50004
udbibmdconfig['altServerName']="db2-bmddrp.jablux.cpc998.be"
udbibmdconfig['altDsPort']=50004
serverconfig['udbibmd']=udbibmdconfig

#DB2 AIX production

udbaixidit2105config={}
udbaixidit2105config['serverName']="db2-sap200prd.steam.cpc998.be"
udbaixidit2105config['dsPort']=50004
udbaixidit2105config['altServerName']="db2-sap200drp.steam.cpc998.be"
udbaixidit2105config['altDsPort']=50004
udbaixidit2105config['minconn']=0
udbaixidit2105config['maxconn']=30
udbaixidit2105config['timeout']=7200
serverconfig['udbicat297']=udbaixidit2105config

# DB2 AIX beagle
# IDIT 5xx
udbaixidit5105bconfig={}
udbaixidit5105bconfig['serverName']="s998jbaix032.beagle.cpc998.be"
udbaixidit5105bconfig['dsPort']=50004
udbaixidit5105bconfig['minconn']=0
udbaixidit5105bconfig['maxconn']=30
udbaixidit5105bconfig['timeout']=7200
serverconfig['udbidit5105b']=udbaixidit5105bconfig


# DB2 AIX production
# IDIT 5xx
udbaixidit5105config={}
udbaixidit5105config['serverName']="s998jpaix012.steam.cpc998.be"
udbaixidit5105config['dsPort']=50004
udbaixidit5105config['altServerName']="s998jpaix011.steam.cpc998.be"
udbaixidit5105config['altDsPort']=50004
udbaixidit5105config['minconn']=0
udbaixidit5105config['maxconn']=30
udbaixidit5105config['timeout']=7200
serverconfig['udbidit5105']=udbaixidit5105config

# MIGS 5xx
udbaixmigs5105config={}
udbaixmigs5105config['serverName']="s998jpaix012.steam.cpc998.be"
udbaixmigs5105config['dsPort']=50004
udbaixmigs5105config['altServerName']="s998jpaix011.steam.cpc998.be"
udbaixmigs5105config['altDsPort']=50004
udbaixmigs5105config['minconn']=0
udbaixmigs5105config['maxconn']=30
udbaixmigs5105config['timeout']=7200
serverconfig['udbmigs5105']=udbaixmigs5105config

# BL2 5xx
udbaixbl25105config={}
udbaixbl25105config['serverName']="s998jpaix026.steam.cpc998.be"
udbaixbl25105config['dsPort']=50004
udbaixbl25105config['minconn']=0
udbaixbl25105config['maxconn']=30
udbaixbl25105config['timeout']=7200
serverconfig['udbbl25105']=udbaixbl25105config

#DB2 Reference

reficat297config={}
reficat297config['serverName']="db2-cat200.ref.cpc998.be"
reficat297config['dsPort']=50004
reficat297config['minconn']=0
reficat297config['maxconn']=30
reficat297config['timeout']=7200
serverconfig['reficat297']=reficat297config

reficat497config={}
reficat497config['serverName']="db2-cat400.ref.cpc998.be"
reficat497config['dsPort']=50004
reficat497config['minconn']=0
reficat497config['maxconn']=30
reficat497config['timeout']=7200
serverconfig['reficat497']=reficat497config

reficat597config={}
reficat597config['serverName']="db2-cat500.ref.cpc998.be"
reficat597config['dsPort']=50004
reficat597config['minconn']=0
reficat597config['maxconn']=30
reficat597config['timeout']=7200
serverconfig['reficat597']=reficat597config

refiint297config={}
refiint297config['serverName']="db2-int200.ref.cpc998.be"
refiint297config['dsPort']=50004
serverconfig['refiint297']=refiint297config

refiint497config={}
refiint497config['serverName']="db2-int400.ref.cpc998.be"
refiint497config['dsPort']=50004
serverconfig['refiint497']=refiint497config

refiint597config={}
refiint597config['serverName']="db2-int500.ref.cpc998.be"
refiint597config['dsPort']=50004
serverconfig['refiint597']=refiint597config

refiorc297config={}
refiorc297config['serverName']="db2-orc200.ref.cpc998.be"
refiorc297config['dsPort']=50004
serverconfig['refiorc297']=refiorc297config

refiorc497config={}
refiorc497config['serverName']="db2-orc400.ref.cpc998.be"
refiorc497config['dsPort']=50004
serverconfig['refiorc497']=refiorc497config

refiorc597config={}
refiorc597config['serverName']="db2-orc500.ref.cpc998.be"
refiorc597config['dsPort']=50004
serverconfig['refiorc597']=refiorc597config

udbibmdrconfig={}
udbibmdrconfig['serverName']="db2-bmd.ref.cpc998.be"
udbibmdrconfig['dsPort']=50004
serverconfig['udbibmdr']=udbibmdrconfig

#DB2 DMG ref

udbidmg597config={}
udbidmg597config['serverName']="iobe-pil-db2-01.ref.cpc998.be"
udbidmg597config['dsPort']=50004
udbidmg597config['altServerName']="iobe-pil-db2-02.ref.cpc998.be"
udbidmg597config['altDsPort']=50004
serverconfig['udbidmg597']=udbidmg597config

#DB2 DMG Prod 500
udbidmg5config={}
udbidmg5config['serverName']="iobe-prod-db2-01.jablux.cpc998.be"
udbidmg5config['dsPort']=50016
udbidmg5config['altServerName']="iobe-prod-db2-02.jablux.cpc998.be"
udbidmg5config['altDsPort']=50016
serverconfig['udbidmg5']=udbidmg5config

#DB2 DMG DRP 500
udbidmg5drpconfig={}
udbidmg5drpconfig['serverName']="iobe-prod-db2-02.jablux.cpc998.be"
udbidmg5drpconfig['dsPort']=50016
udbidmg5drpconfig['altServerName']="iobe-prod-db2-01.jablux.cpc998.be"
udbidmg5drpconfig['altDsPort']=50016
serverconfig['udbidmg5drp']=udbidmg5drpconfig

#DB2 DMG Prod 200
udbidmg2config={}
udbidmg2config['serverName']="iobe-prod-db2-01.jablux.cpc998.be"
udbidmg2config['dsPort']=50008
udbidmg2config['altServerName']="iobe-prod-db2-02.jablux.cpc998.be"
udbidmg2config['altDsPort']=50008
serverconfig['udbidmg2']=udbidmg2config

#DB2 DMG DRP 200
udbidmg2drpconfig={}
udbidmg2drpconfig['serverName']="iobe-prod-db2-02.jablux.cpc998.be"
udbidmg2drpconfig['dsPort']=50008
udbidmg2drpconfig['altServerName']="iobe-prod-db2-01.jablux.cpc998.be"
udbidmg2drpconfig['altDsPort']=50008
serverconfig['udbidmg2drp']=udbidmg2drpconfig

#DB2 DMG Prod 400
udbidmg4config={}
udbidmg4config['serverName']="iobe-prod-db2-01.jablux.cpc998.be"
udbidmg4config['dsPort']=50012
udbidmg4config['altServerName']="iobe-prod-db2-02.jablux.cpc998.be"
udbidmg4config['altDsPort']=50012
serverconfig['udbidmg4']=udbidmg4config

#DB2 DMG DRP 400
udbidmg4drpconfig={}
udbidmg4drpconfig['serverName']="iobe-prod-db2-02.jablux.cpc998.be"
udbidmg4drpconfig['dsPort']=50012
udbidmg4drpconfig['altServerName']="iobe-prod-db2-01.jablux.cpc998.be"
udbidmg4drpconfig['altDsPort']=50012
serverconfig['udbidmg4drp']=udbidmg4drpconfig

#DB2 ch4 TST

udbch4597config={}
udbch4597config['serverName']="db2-nippin01.jablux.gfdi.be"
udbch4597config['dsPort']=50020
udbch4597config['altServerName']="db2-nippin02.jablux.gfdi.be"
udbch4597config['altDsPort']=50020
serverconfig['udbich4597']=udbch4597config



#DB2 Beagle

beagleicat597config={}
beagleicat597config['serverName']="db2-cat500.beagle.cpc998.be"
beagleicat597config['dsPort']=50004
beagleicat597config['minconn']=0
beagleicat597config['maxconn']=30
beagleicat597config['timeout']=7200
serverconfig['beagleicat597']=beagleicat597config

beagleiint597config={}
beagleiint597config['serverName']="db2-int500.beagle.cpc998.be"
beagleiint597config['dsPort']=50004
serverconfig['beagleiint597']=beagleiint597config

beagleiorc597config={}
beagleiorc597config['serverName']="db2-orc500.beagle.cpc998.be"
beagleiorc597config['dsPort']=50004
serverconfig['beagleiorc597']=beagleiorc597config

beagleiddd5config={}
beagleiddd5config['serverName']="db2-orcrpg.beagle.cpc998.be"
beagleiddd5config['dsPort']=50012
serverconfig['beagleiddd5']=beagleiddd5config

beagleibmdconfig={}
beagleibmdconfig['serverName']="db2-bmd.beagle.cpc998.be"
beagleibmdconfig['dsPort']=50004
serverconfig['beagleibmd']=beagleibmdconfig
