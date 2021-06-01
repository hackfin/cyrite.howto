FROM hackfin/myhdl_v2we

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

USER root

RUN mv /home/testing ${HOME} && usermod --login jovyan testing

ENV PATH "$PATH:${HOME}/.local/bin"

COPY --from=hackfin/myhdl_v2we /home/testing/notebooks ${HOME}/notebooks
RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}
USER ${USER}
