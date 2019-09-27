# printing from one line to another passing regex as argument: sed

$ sed -n '/^# israel-manual-config-start/,/^# israel-manual-config-end/ p' apache2.conf

# The output displays lines from label indicating start to label indicating end (my code in file)

# If you have these labels ... you can get the line numbers by using grep -n

$ grep -n 'israel' apache2.conf

# Then you can use sed passing line numbers as arguments, instead of regex:

$ sed -n '122,126 p' apache2.conf
$ sed -n '181,188 p' apache2.conf

# but you see, 3 lines instead of one ... the grep command, and two sed ... better first option!

## to make a permanent deletion, use option -i :

sed -i '2d' file.txt

### adding text to a file when a pattern is found:
# after pattern:

[israel@w50019045l-mutworld-be tmp]$ sed '/^<\/properties>/ r /tmp/git_config_lines_template.txt' /tmp/testeando.txt 
esta linea contiene nippin.git para cambiar
agregar despues de siguiente tag
</properties>
<scm class="hudson.plugins.git.GitSCM" plugin="git@3.10.1">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>ssh://git@git.sdlc.gfdi.be:7999/bitbucket-project/git-repository.git</url>
        <credentialsId>tomcat</credentialsId>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches>
      <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
aqui hay texto q viene despues del agregado

# before pattern:
sed -i $'/<\/properties>/{e cat git_config_lines_template.txt\n}' "${WORKSPACE}/${job}/config.xml"

# After a pattern, add the content of file:
sed -i -e "/<\/properties>/r ${EXECUTION_DIR}/git_config_lines_template.txt" "${WORKSPACE}/${job}/config.xml"

