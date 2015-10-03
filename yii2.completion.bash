#
#  Completion for yii2 console commands
#
#  To use these routines:
#
#    1) Copy this file to somewhere (e.g. ~/yii2-completion.bash).
#    2) Add the following line to your .bashrc:
#        source ~/yii2-completion.bash
#
#    or you can put this file in /etc/bash_completion.d/
#
#    or simply type `. yii2-completion.bash` for one time using
#
_yii2_completion()
{
    local cur prev curpath commands command subcommand fullcommand options params res res2 array
    COMPREPLY=()
    curpath=$(pwd)
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    command=$(echo "${COMP_WORDS[1]}" | awk -F "/" '{ print $1 }')
    subcommand=$(echo "${COMP_WORDS[1]}" | awk -F "/" '{ print $2 }')
    fullcommand="$command/$subcommand"

    # TODO: fix if
    if [[ ${subcommand} == "" ]]; then
        commands=$( ./yii help/index | egrep "^- " | awk '{ print $2 }' )
        res=$(__check_in_array ${cur} "${commands[@]}")
        res2=$(__check_in_array ${command} "${commands[@]}")
        if [[ ${res} == 0 && ${res2} == 0 ]]; then
            COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
            return 0
        fi
    fi

    if [[ ${COMP_CWORD} == 1 ]]; then
        compopt +o nospace
        commands=$( ./yii help/index | egrep "^    " | awk '{ print $1 }' )
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
    fi

    if [[ ${prev} == "./yii" ]]; then
        commands=$( ./yii help/index | egrep "^- " | awk '{ print $2 }' )
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
    fi

    if [[ ${cur} == -* ]]; then
        options=$( ./yii help/index ${fullcommand} | egrep "^--" | awk -F ":" '{print $1}' | awk '{print $1"="}' )
        compopt -o nospace
        COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
        return 0
    fi

    # TODO: auto definition of the default command
    if [[ ${subcommand} != "" && ${cur} == "" ]]; then
        # params was sorted in alphabetical order and do not understand what have to be the next
        params=$( ./yii help/index ${fullcommand} | egrep "^- " | awk '{print $2}' | awk -F ":" '{print NR"-"$1}' )
        array=(${params})
        paramCount=${#array[@]}
        if [[ ${paramCount} > 0 ]]; then
            COMPREPLY=( $(compgen -W "0-argumens: ${params}" -- ${cur}) )
            return 0
        fi
    fi

    return 0
}

__check_in_array() {
    local val=$1 && shift
    local array=($@)

    for item in ${array[*]}
    do
        if [[ ${val} == ${item} ]]; then
            echo 1
            return
        fi
    done
    echo 0
    return
}
complete -o nospace -F _yii2_completion ./yii
# 2>/dev/null
# -o bashdefault -o default
