# CHANGKUN ZSH THEME
# hi@changkun.de
# Based on the great ys theme (http://ysmood.org/wp/2013/03/my-ys-terminal-theme/)

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# VCS
CHANGKUN_PROMPT_PREFIX1="%{$fg[white]%}%{$fg[cyan]%}\uE0A0%{$reset_color%} "
CHANGKUN_PROMPT_PREFIX2="%{$fg[cyan]%}"
CHANGKUN_PROMPT_SUFFIX="%{$reset_color%}"
CHANGKUN_PROMPT_DIRTY=" %{$fg[red]%}✖︎"
CHANGKUN_PROMPT_CLEAN=" %{$fg[green]%}●"

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${CHANGKUN_PROMPT_PREFIX1}${CHANGKUN_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$CHANGKUN_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$CHANGKUN_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$CHANGKUN_PROMPT_CLEAN"

# HG info
local hg_info='$(changkun_hg_prompt_info)'
changkun_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${CHANGKUN_PROMPT_PREFIX1}hg${CHANGKUN_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$CHANGKUN_PROMPT_DIRTY"
		else
			echo -n "$CHANGKUN_PROMPT_CLEAN"
		fi
		echo -n "$CHANGKUN_PROMPT_SUFFIX"
	fi
}

# virtualenv info
local venv_info='$(virtualenv_info)'
virtualenv_info() {
	if [ $VIRTUAL_ENV ]; then
		echo "%{${fg_bold[white]}%}(env: %{${fg[green]}%}`basename \"$VIRTUAL_ENV\"`%{${fg_bold[white]}%})%{${reset_color}%}"
	fi
}

# Prompt format: 
# (venv: ...)
# # USER at MACHINE in DIRECTORY
# →                                 BRANCH STATE [TIME]
PROMPT="${venv_info}
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$fg[cyan]%}%n \
%{$fg[white]%}at \
%{$fg[green]%}$(box_name) $reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}\
${hg_info}
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
RPROMPT="${git_info} %{$fg[white]%}[%*]"

if [[ "$USER" == "root" ]]; then
PROMPT="${venv_info}
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$bg[yellow]%}%{$fg[cyan]%}%n%{$reset_color%} \
%{$fg[white]%}at \
%{$fg[green]%}$(box_name) $reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}\
${hg_info}
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
RPROMPT="${git_info} %{$fg[white]%}[%*]"
fi
