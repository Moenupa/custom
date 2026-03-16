_hf_completion() {
    local IFS=$'
'
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   _HF_COMPLETE=complete_bash $1 ) )
    return 0
}

complete -o default -F _hf_completion hf
