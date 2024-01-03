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
. $ZDOTDIR/plugins/z/z.sh

# Plugins, must be installed via git in the $ZDOTDIR/plugins directory

source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^n' autosuggest-accept

# Fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

export FZF_CTRL_R_OPTS='--height 40% --layout=reverse --border'
export FZF_TMUX_OPTS="-p"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
fi

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

# neovim switcher
alias nvim-lazy="NVIM_APPNAME=Lazyvim nvim"
alias nvim-kickstart="NVIM_APPNAME=kickstart nvim"

function nvims() {
  items=("default" "kickstart" "LazyVim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt="?  Neovim Config ? " --height=50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^b "nvims\n"

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

