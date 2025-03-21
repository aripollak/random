# vim: set noet sw=0 sts=0:
# Autoload zsh modules when they are referenced
autoload -U zmv
zmodload -a zsh/zprof zprof

bindkey -e # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

autoload      edit-command-line
zle -N        edit-command-line
bindkey '\ee' edit-command-line

# Setup new style completion system.
autoload -U compinit
compinit

# Completion Styles
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _correct _approximate

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# match uppercase from lowercase, and other substitutions
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?~' \
	'*?.old' '*?.bak' '*?.pro'

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

# With commands like `rm' it's annoying if one gets offered the same filename
# again even if it is already on the command line. To avoid that:
zstyle ':completion:*:rm:*' ignore-line yes

zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [ -x /usr/bin/dircolors ]; then
	eval $(dircolors)
	alias ls='ls --color=auto'
	zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi

umask 022

# Search path for the cd command
#cdpath=(.. ~ ~/src ~/zsh)

export PATH="$PATH:/usr/games:$HOME/bin:/usr/sbin:/sbin:/snap/bin"

HISTFILE=~/.zsh_history
HISTSIZE=5500
SAVEHIST=5000
WORDCHARS="*?_-.[]~&;!#$%^(){}<>"

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Set up aliases
alias ZshRehash='source ~/.zshrc'
alias ZshReload='rm -f ~/.zcompdump*; exec zsh -l'
alias aptar='sudo apt autoremove'
alias aptp='apt policy'
alias apts='apt show'
alias apti='sudo apt install'
alias aptfu='sudo apt full-upgrade'
alias aptu='sudo apt update && sudo apt upgrade'
alias be='nocorrect bundle exec'
alias by='byobu'
alias cdg='cd $(git rev-parse --show-toplevel)' # go to root of git project
alias cp='nocorrect cp'
alias d='dirs -v'
alias devclone='cd ~/dev && git clone '
alias doco='docker-compose'
alias fgrep='grep -F' # to pick up grep alias
alias fileserver='python3 -m http.server 8080' # serves files in current dir
alias grep='grep --color=auto --exclude-dir=.svn --exclude-dir=.git --exclude=\*~ --exclude=\*.o --exclude=\*.pyc --exclude="*.sw[op]" --exclude=tags'
alias h=history
alias help=run-help
# update zsh history file if sharehistory is off;
# put space at the beginning so it's not written to the history:
alias histrefresh=' fc -RI; fc -AI'
alias histoff=' setopt nosharehistory'
alias histon=' setopt sharehistory'
alias j=jobs
alias la='ls -a'
alias ll='ls -l'
# List only file beginning with "."
alias lsa='ls -ld .*'
# List only directories and symbolic links that point to directories
alias lsd='ls -ld *(-/DN)'
alias mad='noglob mad'
alias mcp='noglob mcp'
alias mkdir='nocorrect mkdir'
alias mln='noglob mln'
alias mmv='noglob mmv'
alias mv='nocorrect mv'
# beeps & notifies in xterm titlebar
alias notify='NO_TITLE=1; echo -e "\a"; print -Pn "\e]0; DONE \a"'
alias notifyoff='unset NO_TITLE; print -Pn "\e]0;\a"'
alias ppc='powerprofilesctl launch'
alias poco='podman-compose'
alias psgrep='ps auxw | grep '
alias po=popd
alias pu=pushd
[ -x /usr/bin/trash ] && alias rm=trash
alias sudo='nocorrect sudo'
alias zcp='zmv -C'
alias zln='zmv -L'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Debian building stuff
alias debug='MALLOC_CHECK_=2'
alias gbp-buildwheezy="gbp buildpackage --git-dist=jessie"
alias gbp-buildpackagej4="gbp buildpackage -j4"
alias nostrip='DEB_BUILD_OPTIONS=nostrip'
alias pdebuild="pdebuild --use-pdebuild-internal"
alias pdebuildj2="pdebuild --use-pdebuild-internal --debbuildopts -j2"

### BEGIN PROMPT SETUP ###
if [ -f /etc/debian_chroot ]; then
	debian_chroot="($(cat /etc/debian_chroot))"
fi

source ~/.zsh/git_prompt.zsh

p_host="%F{green}"
PROMPT='${debian_chroot}%n@${p_host}%m%F{default}:%~ $(git_prompt_string)%# '
RPROMPT='%W %t'     # prompt for right side of screen
### END PROMPT SETUP ###

case $TERM in
	xterm*|rxvt*)
		# Run before a command is executed - puts shortened
		# version into term title
		function precmd {
			[ -n "$NO_TITLE" ] && return
			print -Pn "\e]0; $USER@%m - %~\a"
		}
		precmd
		;;
esac

if [ -f /etc/zsh_command_not_found ]; then
	source /etc/zsh_command_not_found
fi

# Some environment variables
[ -x /usr/bin/lessfile ] && eval $(lessfile)
export CLICOLOR=1
export DEBEMAIL=ari@debian.org
export DEBFULLNAME="Ari Pollak"
export DOCKER_BUILDKIT=0 # for tilt to work with podman
# For rootless podman with docker-compose
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
which nvim >/dev/null && export EDITOR=nvim
export EMAIL=ajp@aripollak.com # for git
export LESS=-FMRX
export MAIL=/var/mail/ari
export MAILCHECK=60
export PAGER=less
export PARALLEL_TEST_FIRST_IS_1=true # for parallel_tests gem
export REPORTBUGEMAIL=$DEBEMAIL
export RIPGREP_CONFIG_PATH=~/.random/.ripgreprc

# Set/unset shell options
setopt   autocd autopushd autoresume correct extended_glob
setopt   extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space
setopt   longlistjobs interactivecomments printeightbit pushdtohome sharehistory
unsetopt automenu # don't start completing when I press TAB too many times
unsetopt autoparamslash beep bgnice clobber nomatch

dev() { cd ~/dev/$1 }
_dev() { _path_files -W ~/dev/ -/ }
compdef _dev dev

doc() { cd /usr/share/doc/$1 && ls }
_doc() { _path_files -W /usr/share/doc -/ }
compdef _doc doc

function bat {
	theme_arg=$([[ `gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null` == "'default'" ]] && echo '--theme=GitHub')
	batcat $theme_arg $@
}

function g {
	if [[ $# > 0 ]]; then
		nocorrect git $@
	else
		git status
	fi
}
alias g='nocorrect g' # turn off correction so it doesn't constantly complain about git aliases
compdef g=git

if [[ ! -o login ]]; then
	autoload checkmail
	checkmail
fi

[ -d ~/.rbenv ] && PATH="$HOME/.rbenv/bin/:$PATH" && eval "$(rbenv init -)"

[ -f ~/.zshrc.priv ] && source ~/.zshrc.priv
[ -f ~/.zshrc.local ] && source ~/.zshrc.local # a good place to override p_host
[ -f /etc/profile.d/vte-2.91.sh ] && source /etc/profile.d/vte-2.91.sh # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1083281
