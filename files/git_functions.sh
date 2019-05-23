#!/bin/bash
# Utility functions for working with git

#Some really simple aliases up top
alias gs='git status'
alias gcob='git checkout -b'
alias gco='git checkout'
alias gbd='git branch --delete'

_is_git_repo(){
###########################################################
# Test if we're currently in a git repository instance
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    the current name of the branch (or null)
###########################################################

  if [[ "git rev-parse --is-inside-work-tree &> /dev/null)" != 'true' ]] && git rev-parse --quiet --verify HEAD &> /dev/null; then
    return 0
  fi
    return 1
}

parse_git_branch() {
###########################################################
# Get the current branch of the git repository
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    the current name of the branch (or null)
###########################################################
  if _is_git_repo; then
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  fi
}

git_new(){
###########################################################
# Flags if there are new files unstaged files in the git repo
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    U - for unstaged files exist
###########################################################

  if _is_git_repo; then
    if [[ $(git ls-files --other --exclude-standard 2> /dev/null) ]];then
      echo "U "
    fi
  fi
}

which_new(){
###########################################################
# Get a list of which files are new in the repo
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    U - for unstaged files exist
###########################################################

  if _is_git_repo; then
    git ls-files --other
  fi
}



git_staged(){
###########################################################
# Flags if there are new files staged files in the git repo
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    S - for staged files exist
###########################################################

  if _is_git_repo; then
    git diff-index --cached --quiet --ignore-submodules HEAD 2> /dev/null
    (( $? && $? != 128)) && echo "S "
  fi
}

which_staged(){
###########################################################
# Get a list of which files have been staged
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    None
###########################################################
  if _is_git_repo; then
    git diff-index --cached HEAD | tr -s ' ' | cut -d ' ' -f 5
  fi
}

git_modified(){
###########################################################
# Flags if there are modified files in the git repo
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    M - for modified files exist
###########################################################
  if _is_git_repo; then
    git diff --no-ext-diff --ignore-submodules --quiet --exit-code || echo "M "
  fi
}


which_modified(){
###########################################################
# Get a list of which files have been modified
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    None
###########################################################
  if _is_git_repo; then
    git ls-files --modified
  fi
}

git_graph(){
###########################################################
# Prints a pretty gitlog
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    None
###########################################################
  if _is_git_repo; then
    git log --graph --oneline --decorate --all
  fi
}

git_log(){
###########################################################
# single line per commit git log
# Globals:
#    None
# Arguments:
#    None
# Returns:
#    None
###########################################################

    if _is_git_repo; then
        git log --pretty=format:"%h %ad %s" --date=short --all
    fi
}


