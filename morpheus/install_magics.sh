set -ex \
    && apt-get update

# Install tools
set -ex \
    && apt-get install --yes --no-install-suggests --no-install-recommends \
        wget \
        git

# Install build tools.
set -ex \
    && apt-get install --yes --no-install-suggests --no-install-recommends \
      bison \
      bzip2 \
      ca-certificates \
      cmake \
      curl \
      file \
      flex \
      g++-8 \
      gcc-8 \
      gfortran-8 \
      git \
      make \
      patch \
      sudo \
      swig \
      xz-utils

set -ex \
    && ln -s /usr/bin/g++-8 /usr/bin/g++ \
    && ln -s /usr/bin/gcc-8 /usr/bin/gcc \
    && ln -s /usr/bin/gfortran-8 /usr/bin/gfortran

# Install build-time dependencies.
set -ex \
    && apt-get install --yes --no-install-suggests --no-install-recommends \
      libarmadillo-dev \
      libatlas-base-dev \
      libboost-dev \
      libbz2-dev \
      libc6-dev \
      libcairo2-dev \
      libcurl4-openssl-dev \
      libeigen3-dev \
      libexpat1-dev \
      libfreetype6-dev \
      libfribidi-dev \
      libgdal-dev \
      libgeos-dev \
      libharfbuzz-dev \
      libhdf5-dev \
      libjpeg-dev \
      liblapack-dev \
      libncurses5-dev \
      libnetcdf-dev \
      libpango1.0-dev \
      libpcre3-dev \
      libpng-dev \
      libproj-dev \
      libreadline6-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml-parser-perl \
      libxml2-dev \
      libxslt1-dev \
      libyaml-dev \
      zlib1g-dev

set -ex \
    && pip3 install -r ../requirements.txt

# Install ecbuild
ECBUILD_VERSION=2019.07.1
set -eux \
    && mkdir -p /src/ \
    && cd /src \
    && git clone https://github.com/ecmwf/ecbuild.git \
    && cd ecbuild \
    && git checkout ${ECBUILD_VERSION} \
    && mkdir -p /build/ecbuild \
    && cd /build/ecbuild \
    && cmake /src/ecbuild -DCMAKE_BUILD_TYPE=Release \
    && make -j4 \
    && make install

# Install eccodes
# requires ecbuild
ECCODES_VERSION=2.14.0
set -eux \
    && wget https://confluence.ecmwf.int/download/attachments/45757960/eccodes-${ECCODES_VERSION}-Source.tar.gz?api=v2 --output-document=eccodes.tar.gz \
    && tar -xf eccodes.tar.gz \
    && mkdir -p /src/ \
    && mv eccodes-${ECCODES_VERSION}-Source /src/eccodes \
    && mkdir -p /build/eccodes \
    && cd /build/eccodes \
    && /usr/local/bin/ecbuild /src/eccodes -DECMWF_GIT=https -DCMAKE_BUILD_TYPE=Release \
    && make -j4 \
    && make install \
    && /sbin/ldconfig

# Install Magics

pip3 install \
    eccodes-python \
    Jinja2 \
    Magics

# requires ecbuild, eccodes
MAGICS_BUNDLE_VERSION=4.2.3
#change default to python3.6
alias python=python3
rm /usr/bin/python
ln -s /usr/bin/python3.6 /usr/bin/python

set -eux \
    && wget https://confluence.ecmwf.int/download/attachments/3473464/Magics-${MAGICS_BUNDLE_VERSION}-Source.tar.gz?api=v2 --output-document=magics-bundle.tar.gz \
    && tar -xf magics-bundle.tar.gz \
    && mkdir -p /src/ \
    && mv Magics-${MAGICS_BUNDLE_VERSION}-Source /src/magics-bundle \
    && mkdir -p /build/magics-bundle \
    && cd /build/magics-bundle \
    && /usr/local/bin/ecbuild /src/magics-bundle -DECMWF_GIT=https -DCMAKE_BUILD_TYPE=Release \
    && make -j4 \
    && make install \
    && /sbin/ldconfig
