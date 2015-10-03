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
    local cur prev curpath controllers commands controller action command options params res res2 array
    COMPREPLY=()
    curpath=$(pwd)
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    controller=$(echo "${COMP_WORDS[1]}" | awk -F "/" '{ print $1 }')
    action=$(echo "${COMP_WORDS[1]}" | awk -F "/" '{ print $2 }')
    command="$controller/$action"

    if [[ ${COMP_CWORD} == 1 ]]; then
        if [[ ${action} == "" ]]; then
            controllers=$( __yii2_get_controllers )
            res=$(__check_in_array ${cur} "${controllers[@]}")
            res2=$(__check_in_array ${controller} "${controllers[@]}")
            if [[ ${res} == 0 && ${res2} == 0 ]]; then
                compopt -o nospace
                COMPREPLY=( $(compgen -W "${controllers}" -S "/" -- ${cur}) )
                return 0
            fi
        fi

        compopt +o nospace
        commands=$( __yii2_get_full_controllers )
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        return 0
    fi

    if [[ ${action} == "" ]]; then
        action=$( __yii2_get_controller_default_action ${controller} )
        command="$controller/$action"
    fi

    if [[ ${action} != "" ]]; then
        if [[ ${cur} == -* ]]; then
            options=$( __yii2_get_command_options ${command} )
            compopt -o nospace
            COMPREPLY=( $(compgen -W "${options}" -S "=" -- ${cur}) )
            return 0
        fi

        if [[ ${cur} == "" ]]; then
            # params was sorted in alphabetical order and do not understand what have to be the next
            # so it show parameter names with prefix order
            params=$( __yii2_get_command_params ${command} )
            array=(${params})
            if [[ ${#array[@]} > 0 ]]; then
                COMPREPLY=( $(compgen -W "0-arguments: ${params}" -- ${cur}) )
                return 0
            fi
        fi
    fi

    return 0
}

__yii2_get_controllers() {
    ./yii help/index | egrep "^- " | awk '{ print $2 }'
}

__yii2_get_full_controllers() {
    ./yii help/index | egrep "^    " | awk '{ print $1 }'
}

__yii2_get_controller_default_action() {
    local controller=$1
    ./yii help/index | egrep "^    ${controller}/\w* \(default\)" | awk '{ print $1 }' | awk -F "/" '{ print $2 }'
}

__yii2_get_command_options() {
    local command=$1
    ./yii help/index ${command} | egrep "^--" | awk -F ":" '{print $1}' | awk '{print $1}'
}

__yii2_get_command_params() {
    local command=$1
    if [[ ${command} != *"/"* ]]; then
        return 0
    fi
    ./yii help/index ${command} | egrep "^- " | awk '{print $2}' | awk -F ":" '{print NR"-"$1}'
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

complete -F _yii2_completion ./yii 2>/dev/null
