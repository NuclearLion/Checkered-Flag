FROM jokeswar/base-ctl

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -yqq && \
    apt-get install -yqq gcc-multilib nasm gdb build-essential \
    valgrind git libglib2.0-dev libfdt-dev libpixman-1-dev \
    zlib1g-dev ninja-build && \
    wget https://download.qemu.org/qemu-8.0.0.tar.xz && \
    tar xvJf qemu-8.0.0.tar.xz && \
    cd qemu-8.0.0/ && \
    ./configure --disable-kvm --target-list="x86_64-softmmu" && \
    make -j $(nproc) && \
    make install && \
    cd ..
