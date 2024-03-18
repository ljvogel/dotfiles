HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey "^U"    backward-kill-line
bindkey "^u"    backward-kill-line
bindkey "^[l"   down-case-word
bindkey "^[L"   down-case-word

# alt+<- | alt+->
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# ctrl+<- | ctrl+->
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

archive() {
  wget -r -m -p -E -k $1
}

binaryninja() {
  /home/$USER/bin/binaryninja/binaryninja &
}

yt-dlp() {
  python3 ~/bin/yt-dlp "$@"
}

makepdf() {
  latexmk $@ --outdir=texout
}

pdfcat() {
  local count=$#
  local inpdfs=("${@:1:$count-1}")
  local outpdf=("${@:$#:$#}")
  pdftk $inpdfs cat output $outpdf
}

mkcd() {
  mkdir -p $1 && cd $1
}

disass() {
	if [[ $# -lt 1  ]]
	then
		echo "Usage: disass <file>"
		return	
	fi

	objdump -M intel -d $1
}

get_shortened_folder() {
	if [[ "${1:0:1}" == "." ]];
	then
		echo "${1:0:2}"
	else
		echo "${1:0:1}"
	fi
}

get_shortened_working_dir() {
  dir=$(pwd)

  dir_split=("${(@s|/|)dir}")
  top_dir=""
  potential_user=""

  i=0
  for folder in "${dir_split[@]:1:2}";
  do
    if [[ "$i" == "0" ]]; then
      top_dir=$folder
    fi

    if [[ "$i" == "1" ]]; then
      potential_user=$folder
    fi
   
    i=$((i+1))
  done
 
  shortened=""
  if [[ "$top_dir" == "home" && "$potential_user" == "$USER" ]];
  then
	shortened="~"
	if [[ ${#dir_split[@]}-1 -eq 2 ]];
	then
		return ""	
	else
	for folder in "${dir_split[@]:3:-1}";
	do
		shortened="$shortened/$(get_shortened_folder $folder)"
	done
	fi
  else
	shortened=""
	for folder in "${dir_split[@]:1:-1}";
	do
		shortened="$shortened/$(get_shortened_folder $folder)"
	done
  fi

  if [[ ${#dir_split} -gt 2 ]];
  then
    echo "$shortened/"
  fi
}

command_not_found_handler () {
    if [ -x /usr/lib/command-not-found ]
    then
        /usr/lib/command-not-found -- "$1"
        return $?
    else
        if [ -x /usr/share/command-not-found/command-not-found ]
        then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
            printf "%s: command not found\n" "$1" >&2
            return 127
        fi
    fi
}

setopt prompt_subst
PROMPT='%F{010}%n%f@%F{015}%m%f %F{010}$(get_shortened_working_dir)%1~%F{015}> '

alias ls='ls --color=auto'
alias clipboard='xclip -sel clip'
alias explorer='xdg-open'
alias python='python3'
alias py='python3'
alias sha256='sha256sum'

eval "$(zoxide init zsh)"


#custom functions
fpath+=~/.zfunc
autoload cert
autoload header

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/leon/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/lib/command-not-found

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/leon/bin/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/leon/bin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/leon/bin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/leon/bin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export MODULAR_HOME="/home/leon/.modular"
export PATH="/home/leon/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
