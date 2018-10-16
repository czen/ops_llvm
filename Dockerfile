#FROM ubuntu:16.04
FROM amardikian/clang-3.8

RUN apt-get update && \
    apt-get -y install p7zip-full && \
    apt-get -y install qt5-default libqt5svg5-dev && \
    apt-get -y install wget && \
    apt-get clean && \
    apt-get -y autoremove
    
RUN mkdir ~/Src && \
    cd ~/Src && \
    wget http://llvm.org/releases/3.3/llvm-3.3.src.tar.gz && \
    wget http://llvm.org/releases/3.3/cfe-3.3.src.tar.gz  && \
    tar -xvf llvm-3.3.src.tar.gz && \
    tar -xvf cfe-3.3.src.tar.gz && \
    mv -T cfe-3.3.src llvm-3.3.src/tools/clang && \
    mkdir llvm-3.3.build && \
    cd llvm-3.3.build && \
    cmake && \
       -D CMAKE_BUILD_TYPE=Debug                               \
       -D LLVM_REQUIRES_RTTI=1                                 \
       -D LLVM_TARGETS_TO_BUILD="X86;Sparc;ARM"                \
       -D BUILD_SHARED_LIBS=1                                  \
       -D LLVM_INCLUDE_EXAMPLES=0 \
       -D LLVM_INCLUDE_TESTS=0 \
       -D CMAKE_INSTALL_PREFIX=~/Lib/llvm-3.3.install \       \
        ../llvm-3.3.src && \
    make  && \
    make install

RUN mkdir ~/ops && \
    cd ~/ops && \
    wget --no-check-certificate https://yunohost.taccessviolation.ru/jirafeau/f.php?h=1-CnxVbm&d=1 -O ops.7z && \
    7z x ops.7z && \
    rm ops.7z && \
    cd ..
    
RUN mkdir ops-build && cd ops-build && \
    cmake \
      -D CMAKE_BUILD_TYPE=Debug            \
      -D OPS_LLVM_DIR=~/Lib/llvm-3.3.install \
      -D BUILD_SHARED_LIBS=1                 \
      ../ops && \
    make
    