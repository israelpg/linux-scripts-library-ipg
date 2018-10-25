def main():
    """ This script synchronize all nodes of the environment """
    nodes = '*:*,type=ConfigRepository,process=nodeagent'
    nodes = AdminControl.queryNames(nodes).splitlines()

    for node in nodes:
        AdminControl.invoke(node, 'refreshRepositoryEpoch')

        node = [ el for el in node.split(',') if el.find('node=') >= 0 ][0]
        node = node.split('=')[-1]

        v = 'type=Server,name=nodeagent,node=%s,*' % node
        v = AdminControl.completeObjectName(v)
        v = [ el for el in v.split(',') if el.startswith('version') ][0]
        v = v.split('=')[-1]

        sync = [ 'WebSphere:name=cellSync',
            'process=dmgr',
            'platform=common',
            'node=%s' % AdminControl.getNode(),
            'version=%s' % v,
            'type=CellSync',
            'mbeanIdentifier=cellSync',
            'cell=%s' % AdminControl.getCell(),
            'spec=1.0' ]
        sync = ','.join(sync)

        node = '[%s]' % node

        try:
            AdminControl.invoke(sync, 'syncNode', node, '[java.lang.String]')
        except:
            continue


if __name__ == '__main__':
    main()


