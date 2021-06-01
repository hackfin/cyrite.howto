FROM hackfin/myhdl_v2we

ARG MY_USER=testing
ARG NB_UID=1000
ENV USER ${MY_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${MY_USER}

USER root

ENV PATH "$PATH:${HOME}/.local/bin"

COPY --from=hackfin/myhdl_v2we /home/testing/notebooks ${HOME}/notebooks
RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}
USER ${USER}
