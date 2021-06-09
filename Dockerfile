FROM hackfin/myhdl_v2we:signedness

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

USER root

RUN mv /home/testing ${HOME} && usermod --login jovyan testing

ENV PATH "$PATH:${HOME}/.local/bin"

COPY --from=hackfin/myhdl_v2we:test /home/testing/notebooks ${HOME}/notebooks

COPY ./examples ${HOME}/examples

RUN chown -R ${NB_UID} ${HOME}

WORKDIR ${HOME}
USER ${USER}
