#
#  Completion for yii2 console commands:
#
_yii2_autocomplete() 
{
    local cur prev opts curpath commands list options params last c=0 command="someRandomString"
    COMPREPLY=()
    curpath=$(pwd)
    commands=$( ./yii help/index | egrep "^    " | awk '{ print $1 }' )
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    list=($commands)

    while [ $c -lt $COMP_CWORD ]; do
        if [[ ${list[*]} =~ ${COMP_WORDS[$c]} ]]; then
            command=${COMP_WORDS[$c]}
            break
        fi
        ((c++))
    done

    if [[ ${list[*]} =~ "$command" ]]; then
        # params was sorted in alphabet order and do not understand what have to be the next
        #params=$( ./yii help/index $prev | egrep "^- " | awk '{print $2}' | awk -F ":" '{print $1}' )
        options=$( ./yii help/index $command | egrep "^--" | awk -F ":" '{print $1}' | awk '{print $1"="}' )
        COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
        return 0
    fi

    if [[ $prev == "./yii" ]]; then
        compopt +o nospace
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
    fi

    return 0
}

complete -o nospace -F _yii2_autocomplete ./yii
