FROM ghdl/ext:broadway

RUN apt-get update \
    && apt-get -y --allow-unauthenticated install \
    verilog \
    verilator \
    git \
    && apt-get clean

WORKDIR /workspace

ARG USERNAME="ece206-student"
ARG USER_UID="1000"
ARG USER_GID=$USER_UID

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}

RUN apt-get update \
    && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && apt-get clean

USER ${USERNAME}

RUN ["sudo", "chmod", "+x", "/etc/broadway.sh"]
CMD [ "bash", "-c", "/etc/broadway.sh && sleep infinity" ]