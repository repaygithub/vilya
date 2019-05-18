RUN apt-get clean && rm -rf /var/lib

WORKDIR $HOME

USER $NB_UID
