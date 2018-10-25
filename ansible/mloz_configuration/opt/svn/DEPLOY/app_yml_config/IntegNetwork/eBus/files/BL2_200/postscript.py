cell = AdminControl.getCell()
servers = AdminConfig.list('ApplicationServer').splitlines()
wasid = AdminConfig.getid( '/Cell:'+ cell +'/ServerCluster:{{ was_cluster_name }}/')
server = [ el for el in servers if el.find('{{ was_app_name }}') >= 0 ][0]
jdbcProviders = AdminConfig.list('JDBCProvider', wasid).splitlines()
provider = [ el for el in jdbcProviders if el.find('resources.xml#JDBCProvider_') >= 0 ][0][1:-1]

# Server-specific Application Settings: Class Loader
AdminConfig.modify(server, '[[applicationClassLoaderPolicy "SINGLE"] [applicationClassLoadingMode "PARENT_LAST"]]')
print('Server-specific Application Settings: Class Loader')

# The modify command appends the specified unique classpath or nativepath values to the existing values. To completely replace the values, you must first remove the path attributes using the unsetAttributes command.
AdminConfig.unsetAttributes(provider, '["classpath" "nativepath"]')
# Put new value
AdminConfig.modify(provider, '[[classpath "${DB2UNIVERSAL_JDBC_DRIVER_PATH}/db2jcc4.jar"] [name "DB2 Universal JDBC Driver Provider"] [implementationClassName "com.ibm.db2.jcc.DB2XADataSource"] [isolatedClassLoader "false"] [nativepath ""] [description "We use the latest jdbc DB2 driver version (JDBC 4.0). You will find it in our maven repo (Nexus) : http://nexus.sdlc.gfdi.be/nexus/content/groups/mavenx/com/ibm/db2/db2jcc4/10.5.0/db2jcc4-10.5.0.jar"]]')
print('Update driver JDBC provider')

AdminConfig.save()
