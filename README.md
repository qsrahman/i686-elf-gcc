# i686-elf-gcc

A Docker-powered GCC cross compiler toolchain for building bootable images
and operating system services. This uses the method described by OSDev wiki
to [make an i686-elf cross compiler](https://wiki.osdev.org/GCC_Cross-Compiler).

## Installation

Get the prebuilt image via Docker Hub:

```sh
docker pull qsrahmans/i686-elf-gcc:dev
```

## Usage

Using the compiler:

```sh
docker run --rm qsrahmans/i686-elf-gcc:dev bash -c 'i686-elf-gcc --version'
```

GRUB is also available in this image:

```sh
docker run --rm qsrahmans/i686-elf-gcc:dev bash -c 'grub-mkrescue --version'
```

```sh
docker run --rm -it qsrahmans/i686-elf-gcc:dev -v "${PWD}":/home/devuser/work
```

## Building from Dockerfile

```sh
docker build -t qsrahmans/i686-elf-gcc:dev .
```
