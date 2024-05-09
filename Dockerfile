FROM hackfin/cyrite:0.1b-rc0 AS template

FROM template

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

USER root

RUN mv /home/cyrite ${HOME} && usermod --login ${NB_USER} cyrite

ENV PATH "$PATH:${HOME}/.local/bin"


# COPY --chown=${USER}:users --from=template \
# 	/home/testing/notebooks ${HOME}/notebooks

COPY --chown=${USER}:users ./examples ${HOME}/examples
COPY --chown=${USER}:users ./howto ${HOME}/howto
COPY --chown=${USER}:users ./*.ipynb ${HOME}/

WORKDIR ${HOME}
USER ${USER}
