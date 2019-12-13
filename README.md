# Jupyterhub on the European Weather Cloud
VM with Jupyterhub running on the European Weather Cloud.

# Installation instructions
You need ``make``and [morpheus-cli](https://github.com/gomorpheus/morpheus-cli) to run the scripts provided. Alternatively you can use the docker image ``eduardrosert/morpheus-mgmt`` to run the scripts.

## Using the docker
If you have docker running on your machine, start an interactive shell using the image ``eduardrosert/morpheus-mgmt`` which provides all the necessary components:
```
docker run --rm -it eduardrosert/morpheus-mgmt bash

root@de91d61544e4:/#
```
Continue with step [Setup European Weather Cloud](#setup-european-weather-cloud).

## Install morpheus cli
To run the scripts in this repository on your machine, you need to install the [morpheus command line tool](https://github.com/gomorpheus/morpheus-cli) and ``make``.

## Setup European Weather Cloud
Clone this repo to a local directory:
```
git clone https://github.com/ewcloud/morpheus-jupyterhub.git
cd morpheus-jupyterhub
```
Set up a connection to the european weather cloud and log in (skip this step if the connection is already set up):
```bash
make setup-cloud
make login
```
If you login with a subtenant account, your username is ``<subtenancy>\<username>``, e.g. ``mysubt\janedoe``.


## Install Jupyterhub installation workflow on the European Weather Cloud:
Install all necessary cypher secrets, tasks, scripts, workflows and blueprints. If you run this script for the first time, you'll need to provide your username and a git access token for https://git.ecmwf.int .
```bash
make install
```

## Create a Jupyterhub Instance from json
First run
```bash
make INSTANCE_NAME=jupyterhub-000 create-instance
```

Once the instance status is ``RUNNING``, you can execute the Jupyterhub installation workflow on the specified instance, this will install Jupyterhub, as well as ecCodes, Magics and some other useful software.
```bash
make INSTANCE_NAME=jupyterhub-000 run-workflows
```

## Create an Jupyterhub Instance using Blueprints
To create a VM running jupterhub, go to ``Provisioning > Apps``, click the ``+ Add`` button and select the Blueprint "Jupyterhub on Ubuntu".

# Cleanup
Run the following to clean up all the morpheus objects (tasks, workflows, blueprints) created by ``make install`` (this will not remove any instances!):
```bash
make cleanup
```
You need to remove created secrets manually by running
```bash
# remove git secrets
make cleanup-secrets
# remove polytope secrets
make cleanup-secrets-polytope
```