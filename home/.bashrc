# ~/.bashrc

# ─────────────────────────────────────────────────────────────
# ✦ Environment Setup
# ─────────────────────────────────────────────────────────────

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # Uncomment to force native Wayland support
    # export QT_QPA_PLATFORM=wayland
    # export GDK_BACKEND=wayland
    # export MOZ_ENABLE_WAYLAND=1

    export CLUTTER_BACKEND=wayland
    export SDL_VIDEODRIVER=wayland

    alias nsxiv="GDK_BACKEND=x11 nsxiv"
    alias deadbeef="env GDK_BACKEND=x11 deadbeef"
fi

# ─────────────────────────────────────────────────────────────
# ✦ Shell Prompt
# ─────────────────────────────────────────────────────────────

#PS1='[\u@\h \W]\$ '
#PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[0;1m\]$?\[\e[2m\]|\[\e[0;2m\]\#\[\e[1m\]|\[\e[0;2;90;3m\]\!\[\e[0;2;1m\]]\n\[\e[0;1m\]\$\[\e[0m\] '
#PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[0;1m\]$?\[\e[2m\]|\[\e[0;2m\]\#\[\e[1m\]|\[\e[0;2;90;3m\]\!\[\e[0;2;1m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] '
#PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[0;1m\]$?\[\e[2m\]|\[\e[0;2m\]\#\[\e[1m\]|\[\e[0m\]$(printf "%s" "$timer_show")\[\e[1;2m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] '
#PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[0;1m\]$?\[\e[2m\]|]\n\[\e[0;1;96m\]\$\[\e[0m\] '

function timer_now {
    date +%s%N
}

function timer_start {
    timer_start=${timer_start:-$(timer_now)}
}

function timer_stop {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
    else timer_show=${us}us
    fi
    unset timer_start
}


set_prompt () {
    Last_Command=$? # Must come first!
    #Blue='\[\e[01;34m\]'
    #White='\[\e[01;37m\]'
    #Red='\[\e[01;31m\]'
    #Green='\[\e[32;1m\]' #'\[\e[01;32m\]'
    #Reset='\[\e[00m\]'
    #FancyX='\342\234\227'
    #Checkmark='\342\234\223'

    #PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[0;1;32m\]$?\[\e[39;2m\]|\[\e[0m\] \[\e[32;1m\]$timer_show\[\e[39;2m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] '
    #PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[0;1;31m\]$?\[\e[39;2m\]|\[\e[0m\] \[\e[31;1m\]$timer_show\[\e[39;2m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] '

    PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[32m\]$?\[\e[39m\]|\[\e[0m\] \[\e[32;1;2m\]$timer_show\[\e[39m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] '
    PS1='\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:[\[\e[31m\]$?\[\e[39m\]|\[\e[0m\] \[\e[31;1;2m\]$timer_show\[\e[39m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] '

    PS1="\[\e[1;2m\][\[\e[0;1m\]\u\[\e[2m\]@\[\e[0;2m\]\H\[\e[1m\]|\[\e[0;2;90;3m\]\w\[\e[0;2;1m\]]:"

    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        PS1+="[\[\e[32m\]$?\[\e[39m\]|\[\e[0m\]"
    else
        PS1+="[\[\e[31m\]$?\[\e[39m\]|\[\e[0m\]"
    fi

    # Add the ellapsed time and current date
    timer_stop

    if [[ $Last_Command == 0 ]]; then
        PS1+="\[\e[32;1;2m\]$timer_show\[\e[39m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] "
    else
        PS1+="\[\e[31;1;2m\]$timer_show\[\e[39m\]]\n\[\e[0;1;96m\]\$\[\e[0m\] "
    fi

        
    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    #if [[ $EUID == 0 ]]; then
    #    PS1+="$Red\\u$Green@\\h "
    #else
    #    PS1+="$Green\\u@\\h "
    #fi
    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    #PS1+="$Blue\\w \\\$$Reset "
}

trap 'timer_start' DEBUG
PROMPT_COMMAND='set_prompt'


# ─────────────────────────────────────────────────────────────
# ✦ Aliases
# ─────────────────────────────────────────────────────────────

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias rsync='rsync -avh --progress --partial --info=progress2'
alias fz='history | fzf'
alias n='nvim '

export BROWSER=firefox
export TERMINAL=kitty
export EDITOR=nvim
export VISUAL=nvim
export FILE_MANAGER=yazi
export VIDEO=mpv
export AUDIO=mpv
export IMAGE=nsxiv
export OFFICE=onlyoffice

# ─────────────────────────────────────────────────────────────
# ✦ Custom Functions
# ─────────────────────────────────────────────────────────────

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ─────────────────────────────────────────────────────────────
# ✦ Sources
# ─────────────────────────────────────────────────────────────

# https://github.com/rcaloras/bash-preexec/
[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"
alias fix-suspend="~/.config/scripts/fix-suspend.sh"
export MESA_GL_VERSION_OVERRIDE=3.3
export __GL_SHADER_DISK_CACHE=0
