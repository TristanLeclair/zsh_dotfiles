# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

# See `man zshoptions` for details
setopt histignorealldups sharehistory autocd menucomplete

# I'd rather kms than hear a beep
unsetopt BEEP

bindkey -e
# bindkey '^R' history-incremental-pattern-search-backward
export KEYTIMEOUT=1

export EDITOR='nvim'

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# Use modern completion system
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)

# Colors
autoload -Uz colors && colors

# Load aliases
[ -f "$ZDOTDIR/aliasrc" ] && source "$ZDOTDIR/aliasrc"

# z
# . $ZDOTDIR/plugins/z/z.sh

# zoxide
eval "$(zoxide init zsh)"

# Plugins, must be installed via git in the $ZDOTDIR/plugins directory

source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^n' autosuggest-accept

# Fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

export FZF_CTRL_R_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'exa --color=always {} | head -200'"
export FZF_TMUX_OPTS="-p"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
fi

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'exa --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

#Theme for syntax highlighting
source $ZDOTDIR/plugins/catppuccin/catppuccin_mocha-zsh-syntax-highlighting.zsh

source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

# Gitignore plugin
source $ZDOTDIR/plugins/gitignore/gitignore.plugin.zsh

# Apt plugins suggestions
# apt install command-not-found
source /etc/zsh_command_not_found

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

export PATH=/home/tlecla/.local/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tlecla/miniconda/3.11.4/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tlecla/miniconda/3.11.4/etc/profile.d/conda.sh" ]; then
        . "/home/tlecla/miniconda/3.11.4/etc/profile.d/conda.sh"
    else
        export PATH="/home/tlecla/miniconda/3.11.4/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

