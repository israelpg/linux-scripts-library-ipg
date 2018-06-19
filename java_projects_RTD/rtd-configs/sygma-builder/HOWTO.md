## Howto use the deploy script

To use the deploy script just call it, followed by the target environment

Example:

- On linux
```
./deploy int
```

- On windows
```
deploy.cmd int
```


## Enable autocomplete of the available environments (only on unix)

create a file /etc/bash_completion.d/deploy with the following content

```bash
_deploy()
{
    AVAILABLE_ENVS=$(grep -oP "(?<=<value>)[^<]+" $M2_HOME/conf/settings.xml|tr '\n' ' ')

    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMPREPLY=( $(compgen -W "${AVAILABLE_ENVS}" -- ${cur}) )

    return 0
}

complete -o nospace -F _deploy ./deploy.sh
complete -o nospace -F _deploy ./deploy
```
