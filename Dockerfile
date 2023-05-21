FROM jokeswar/base-ctl

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yqq && \
    apt-get install -yqq gcc-multilib nasm gdb build-essential \
    valgrind git libglib2.0-dev libfdt-dev libpixman-1-dev \
    zlib1g-dev ninja-build wget tar && \
    git clone https://gitlab.com/qemu-project/qemu && \
    cd qemu && \
    git fetch --all && \
    git checkout staging-7.2 && \
    mkdir build && cd build && \
    ../configure --disable-kvm --target-list="x86_64-softmmu" && \
    make -j $(nproc) && \
    make install && \
    cd ../..
