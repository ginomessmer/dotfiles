if [ "$(uname --kernel-version | grep -oh Microsoft)" = "Microsoft" ]; then
	# Ok, this is running on WSL
	windows=true
fi


# Username for Windows Subsystem
if [ $windows ]; then
   winuser="GinoMessmer"
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export ZSH=$HOME/.oh-my-zsh


# Shell theme
ZSH_THEME="agnoster"


# Plugin management
plugins=(
	gitfast
	git_stash

	node
	npm
	yarn

	docker

	ubuntu
	vscode
	sudo

	emoji
	colorize
	web-search
)


# Oh my zsh import
source $ZSH/oh-my-zsh.sh


# Colorful directory listing
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias grep="grep --color=auto"
fi


# Powerline Shell plugin
function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi


# Default editor
export EDITOR="vim"

# Alias commands
alias vi="vim"
alias cat="ccat" # Pygments
alias screenfetch="screenfetch -E"
alias ls="ls -lh --color"

if [ $windows ]; then
	# Windows Subsystem aliases
	alias winc="cd /mnt/c/"
	alias winhome="cd /mnt/c/Users/$winuser/"
	alias pwsh="powershell.exe"

	# Dotnet core aliases for Windows Subsytem
	alias dotnet="dotnet.exe"

	# Node aliases for Windows Subsystem
	alias node="powershell.exe node"
	alias npm="powershell.exe npm"
	alias yarn="powershell.exe yarn"

	# Docker alias for Windows Subsystem
	alias docker="powershell.exe docker"
fi


# Credential Helper for git
alias gitstore="git config credential.helper store"


# DuckDuckGo Bangs
alias yt='ddg \!yt'
alias wiki='ddg \!w'
alias stack='ddg \!stackoverflow'
alias amazon='ddg \!a'
alias wa='ddg \!wa'


# Cd with ls attached
cd() {
  builtin cd "$@" && ls
}

# Cleanup
unset windows

# Startup commands
