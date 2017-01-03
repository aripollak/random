# vim: set noet sw=0 sts=0:
# Autoload zsh modules when they are referenced
autoload -U zmv
#zmodload -a zsh/stat stat
#zmodload -a zsh/zpty zpty
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
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
	'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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

umask 022

# Search path for the cd command
#cdpath=(.. ~ ~/src ~/zsh)

export PATH="$PATH:/usr/games:$HOME/bin:/usr/sbin:/sbin"

HISTFILE=~/.zsh_history
HISTSIZE=5500
SAVEHIST=5000
WORDCHARS="*?_-.[]~&;!#$%^(){}<>"

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

limit core 200M

# Set up aliases
alias ZshRehash='source ~/.zshrc'
alias ZshReload='rm -f ~/.zcompdump*; exec zsh -l'
alias aptp='apt policy'
alias apts='apt show'
alias apti='sudo apt install'
alias aptfu='sudo apt update && sudo apt full-upgrade'
alias aptu='sudo apt update && sudo apt upgrade'
alias be='nocorrect bundle exec'
alias cdg='cd $(git rev-parse --show-toplevel)' # go to root of git project
alias cp='nocorrect cp'
alias d='dirs -v'
alias fgrep='grep -F' # to pick up grep alias
alias fileserver='python -m SimpleHTTPServer 8080' # serves files in current dir
alias grep='grep --color=auto --exclude-dir=.svn --exclude-dir=.git --exclude=\*~ --exclude=\*.o --exclude=\*.pyc --exclude="*.sw[op]" --exclude=tags'
alias gvimr='gvim --remote'
alias h=history
alias help=run-help
# update zsh history file if sharehistory is off;
# put space at the beginning so it's not written to the history:
alias histrefresh=' fc -RI; fc -AI'
alias histoff=' setopt nosharehistory'
alias histon=' setopt sharehistory'
alias hl='heroku local'
alias j=jobs
alias la='ls -a'
alias ll='ls -l'
alias ls='ls --color=auto'
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
alias notify='NO_TITLE=1; echo -e "\a"; print -Pn "\033]2; DONE \007"'
alias notifyoff='unset NO_TITLE; print -Pn "\033]2;\007"'
alias partest='be rake db:migrate; be rake db:test:prepare; be rake parallel:prepare; be nice rake test:parallel_with_specs'
alias psgrep='ps auxw | grep '
alias po=popd
alias pu=pushd
[ -x /usr/bin/trash ] && alias rm=trash
alias s='nocorrect spring'
alias sr='screen -r'
alias sudo='nocorrect sudo'
alias rpry='bundle exec pry'
alias vimr='vim --remote'
alias zcp='zmv -C'
alias zln='zmv -L'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias wikiup='ikiwiki --setup .ikiwiki.setup'

# Debian building stuff
alias debug='MALLOC_CHECK_=2'
alias gbp-buildwheezy="gbp buildpackage --git-dist=jessie"
alias gbp-buildpackagej4="gbp buildpackage -j4"
alias kerndist='CONCURRENCY_LEVEL=2 fakeroot make-kpkg kernel_image modules_image'
alias nostrip='DEB_BUILD_OPTIONS=nostrip'
alias pdebuild="pdebuild --use-pdebuild-internal"
alias pdebuildj2="pdebuild --use-pdebuild-internal --debbuildopts -j2"

### BEGIN PROMPT SETUP ###
if [ -f /etc/debian_chroot ]; then
	debian_chroot="($(cat /etc/debian_chroot))"
fi

source ~/.zsh/git_prompt.zsh

p_host="%F{green}"
PROMPT='${debian_chroot}%F{green}%n%F{white}@${p_host}%m%F{white}:%F{cyan}%~ $(git_prompt_string)%#%F{default} '
RPROMPT='%W %t'     # prompt for right side of screen
### END PROMPT SETUP ###


case $TERM in
	xterm*|rxvt*)
		# Run before a command is executed - puts shortened
		# version into term title
		function precmd {
			[ -n "$NO_TITLE" ] && return
			print -Pn "\033]2; $USER@%m - %~\007"
		}
		precmd
		;;
esac

# Some environment variables
[ -x /usr/bin/dircolors ] && eval $(dircolors)
[ -x /usr/bin/lessfile ] && eval $(lessfile)
export DEBEMAIL=ari@debian.org
export DEBFULLNAME="Ari Pollak"
[ -x /usr/bin/nvim ] && export EDITOR=nvim
export EMAIL=ajp@aripollak.com # for git
export LESS=-cMR
export HEBCAL_CITY="Boston"
export MAIL=/var/mail/$USER
export PAGER=less
export PARALLEL_TEST_FIRST_IS_1=true
export PYTHONSTARTUP=~/.pythonrc
export REPORTBUGEMAIL=$DEBEMAIL

# from http://tmm1.net/ruby21-rgengc/
export RUBY_GC_HEAP_INIT_SLOTS=600000
export RUBY_GC_HEAP_FREE_SLOTS=600000
export RUBY_GC_HEAP_GROWTH_MAX_SLOTS=300000

# Set/unset shell options
setopt   autocd autopushd autoresume correct correctall extended_glob
setopt   extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space
setopt   longlistjobs interactivecomments printeightbit pushdtohome sharehistory
unsetopt automenu # don't start completing when I press TAB too many times
unsetopt autoparamslash beep bgnice clobber nomatch

dev() { cd ~/dev/$1 }
_dev() { _files -W ~/dev/ -/ }
compdef _dev dev

doc() { cd /usr/share/doc/$1 && ls }
_doc() { _files -W /usr/share/doc -/ }
compdef _doc doc

function g {
	if [[ $# > 0 ]]; then
		nocorrect git $@
	else
		git status
	fi
}
alias g='nocorrect g' # turn off correction so it doesn't constantly complain about git aliases
compdef g=git

[ -d ~/.rbenv ] && PATH="$HOME/.rbenv/bin/:$PATH" && eval "$(rbenv init -)"

[ -f ~/.zshrc.priv ] && source ~/.zshrc.priv
[ -f ~/.zshrc.local ] && source ~/.zshrc.local # a good place to override p_host
