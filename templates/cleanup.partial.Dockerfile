WORKDIR /home/$NB_USER

COPY files/bash_profile.sh /home/$NB_USER/.bash_profile
COPY files/bashrc /home/$NB_USER/.bashrc
COPY files/git_functions.sh /home/$NB_USER/.git_functions.sh
COPY files/prompt.sh /home/$NB_USER/.prompt.sh

USER $NB_UID
