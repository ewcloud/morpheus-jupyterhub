#!/bin/sh

if [ -z "$MORPHEUS_USER"]; then 
    MORPHEUS_USER="<%=instance.createdByUsername%>"
fi

# Install basic required packages
apt-get install \
        git \
        make \
        python3-pip \
        -y

python3 -m pip install \
    wheel \
    setuptools

# From
# https://jupyterhub.readthedocs.io/en/stable/quickstart.html

apt-get install \
    npm \
    nodejs \
    -y

# Prepare the python3 environment needed
python3 -m pip install \
    jupyterhub
npm install -g \
    configurable-http-proxy

# needed if running the notebook servers locally
python3 -m pip install \
    notebook  \
    xarray \
    cfgrib \
    ecmwf-api-client \
    matplotlib

# run as service
git clone https://github.com/EduardRosert/morpheus-jupyterhub.git
cd morpheus-jupyterhub/morpheus
./install_service.sh

# install eccodes and magics
./install_magics.sh

mkdir -p /shared/eduard
cd /shared
git clone https://github.com/EduardRosert/jupyter-notebooks.git
cp ./jupyter-notebooks/data/* /shared/eduard/
cp ./jupyter-notebooks/*.ipynb /home/${MORPHEUS_USER}/