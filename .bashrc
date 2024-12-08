# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Check window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# Set prompt
if [ "$TERM" == "xterm-color" ] || [ "$TERM" == "*-256color" ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Basic aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Load bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Enhanced tab completion settings
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'set menu-complete-display-prefix on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

# Function to find and activate Python virtual environment
venv() {
    deactivate_current_venv() {
        if [[ -n "$VIRTUAL_ENV" ]]; then
            echo "Deactivating current virtual environment: $VIRTUAL_ENV"
            deactivate 2>/dev/null || { echo "Failed to deactivate current environment."; return 1; }
        fi
    }
    
    local venv_dir=$(find . -maxdepth 2 -type d \( -name "venv" -o -name ".*env" \) -print -quit)
    
    if [ -z "$venv_dir" ]; then
        venv_dir=$(find . -maxdepth 2 -type d -exec test -e {}/bin/activate \; -print -quit)
    fi
    
    if [ -n "$venv_dir" ]; then
        local activate_script="$venv_dir/bin/activate"
        if [ -f "$activate_script" ]; then
            if [ "$VIRTUAL_ENV" = "$venv_dir" ]; then
                echo "Virtual environment is already activated: $VIRTUAL_ENV"
            else
                deactivate_current_venv
                echo "Activating virtual environment: $venv_dir"
                source "$activate_script"
            fi
        else
            echo "Found potential virtual environment directory, but activate script is missing: $venv_dir"
        fi
    else
        echo "No virtual environment found in the current directory or its immediate subdirectories."
    fi
}

# Path settings
export PATH="$PATH:/home/$USER/.local/bin:/usr/local/go/bin"
export GOPATH="$HOME/go"

# Load NVM if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Neovim path if installed
[ -d "/opt/nvim-linux64/bin" ] && export PATH="$PATH:/opt/nvim-linux64/bin"