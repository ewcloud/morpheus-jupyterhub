
if [ -z "$GIT_USERNAME"]; then
    GIT_USERNAME="<%=cypher.read('password/git-username')%>"
fi
if [ -z "$GIT_ACCESS_TOKEN"]; then 
    GIT_ACCESS_TOKEN="<%=cypher.read('password/git-access-token')%>"
fi
if [ -z "$POLYTOPE_CLIENT_USER"]; then 
    POLYTOPE_CLIENT_USER="<%=cypher.read('password/polytope-client-user')%>"
fi
if [ -z "$POLYTOPE_CLIENT_TOKEN"]; then 
    POLYTOPE_CLIENT_TOKEN="<%=cypher.read('password/polytope-client-token')%>"
fi
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

# Setup access
mkdir -p /home/${MORPHEUS_USER}/.polytope-client/tokens
cat > /home/${MORPHEUS_USER}/.polytope-client/config.yaml <<EOF
username: ${POLYTOPE_CLIENT_USER}
EOF
printf "${POLYTOPE_CLIENT_TOKEN}" >/home/${MORPHEUS_USER}/.polytope-client/tokens/${POLYTOPE_CLIENT_USER}

chmod -R 744 /home/${MORPHEUS_USER}/.polytope-client/
chown -hR ${MORPHEUS_USER} /home/${MORPHEUS_USER}/.polytope-client/

mkdir -p /shared/eduard/
cd /shared/eduard/
git clone https://${GIT_USERNAME}:${GIT_ACCESS_TOKEN}@git.ecmwf.int/scm/lex/polytope-client.git
chmod -R 777 /shared/eduard

cd polytope-client
python3 setup.py sdist
python3 -m pip install dist/polytope_client-0.1.0.tar.gz
python3 -m pip install polytope_client