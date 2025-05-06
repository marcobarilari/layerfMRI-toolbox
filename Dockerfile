# Use an Ubuntu base image
FROM ubuntu:20.04

# Notes to self:
# - To build the image, run:
#   docker build -t layerfmri_toolbox .
# - To build the image with a specific tag, run:
#   docker build -t layerfmri_toolbox:latest .
# - To retag the image, run:
#   docker tag layerfmri_toolbox:latest layerfmri_toolbox:0.1.0
# - To run the image, use:
#   docker run -it --rm layerfmri_toolbox
# - To run a command inside the container, use:
#   docker run -it --rm layerfmri_toolbox <command>
# - To run a bash shell inside the container, use:
#   docker run -it --rm layerfmri_toolbox bash
# - To run a bash shell inside the container with a mounted volume, use:
#   docker run -it --rm -v /path/to/local/dir:/path/to/container/dir layerfmri_toolbox bash
# - To run a bash shell inside the container with a mounted volume and a specific user, use:
#   docker run -it --rm -v /path/to/local/dir:/path/to/container/dir --user $(id -u):$(id -g) layerfmri_toolbox bash
# - To run a bash shell inside the container with a mounted volume and a specific user and group, use:
#   docker run -it --rm -v /path/to/local/dir:/path/to/container/dir --user $(id -u):$(id -g) layerfmri_toolbox bash
# - To run a bash shell inside the container with a mounted volume and a specific user and group and a specific working directory, use:
#   docker run -it --rm -v /path/to/local/dir:/path/to/container/dir --user $(id -u):$(id -g) -w /path/to/container/dir layerfmri_toolbox bash
# - To run a bash shell inside the container with a mounted volume and a specific user and group and a specific working directory and a specific environment variable, use:
#   docker run -it --rm -v /path/to/local/dir:/path/to/container/dir --user $(id -u):$(id -g) -w /path/to/container/dir -e MY_ENV_VAR=my_value layerfmri_toolbox bash
# - To run a bash shell inside the container with a mounted volume and a specific user and group and a specific working directory and a specific environment variable and a specific command, use:
#   docker run -it --rm -v /path/to/local/dir:/path/to/container/dir --user $(id -u):$(id -g) -w /path/to/container/dir -e MY_ENV_VAR=my_value layerfmri_toolbox bash -c "MY_COMMAND"
# - To run a bash shell inside the container with a mounted volume and a specific user and group and a specific working directory and a specific environment variable and a specific command and a specific entrypoint, use:
#   docker run -it --rm -v /path/to/local/dir:/path/to/container/dir --user $(id -u):$(id -g) -w /path/to/container/dir -e MY_ENV_VAR=my_value layerfmri_toolbox bash -c "MY_COMMAND" --entrypoint /bin/bash

LABEL org.opencontainers.image.source="https://github.com/marcobarilari/layerfMRI-toolbox"
LABEL org.opencontainers.image.url="https://github.com/marcobarilari/layerfMRI-toolbox"
LABEL org.opencontainers.image.documentation="https://github.com/marcobarilari/layerfMRI-toolbox"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.title="layerfmri_toolbox"
LABEL org.opencontainers.image.description="A toolbox to ease layer fMRI analysis"

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
## basic OS tools install octave
RUN apt-get update -qq && \
    apt-get -qq -y --no-install-recommends install \
        apt-utils \
        build-essential \
        ca-certificates \
        curl \
        default-jre \
        fonts-freefont-otf \
        ghostscript \
        git \
        gnuplot-x11 \
        libcurl4-gnutls-dev \
        liboctave-dev \
        octave \
        octave-common \
        octave-io \
        octave-image \
        octave-signal \
        octave-statistics \
        python3-pip \
        python3 \
        software-properties-common \
        unzip \
        zip && \
        apt-get clean && \
        rm -rf \
        /tmp/hsperfdata* \
        /var/*/apt/*/partial \
        /var/lib/apt/lists/* \
        /var/log/apt/term*

# Copy AFNI tools from the official AFNI image
# COPY --from=afni/afni_make_build:latest /opt/afni /opt/afni
# RUN echo "export PATH=/opt/afni:$PATH" >> ~/.bashrc

# Install FreeSurfer 7
# freesurfer/freesurfer:7.4.1
# RUN wget -qO- https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.2/freesurfer-linux-ubuntu20_amd64-7.3.2.tar.gz | tar -xz -C /opt \
#     && echo "export FREESURFER_HOME=/opt/freesurfer" >> ~/.bashrc \
#     && echo "source /opt/freesurfer/SetUpFreeSurfer.sh" >> ~/.bashrc
FROM freesurfer/freesurfer:7.1.1
COPY license /usr/local/freesurfer/.license
RUN echo "export FREESURFER_HOME=/usr/local/freesurfer" >> ~/.bashrc \
    && echo "source /usr/local/freesurfer/SetUpFreeSurfer.sh" >> ~/.bashrc
    
# Install ANTs (version 2.3.4)
# Install ANTs (version 2.3.4)
# COPY --from=kaczmarj/ants:2.3.4 /opt/ants /opt/ants
# RUN echo "export PATH=/opt/ants:$PATH" >> ~/.bashrc

## Install SPM
RUN mkdir /opt/spm12 && \
    curl -SL https://github.com/spm/spm12/archive/r7771.tar.gz | \
    tar -xzC /opt/spm12 --strip-components 1 && \
    curl -SL https://raw.githubusercontent.com/spm/spm-octave/main/spm12_r7771.patch | \
    patch -p0 && \
    make -C /opt/spm12/src PLATFORM=octave distclean && \
    make -C /opt/spm12/src PLATFORM=octave && \
    make -C /opt/spm12/src PLATFORM=octave install && \
    ln -s /opt/spm12/bin/spm12-octave /usr/local/bin/spm12

# Set the default command to run a shell
CMD ["/bin/bash"]