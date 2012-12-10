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

limit core 100M

# Set up aliases
alias ZshRehash='source ~/.zshrc'
alias ZshReload='rm -f ~/.zcompdump*; exec zsh -l'
alias cp='nocorrect cp'       # no spelling correction on cp
alias d='dirs -v'
alias gvimr='gvim --remote'
alias h=history
alias help=run-help
# update zsh history file if sharehistory is off;
# put space at the beginning so it's not written to the history:
alias histrefresh=' fc -RI; fc -AI'
alias histoff=' setopt nosharehistory'
alias histon=' setopt sharehistory'
alias j=jobs
alias la='ls -a'
alias lc='ls --color'
alias ll='ls -l'
alias llc='ls -l --color'
alias ls='ls --color=auto'
# List only file beginning with "."
alias lsa='ls -ld .*'
# List only directories and symbolic links that point to directories
alias lsd='ls -ld *(-/DN)'
alias mad='noglob mad'
alias mcp='noglob mcp'
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias mln='noglob mln'
alias mmv='noglob mmv'
alias mv='nocorrect mv'       # no spelling correction on mv
# beeps & notifies in xterm titlebar
alias notify='NO_TITLE=1; echo -e "\a"; print -Pn "\033]2; DONE \007"'
alias notifyoff='unset NO_TITLE; print -Pn "\033]2;\007"'
alias po=popd
alias pu=pushd
alias sr='screen -r'
alias sudo='nocorrect sudo'
alias vimr='vim --remote'
alias zcp='zmv -C'
alias zln='zmv -L'

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias wikiup='ikiwiki --setup .ikiwiki.setup'

# Debian building stuff
alias debug='MALLOC_CHECK_=2'
alias kerndist='CONCURRENCY_LEVEL=2 fakeroot make-kpkg kernel_image modules_image'
alias nostrip='DEB_BUILD_OPTIONS=nostrip'
alias pdebuild="pdebuild --use-pdebuild-internal"
alias pdebuildj2="pdebuild --use-pdebuild-internal --debbuildopts -j2"
alias git-buildsqueeze="git-buildpackage --git-dist=squeeze"
alias git-buildpackagej2="git-buildpackage -j2"

### BEGIN PROMPT SETUP ###
if [ -f /etc/debian_chroot ]; then
    debian_chroot="($(cat /etc/debian_chroot))"
fi

setopt promptsubst # re-interpolate variables in prompt on every redraw
if [ -d "/usr/share/zsh/functions/VCS_Info/" ]; then
    autoload -U add-zsh-hook
    autoload -U vcs_info # for VCS info in my prompt
    zstyle ':vcs_info:*' enable git hg
    vcs_info_precmd() {
	vcs_info
	p_vcs="$vcs_info_msg_0_"
    }
    add-zsh-hook precmd vcs_info_precmd
fi

p_host="%F{green}"
PROMPT='${debian_chroot}%F{green}%n%F{white}@${p_host}%m%F{white}:%F{cyan}%~%F{white}${p_vcs}%#%F{default} '
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
export EDITOR=vim
export EMAIL=ajp@aripollak.com # for git
export GREP_OPTIONS="--color=auto --exclude-dir=.svn --exclude-dir=.git \
    --exclude=*~ --exclude=*.o --exclude=*.pyc --exclude=*.sw[op] \
    --exclude=tags"
export LESS=-cMR
export HEBCAL_CITY="Boston"
export MAIL=/var/mail/$USER
export PAGER=less
export PYTHONSTARTUP=~/.pythonrc
export REPORTBUGEMAIL=$DEBEMAIL

# from http://www.reddit.com/r/ruby/comments/wgtqj/how_i_spend_my_time_building_rails_apps/
export RUBY_GC_MALLOC_LIMIT=79000000
export RUBY_FREE_MIN=100000
export RUBY_HEAP_MIN_SLOTS=800000
export RUBY_HEAP_FREE_MIN=100000
export RUBY_HEAP_SLOTS_INCREMENT=300000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1

# Set/unset shell options
setopt   autocd autolist autopushd autoresume correct correctall
setopt   extended_glob extended_history
setopt   hist_expire_dups_first hist_fcntl_lock hist_ignore_space histignoredups
setopt   longlistjobs interactivecomments noclobber notify
setopt   printeightbit pushdtohome rcquotes sharehistory
unsetopt automenu # don't start completing when I press TAB too many times
unsetopt autoparamslash beep bgnice

# Autoload zsh modules when they are referenced
autoload -U zmv
#zmodload -a zsh/stat stat
#zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof

# bindkey -v               # vi key bindings
bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
[ -n "${terminfo[kf7]}" ] && bindkey -s "${terminfo[kf7]}" "cd ..; ls\r" # F7

autoload      edit-command-line
zle -N        edit-command-line
bindkey '\ee' edit-command-line

# Setup new style completion system.
autoload -U compinit
# useful for shared filesystems where you run different OSes/zsh versions
compinit -d ~/.zcompdump-$OSTYPE-$ZSH_VERSION

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


# Function Usage: doc packagename
#                 doc pac<TAB>
doc() { cd /usr/share/doc/$1 && ls }
_doc() { _files -W /usr/share/doc -/ }
compdef _doc doc

_qstat() { compadd $(qmgr -c 'p s' | grep 'create queue' | cut -d' ' -f3) }
compdef _qstat qstat

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

[ -f ~/.zshrc.priv ] && source ~/.zshrc.priv
[ -f ~/.zshrc.local ] && source ~/.zshrc.local # a good place to override p_host
