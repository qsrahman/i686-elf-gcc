FROM ubuntu:20.04

# install dependencies
RUN apt-get update && \
    #apt-get upgrade -y && \
    apt-get install -y build-essential curl wget sudo nano git zsh && \
    apt-get install -y nasm genisoimage grub2 xorriso fonts-powerline

# specify binutils/gcc version
ENV DOWNLOAD_BINUTILS=binutils-2.37
ENV DOWNLOAD_GCC=gcc-11.2.0

# specify TARGET
ENV TARGET=i686-elf
ENV PREFIX=/usr/local

# binutils
RUN wget -q http://ftp.gnu.org/gnu/binutils/$DOWNLOAD_BINUTILS.tar.xz    && \
    tar -xf $DOWNLOAD_BINUTILS.tar.xz                                    && \
    rm $DOWNLOAD_BINUTILS.tar.xz                                         && \
    mkdir -p /srv/build_binutils                                         && \
    cd /srv/build_binutils                                               && \
    /$DOWNLOAD_BINUTILS/configure --target=$TARGET --prefix="$PREFIX"       \
    --with-sysroot --disable-multilib --disable-nls --disable-werror     && \
    make                                                                 && \
    make install                                                         && \
    rm -r /$DOWNLOAD_BINUTILS /srv/build_binutils

# gcc
RUN wget -q http://ftp.gnu.org/gnu/gcc/$DOWNLOAD_GCC/$DOWNLOAD_GCC.tar.xz && \
    tar -xf $DOWNLOAD_GCC.tar.xz                                         && \
    rm $DOWNLOAD_GCC.tar.xz                                              && \
    cd /$DOWNLOAD_GCC && contrib/download_prerequisites                  && \
    mkdir -p /srv/build_gcc                                              && \
    cd /srv/build_gcc                                                    && \
    /$DOWNLOAD_GCC/configure --target=$TARGET --prefix="$PREFIX"            \
    --disable-multilib --disable-nls --disable-werror                       \
    --enable-languages=c,c++ --without-headers                           && \
    make all-gcc                                                         && \
    make all-target-libgcc                                               && \
    make install-gcc                                                     && \
    make install-target-libgcc                                           && \
    rm -r /$DOWNLOAD_GCC /srv/build_gcc

# cleanup
RUN apt-get clean autoclean                                              && \
    apt-get autoremove -y                                                && \
    rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log

RUN useradd -ms /bin/zsh devuser && echo "devuser:devuser" | chpasswd && adduser devuser sudo
USER devuser

RUN mkdir -p /home/devuser/.antigen
RUN curl -L git.io/antigen > /home/devuser/.antigen/antigen.zsh
COPY zshrc /home/devuser/.zshrc
COPY p10k.zsh /home/devuser/.p10k.zsh
RUN echo "devuser" | sudo -S chown -R devuser:devuser /home/devuser/.zshrc /home/devuser/.p10k.zsh
RUN /bin/zsh /home/devuser/.zshrc

WORKDIR /home/devuser/work

CMD ["zsh"]
