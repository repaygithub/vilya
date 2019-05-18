ARG TF_PACKAGE={{ tensorflow }}

RUN pip --no-cache-dir install ${TF_PACKAGE}