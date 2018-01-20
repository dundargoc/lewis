#! /usr/bin/env bash

source_if_exists() {
    # shellcheck source=/dev/null
    [[ -f "$1" ]] && source "$1"
}

extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2) tar xvjf   "$1" ;;
            *.tar.gz ) tar xvzf   "$1" ;;
            *.tar.xz ) tar xvf    "$1" ;;
            *.bz2    ) bunzip2    "$1" ;;
            *.gz     ) gunzip     "$1" ;;
            *.tar    ) tar xvf    "$1" ;;
            *.tbz2   ) tar xvjf   "$1" ;;
            *.tgz    ) tar xvzf   "$1" ;;
            *.zip    ) unzip      "$1" ;;
            *.Z      ) uncompress "$1" ;;
            *        ) echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

ssh() {
    if [ -n "$TMUX" ]; then
        tmux rename-window "ssh:$(echo $* | sed 's/\.arm\.com$//')"
        command ssh "$@"
        tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command ssh "$@"
    fi
}
