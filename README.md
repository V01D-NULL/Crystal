## Crystal

Crystal is a hobbyist x86-64 kernel written in C3.

C3 is a C-like language striving to be an evolution of C, rather than a completely new language. As an alternative in the C/C++ niche it aims to be fast and close to the metal.

Why choose a language like C3? 

Well I wanted to try something new, explore new compilers, report it's bugs due to it's experimental nature and take a break from the ol' C language.

## Build instructions:
- Clone this repository and it's submodules: `git clone https://github.com/V01D-NULL/Crystal.git --recursive`
- Install / compile the dependencies: `make deps`
- Run the kernel (kvm strongly encouraged): `make && make kvm`

## Makefile targets:
- all -> Build, assemble and link all files and generate an ISO. This is the default target.
- dependencies -> Install or build third party dependencies
- deps -> alias of dependencies
- run -> Run crystal using qemu, debug logs enabled, no kvm.
- kvm -> Run crystal using qemu, debug logs disable, E9 port enabled (routing output to stdio), uses kvm.
- debug -> Run crystal using qemu, debug logs enabled, gdb server running.
- clean -> Remove all build files.

## Resources:
    C3: https://github.com/c3lang/c3c