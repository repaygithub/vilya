LABEL maintainer="Dylan Storey <dstorey@repay.com>"
ARG NB_USER="elrond"
ARG NB_UID="1000"
ARG NB_GID="100"


USER root

ENV NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    SHELL='/bin/bash'


ADD files/fix-permissions /usr/local/bin/fix-permissions

RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -ou $NB_UID $NB_USER && \
    chmod g+w /etc/passwd && \
    fix-permissions /home/$NB_USER



