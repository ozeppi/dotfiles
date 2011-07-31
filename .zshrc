autoload -U compinit
compinit

RPROMPT="[%~]"

setopt complete_in_word
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data
setopt auto_cd
setopt auto_pushd
setopt nolistbeep

####################
# export
export LANG=ja_JP.UTF-8
export PERL5LIB=$HOME/perl5/lib/perl5
export LESS='-R'

####################
# alias 
alias ls='ls -lG'
alias ack="ack --pager='less -R'"
alias diff='colordiff'
alias mkdir='mkdir -p'
alias tar='tar xvf'
alias st='svn st'
alias cpanm='perl5/bin/cpanm'

####################
# keybind
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "[1~" beginning-of-line
bindkey "^[[4~" end-of-line

####################
# history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

source ~/perl5/perlbrew/etc/bashrc
