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
Now you can clone this repo and run make
```
git clone https://github.com/EduardRosert/morpheus-jupyterhub.git
cd morpheus-jupyterhub
```
Continue with step [Setup European Weather Cloud](#setup-european-weather-cloud).


## Install morpheus cli
If you haven't already, install the morpheus command line tool: https://github.com/gomorpheus/morpheus-cli

## Setup European Weather Cloud
If you haven't already, set up a connection to the european weather cloud and log in
```bash
make setup-cloud
make login
```

## Install Jupyterhub installation workflow on the European Weather Cloud:
Install all necessary cypher secrets, tasks, scripts, workflows and blueprints. As of now you need to provide your username and a git access token for https://git.ecmwf.int .
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