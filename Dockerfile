FROM hackfin/myhdl_v2we

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

USER root

COPY --from=hackfin/myhdl_v2we /home/testing/notebooks ${HOME}
RUN chown -R ${NB_UID} ${HOME}

USER ${USER}
