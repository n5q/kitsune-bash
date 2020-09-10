



function prompt_command() {
	#PS1="${TITLEBAR}[\u@\h \W $(scm_prompt_info)]\$ "
	if [ "$?" != 0 ]
	then
			SH="${bold_red}$";
	elif [ "$UID" -eq 0 ]
	then
			SH="${bold_green}#";
	elif [ -n "$(jobs -l)" ]
	then
			SH="${bold_yellow}$(jobs -l | wc -l) ${bold_green}$";
	else
			SH="${bold_green}$";
	fi
	BC=`cat /sys/class/power_supply/BAT0/capacity`
	PS1="\n${bold_white}╭─${bold_cyan}[\u@\h]${bold_white}─${bold_cyan}(${bold_white}\w${bold_cyan})$(scm_prompt_info)\n${bold_white}╰──${bold_cyan}[\A]-${cyan}($BC%)${bold_cyan} - ${green}${bold_green}$SH${white} "
}

fn_exists() {
  type $1 | grep -q 'shell function'
}

function safe_append_prompt_command {
    local prompt_re

    # Set OS dependent exact match regular expression
    if [[ ${OSTYPE} == darwin* ]]; then
      # macOS
      prompt_re="[[:<:]]${1}[[:>:]]"
    else
      # Linux, FreeBSD, etc.
      prompt_re="\<${1}\>"
    fi

    # See if we need to use the overriden version
    if [[ $(fn_exists function append_prompt_command_override) ]]; then
       append_prompt_command_override $1
       return
    fi

    if [[ ${PROMPT_COMMAND} =~ ${prompt_re} ]]; then
      return
    elif [[ -z ${PROMPT_COMMAND} ]]; then
      PROMPT_COMMAND="${1}"
    else
      PROMPT_COMMAND="${1};${PROMPT_COMMAND}"
    fi
}


SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX="${bold_cyan}("
SCM_THEME_PROMPT_SUFFIX="${bold_cyan})${reset_color}"

safe_append_prompt_command prompt_command
