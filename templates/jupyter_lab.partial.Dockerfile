
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    sudo apt-get install -y nodejs

RUN pip install    \
    notebook==5.7.8 \
    jupyterhub==1.0.0 \
    jupyterlab==0.35.5 && \
    jupyter labextension install @jupyterlab/hub-extension@^0.12.0 && \
    npm cache clean --force &&\
    jupyter notebook --generate-config && \
    rm -rf /home/$NB_USER/.cache/yarn &&\
    fix-permissions /home/$NB_USER

EXPOSE 8888



ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
ENV JUPYTER_ENABLE_LAB=1
CMD ["start-notebook.sh"]

COPY files/start.sh /usr/local/bin/
COPY files/start-notebook.sh /usr/local/bin/
COPY files/start-singleuser.sh /usr/local/bin/
COPY files/jupyter_notebook_config.py /etc/jupyter/
RUN fix-permissions /etc/jupyter/

