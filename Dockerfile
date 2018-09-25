FROM ubuntu:18.04

ARG RCSSSERVER3D_RELEASE=0.7.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6 libode6 libsdl1.2debian ruby libdevil1c2 qt4-default \
    libboost-regex1.65.1 libboost-system1.65.1 libboost-thread1.65.1 \
    && apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN buildDeps='g++ cmake git libfreetype6-dev libode-dev libsdl-dev ruby-dev libdevil-dev libboost-dev libboost-thread-dev libboost-regex-dev libboost-system-dev libqt4-opengl-dev'; \
    apt-get update && apt-get install -y --no-install-recommends $buildDeps \
    && git clone --branch RCSSSERVER3D_${RCSSSERVER3D_RELEASE}_RELEASE --depth 1 https://gitlab.com/robocup-sim/SimSpark.git /tmp/SimSpark \
    && mkdir -p /tmp/SimSpark/spark/build && cd /tmp/SimSpark/spark/build && cmake .. && make -j$(nproc) && make install && ldconfig \
    && mkdir -p /tmp/SimSpark/rcssserver3d/build && cd /tmp/SimSpark/rcssserver3d/build && cmake .. && make -j$(nproc) && make install && ldconfig \
    && rm -fr /tmp/SimSpark \
    && apt-get purge -y --auto-remove $buildDeps && rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH=/usr/local/lib/simspark:/usr/local/lib/rcssserver3d

