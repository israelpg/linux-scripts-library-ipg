sys.path.append('/data/wsadmin/servers')
from was_libraries import *

OWNER = '{{ owner }}'
GROUP = '{{ group }}'
CELL = AdminControl.getCell()
SERVERS = AdminConfig.list('Server').splitlines()
WAS = {
# process execution
{% if process_exec %}
    'process_exec': {{ process_exec }},
{% endif %}
# base & generic value
    'base_node_name':  '{{ base_node_name }}',
    'ws_application_server': '{{ was_app_name }}',
    'server_id': '/Cell:%s/Node:{{ base_node_name }}/Server:{{ was_app_name }}/' % CELL,
{% if was_cluster_name %}
    'cluster_id': '/Cell:%s/ServerCluster:{{ was_cluster_name }}/' % CELL,
    'scope': 'Cluster={{ was_cluster_name }}',
    'app': '{{ was_cluster_name }}',
    'clustered': 1,
{% else %}
    'cluster_id': None,
    'scope': 'Node={{ base_node_name }},Server={{ was_app_name }}',
    'app': '{{ was_app_name }}',
    'clustered': 0,
{% endif %}
    'resourceEnvProvider': [ 'fwk2-config-jndi', 'config_jndi.jar' ],
    'path': '{{ path }}',
##
# resoucre EnvEntries
{% if resourceEnvEntries %}
    'resourceEnvEntries': {{ resourceEnvEntries }},
{% endif %}
##
# Jvm Properties
    'systemProperties': [
        { 'name': 'java.net.preferIPv4Stack', 'value': 'true' },
        { 'name': 'java.awt.headless', 'value': 'true' },
{% if systemProperties %}{% for el in systemProperties %}
        { 'name': '{{ el.name }}', 'value': '{{ el.value }}' },
{% endfor %}{% endif %}
    ],
##
# Vhost & Alias
{% if vhost %}
    'vhost': '{{ vhost }}',
{% elif not vhost and not was_cluster_name %}
    'vhost': '{{ was_app_name }}_vhost',
{% elif not vhost and was_cluster_name %}
    'vhost': '{{ was_cluster_name }}_vhost',
{% else %}
    'vhost': 'default_host',
{% endif %}
    'aliases': [
        { 'hostname': '{{ ansible_fqdn }}', 'port': '{{ default_port }}' },
{% if host_aliases %}{% for el in host_aliases %}
        { 'hostname': '{{ el.hostname }}', 'port': '{{ el.port }}' },
{% endfor %}{% endif %}
    ],
##
# JMS MQ
{% if mqjms %}
{% if was_cluster_name %}
    'jmsprov': '/ServerCluster:{{ was_cluster_name }}/JMSProvider:WebSphere MQ JMS Provider/',
{% else %}
    'jmsprov': '/Node:{{ base_node_name }}/Server:{{ was_app_name }}/JMSProvider:WebSphere MQ JMS Provider/',
{% endif %}
    'mqjms': {{ mqjms }},
{% endif %}
##
# JMS CF
{% if jmscf %}
    'jmscf': {{ jmscf }},
{% endif %}
##
# JMS Q
{% if jmsq %}
    'jmsq': {{ jmsq }},
{% endif %}
##
# DataSources
{% if dataSources %}
    'dataSources': [
{% for el in dataSources %}
        {
{% for key,val in el.items() %}
{% if key != 'connectionPool' %}
            '{{ key }}': '{% if val == True and val != 1 %}true{% elif val == False and val != 0 %}false{% else %}{{ val }}{% endif %}',
{% else %}
            '{{ key }}': {{ val }},
{% endif %}
{% endfor %}
        },
{% endfor %}
    ],
{% endif %}
##
# HTTPOnly Cookie
    'httponlycookie': '{% if cookiesHTTPOnly is not defined or cookiesHTTPOnly %}true{% else %}false{% endif %}',
##
# Namespace Bindings
{% if namespaceBindings %}
    'namespaceBindings': {{ namespaceBindings }},
{% endif %}
##
# WebContainer Properties
{% if webcntr_prop %}
    'webcntr_prop': {{ webcntr_prop }},
{% endif %}
##
# Time Manager
{% if timerManager %}
    'timerManager': {{ timerManager }},
{% endif %}
##
# Work Manager
{% if workManager %}
    'workManager': [
{% for el in workManager %}
        {
{% for key,val in el.items() %}
            '{{ key }}': '{% if val == True %}true{% elif val == False and val != 0 %}false{% else %}{{ val }}{% endif %}',
{% endfor %}
        },
{% endfor %}
    ],
{% endif %}
##
# Scheduler
{% if scheduler %}
    'scheduler': [
{% for el in scheduler %}
        {
{% for key,val in el.items() %}
            '{{ key }}': '{% if val == True %}true{% elif val == False and val != 0 %}false{% else %}{{ val }}{% endif %}',
{% endfor %}
        },
{% endfor %}
    ]
{% endif %}
##
}


def get_name(jndiName):
    """ get Name from jndiName """
#     jndiName = jndiName.split('/')
#
#     if len(jndiName) == 2:
#         _, name = jndiName
#     elif len(jndiName) > 2:
#         name = '_'.join(jndiName)
#     else:
#         name = 'NotDefined'

    return jndiName.split('/')[-1]


def set_webcntr_prop():
    """ WebContainer Properties """
    if 'webcntr_prop' not in WAS.keys(): return

    for el in WAS['webcntr_prop']:
        get_or_create_webcntr(WAS['server_id'], **el)


def set_resource_entries():
    """ Create Resource Env Entries """                                                     # create envProvider for envEntries
    provider, referc = get_or_create_env_provider(WAS['server_id'], WAS['path'], *WAS['resourceEnvProvider'])

    if 'resourceEnvEntries' not in WAS.keys(): return

    for entry in WAS['resourceEnvEntries']:
        env_entry = get_or_create_env_entries(WAS['server_id'], provider, referc, **entry)  # create envEntries
        for prop in entry['customprop']:
            set_custom_prop_entry(env_entry, **prop)                             # set extra properties to envEntry


def set_jvm_system_properties():
    """ JVM System Properties """
    if 'systemProperties' not in WAS.keys(): return

    server = [ s for s in SERVERS if s.startswith(WAS['ws_application_server']) ][0]        # get server
    jvm = AdminConfig.list('JavaVirtualMachine', server)                                    # get jvm of server
    for p in WAS['systemProperties']:
        set_jvm_prop(jvm, **p)                                      # set systemProperties to jvm


def set_vhost_aliases():
    """ Vhost & Aliases """
    webcontainer = AdminConfig.list('WebContainer', AdminConfig.getid(WAS['server_id'])).splitlines()
    webcontainer = [ el for el in webcontainer if el.find(WAS['ws_application_server']) >= 0 ][0]

    get_or_create_vhost('/Cell:%s/' % CELL, WAS['vhost'])

    for alias in WAS['aliases']:
        id = '/Cell:%s/VirtualHost:%s/' % (CELL, WAS['vhost'])
        create_alias(id, **alias)

    AdminConfig.modify(webcontainer, '[[defaultVirtualHostName "%s"]]' % (WAS['vhost']))
    msg = '%s linked to vhost %s' % (WAS['ws_application_server'], WAS['vhost'])
    print(msg)


def set_jms_mq():
    """ JMS MQ """
    if 'mqjms' not in WAS.keys(): return

    for el in WAS['mqjms']:
        if 'authDataAlias' in el.keys() and 'user' not in el.keys(): _, el['user'] = el['authDataAlias'].split('/')
        if 'name' not in el.keys(): el['name'] = get_name(el['jndiName'])
        create_mqjms(WAS['jmsprov'], **el)


def set_jms_cf():
    """ JMS Connection Factory """
    if 'jmscf' not in WAS.keys(): return

    for el in WAS['jmscf']:
        if 'name' not in el.keys(): el['name'] = get_name(el['jndiName'])
        if 'authDataAlias' in el.keys() and 'user' not in el.keys(): _, el['user'] = el['authDataAlias'].split('/')

        id = WAS['server_id']
        if WAS['clustered']: id = WAS['cluster_id']

        obj = get_or_create_jmsCF(id, **el)
        set_props_jmscf(obj, **el)
        jaas = create_jaas(**el)
        set_auth(obj, jaas)


def set_jms_q():
    """ JMS Queues """
    if 'jmsq' not in WAS.keys(): return

    for el in WAS['jmsq']:
        if 'name' not in el.keys(): el['name'] = get_name(el['jndiName'])
        id = WAS['server_id']
        if WAS['clustered']: id = WAS['cluster_id']
        get_or_create_jmsQueue(id, **el)


def set_dataSources():
    """ DataSources """
    if 'dataSources' not in WAS.keys(): return

    for el in WAS['dataSources']:
        if 'authDataAlias' in el.keys() and 'user' not in el.keys(): _, el['user'] = el['authDataAlias'].split('/')
        if 'name' not in el.keys(): el['name'] = get_name(el['jndiName'])

        id = WAS['server_id']
        if WAS['clustered']: id = WAS['cluster_id']

        provider = get_or_create_jdbc_prov(el['typeds'], WAS['scope'], id)
        datasource = get_or_create_datasources(CELL, provider, WAS['app'], WAS['cluster_id'], WAS['server_id'], **el)

        update_ds_properties(datasource, **el)

        jaas = create_jaas(**el)
        set_auth(datasource, jaas)


def set_httponlycookie():
    """ HTTPOnly Cookie """
    set_or_unset_httponlycookie(**WAS)


def set_namespaceBindings():
    """ Namespace Bindings """
    if 'namespaceBindings' not in WAS.keys(): return

    id = WAS['server_id']
    if WAS['clustered']: id = WAS['cluster_id']

    for el in WAS['namespaceBindings']:
        get_or_create_nameSpaceBinding(id, **el)


def set_timeManager():
    """ Time Manager """
    if 'timerManager' not in WAS.keys(): return

    id = WAS['server_id']
    if WAS['clustered']: id = WAS['cluster_id']

    for el in WAS['timerManager']:
        get_or_create_timeManager(id, **el)


def set_workManager():
    """ Work Manager """
    if 'workManager' not in WAS.keys(): return

    id = WAS['server_id']
    if WAS['clustered']: id = WAS['cluster_id']

    for el in WAS['workManager']:
        get_or_create_workManager(id, el)


def set_scheduler():
    """ set Scheduler JDBC """
    if 'scheduler' not in WAS.keys(): return

    id = WAS['server_id']
    if WAS['clustered']: id = WAS['cluster_id']

    for el in WAS['scheduler']:
        get_or_create_scheduler(id, el)


def set_process_exec():
    """ set process execution jvm properties """
    if 'process_exec' not in WAS.keys():
        process_exec = {}
    else:
        process_exec = WAS['process_exec']
    if 'runAsUser' not in process_exec.keys(): process_exec['runAsUser'] = OWNER
    if 'runAsGroup' not in process_exec.keys(): process_exec['runAsGroup'] = GROUP
    set_process_exec_opts(WAS['server_id'], **process_exec)


def main():
    """ where we start everything """
    print('\n### %s' % WAS['ws_application_server'])
    set_process_exec()
    set_resource_entries()
    set_jvm_system_properties()
    set_vhost_aliases()
    set_jms_mq()
    set_jms_cf()
    set_jms_q()
    set_dataSources()
    set_httponlycookie()
    set_namespaceBindings()
    set_webcntr_prop()
    set_timeManager()
    set_workManager()
    set_scheduler()

    AdminConfig.save() # save configuration


if __name__ == '__main__':
    main()
