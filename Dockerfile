FROM hackfin/myhdl_v2we

ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

COPY --from=hackfin/myhdl_v2we /home/testing/notebooks ${HOME}/work

RUN chown -R ${USER} ${HOME}

USER ${USER}
