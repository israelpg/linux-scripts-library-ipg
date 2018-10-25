import servers
import apps


"""
Contain basic drivers properties
"""


driverconfig={}

nativeconfig={}
nativeconfig['JDBCProvName']="DB2 UDB for iSeries (Native - V5R2 and later)"
nativeconfig['xa_flag']="false"
nativeconfig['implementationClassName']="com.ibm.db2.jdbc.app.UDBConnectionPoolDataSource"
nativeconfig['classpath']="${OS400_NATIVE_JDBC_DRIVER_PATH}/db2_classes.jar"
nativeconfig['namingpropertyname']="systemNaming"
nativeconfig['namingpropertyvalue']="true"
nativeconfig['dsHelper']="com.ibm.websphere.rsadapter.DB2AS400DataStoreHelper"
nativeconfig['drvprops']="iseries"

driverconfig['native']=nativeconfig

#cloudscapeconfig={}
#cloudscapeconfig['JDBCProvName']="Cloudscape JDBC Provider"
#cloudscapeconfig['xa_flag']="false"
#cloudscapeconfig['implementationClassName']="com.ibm.db2j.jdbc.DB2jConnectionPoolDataSource"
#cloudscapeconfig['classpath']="${CLOUDSCAPE_JDBC_DRIVER_PATH}/db2j.jar"
#cloudscapeconfig['dsHelper']="com.ibm.websphere.rsadapter.CloudscapeDataStoreHelper"
#cloudscapeconfig['drvprops']="cloudscape"

#driverconfig['cloudscape']=cloudscapeconfig

#native_xaconfig={}
#native_xaconfig['JDBCProvName']="DB2 UDB for iSeries (Native XA - V5R2 and later)"
#native_xaconfig['xa_flag']="true"
#native_xaconfig['implementationClassName']="com.ibm.db2.jdbc.app.UDBXADataSource"
#native_xaconfig['classpath']="${OS400_NATIVE_JDBC_DRIVER_PATH}/db2_classes.jar"
#native_xaconfig['namingpropertyname']="systemNaming"
#native_xaconfig['namingpropertyvalue']="true"
#native_xaconfig['dsHelper']="com.ibm.websphere.rsadapter.DB2AS400DataStoreHelper"
#native_xaconfig['drvprops']="iseries"

#driverconfig['native_xa']=native_xaconfig

toolboxconfig={}
toolboxconfig['JDBCProvName']="DB2 UDB for iSeries (Toolbox)"
toolboxconfig['xa_flag']="false"
toolboxconfig['implementationClassName']="com.ibm.as400.access.AS400JDBCConnectionPoolDataSource"
toolboxconfig['classpath']="${OS400_TOOLBOX_JDBC_DRIVER_PATH}/jt400.jar"
toolboxconfig['namingpropertyname']="naming"
toolboxconfig['namingpropertyvalue']="system"
toolboxconfig['dsHelper']="com.ibm.websphere.rsadapter.DB2AS400DataStoreHelper"
toolboxconfig['drvprops']="iseries"

driverconfig['toolbox']=toolboxconfig

#toolbox_xaconfig={}
#toolbox_xaconfig['JDBCProvName']="DB2 UDB for iSeries (Toolbox XA)"
#toolbox_xaconfig['xa_flag']="true"
#toolbox_xaconfig['implementationClassName']="com.ibm.as400.access.AS400JDBCXADataSource"
#toolbox_xaconfig['classpath']="${OS400_TOOLBOX_JDBC_DRIVER_PATH}/jt400.jar"
#toolbox_xaconfig['namingpropertyname']="naming"
#toolbox_xaconfig['namingpropertyvalue']="system"
#toolbox_xaconfig['dsHelper']="com.ibm.websphere.rsadapter.DB2AS400DataStoreHelper"
#toolbox_xaconfig['drvprops']="iseries"

#driverconfig['toolbox_xa']=toolbox_xaconfig

universalconfig={}
universalconfig['JDBCProvName']="DB2 Universal JDBC Driver Provider"
universalconfig['xa_flag']="false"
universalconfig['implementationClassName']="com.ibm.db2.jcc.DB2ConnectionPoolDataSource"
universalconfig['classpath']="${DB2UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc.jar"
universalconfig['dsHelper']="com.ibm.websphere.rsadapter.DB2UniversalDataStoreHelper"
universalconfig['drvprops']="universal"

driverconfig['universal']=universalconfig

def setiseriesdriverprops(AdminConfig, ps, appl, type, dshost):
    """
    Function to set iSeries properties
    
    :param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
    :param ps: J2EE Resource Property Set (generate in setdriverprops in checkdatasource.py)
    :param type: Type of db connection, Toolbox, Universal, Mssql
    :param appl: targeted application
    :param dshost: config in apps.py
    """

    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'serverName'], ['value',servers.serverconfig[dshost]['serverName']], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'databaseName'], ['value',servers.serverconfig[dshost]['databaseName']], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'dataTruncation'], ['value', 'false'], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'dateFormat'], ['value', 'iso'], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'timeFormat'], ['value', 'iso'], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'libraries'], ['value', apps.appconfig[appl]['liblist']], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', driverconfig[type]['namingpropertyname']], ['value', driverconfig[type]['namingpropertyvalue']], ['type', 'java.lang.String']])
    if (appl=="DPZ") or (appl=="DMG"):
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'webSphereDefaultIsolationLevel'], ['value', 2], ['type', 'java.lang.Integer']])
    

#def setcloudscapedriverprops(AdminConfig, ps, dsnode):
#    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'databaseName'], ['value',servers.serverconfig[dsnode]['cloudscapeDbPath']], ['type', 'java.lang.String']])

def setuniversaldriverprops(AdminConfig, ps, appl, dshost, dsmapdb):
    """
    Function to set Universal properties
    
    :param AdminConfig: Obj retrieve by execute '/data/wsadmin/share/procs/wsadminlib.py'
    :param ps: J2EE Resource Property Set (generate in setdriverprops in checkdatasource.py)
    :param appl: targeted application
    :param dshost: config in apps.py
    :param dsmapdb: db name
    """

    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'serverName'], ['value', servers.serverconfig[dshost]['serverName']], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'databaseName'], ['value', dsmapdb], ['type', 'java.lang.String']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'driverType'], ['value', 4], ['type', 'java.lang.Integer']])
    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'portNumber'], ['value', servers.serverconfig[dshost]['dsPort']], ['type', 'java.lang.Integer']])
    try:
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'webSphereDefaultIsolationLevel'], ['value', apps.appconfig[appl]['isolationLevel']], ['type', 'java.lang.Integer']])
    except KeyError:
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'webSphereDefaultIsolationLevel'], ['value', 2], ['type', 'java.lang.Integer']])
#    AdminConfig.create('J2EEResourceProperty', ps, [['name', 'portNumber'], ['value', 446], ['type', 'java.lang.Integer']])
    try:    
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'currentSchema'], ['value', apps.appconfig[appl]['currentSchema']], ['type', 'java.lang.String']])
    except KeyError:
	pass    	 
    try:    
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'clientRerouteAlternateServerName'], ['value', servers.serverconfig[dshost]['altServerName']], ['type', 'java.lang.String']])
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'clientRerouteAlternatePortNumber'], ['value', servers.serverconfig[dshost]['altDsPort']], ['type', 'java.lang.Integer']])
    except KeyError:
    	pass
    try:    
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'extendedDynamic'], ['value', apps.appconfig[appl]['extendedDynamic']], ['type', 'java.lang.String']])
    except KeyError:
	pass    	 
    try:    
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'package'], ['value', apps.appconfig[appl]['package']], ['type', 'java.lang.String']])
    except KeyError:
	pass    	 
    try:    
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'packageLibrary'], ['value', apps.appconfig[appl]['packageLibrary']], ['type', 'java.lang.String']])
    except KeyError:
	pass    	 
    try:    
        AdminConfig.create('J2EEResourceProperty', ps, [['name', 'packageCriteria'], ['value', apps.appconfig[appl]['packageCriteria']], ['type', 'java.lang.String']])
    except KeyError:
	pass    	 
    	 

