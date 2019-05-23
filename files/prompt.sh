#!/bin/bash
#
# Creates a function that builds our prompt

set_prompt () {

    LC=$?                       #EXIT STATUS
    Reset='\[\e[0;94m\]'        #RESET
    FancyX='\342\234\227'       #BAD
    Checkmark='\342\234\223'    #GOOD

    White='\[\e[01;37m\]'
    Red='\[\e[0;31m\]'
    BRed='\[\e[1;31m\]'
    Green='\[\e[0;32m\]'
    Blue='\[\e[0;34m\]'
    BBlue='\[\e[1;34m\]'
    IBlue='\[\e[0;94m\]'
    BGreen='\[\e[1;32m\]'


    #Build up our prompt
    # Add a bright white exit status for the last command
    PS1="$White\$LC:"

    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $LC == 0 ]]; then
        PS1+="$Green$Checkmark"
    else
        PS1+="$Red$FancyX"
    fi

    #print username@host
    PS1+="$IBlue[$BGreen\u@\h "
    #print cwd
    PS1+="$White\W"

    if _is_git_repo; then
      branch=$(parse_git_branch)
      staged=$(git_staged)
      modified=$(git_modified)
      new=$(git_new)

      if [[ $branch == " (master)" ]]; then
	    PS1+="$BRed$branch "
      else
	    PS1+="$Green$branch "
      fi
      PS1+=$new$modified$staged
    else
      PS1+=' '
    fi

    #What is my current python virtual environment
    c_env=''
    if [[ $CONDA_DEFAULT_ENV ]]; then
	    c_env=`basename $CONDA_DEFAULT_ENV`
	elif [[ $VIRTUAL_ENV ]]; then
 	    c_env=`basename $VIRTUAL_ENV`
    else
        c_env='root'
    fi

    #if its base/root I definately want to know
    if [[ $c_env == "base" ]]; then
      PS1+="$BRed($c_env)$IBlue]"
    elif [[ $cenv == "root" ]]; then
      PS1+="$BRed($c_env)$IBlue]"
    else
      PS1+="$BGreen($c_env)$IBlue]"
    fi



    # Print the working directory and prompt marker in blue, and reset
    # the text color to the default.
    PS1+="$IBlue\$:$Reset "
}
export PROMPT_COMMAND='set_prompt'