# Peterson's algorithm for RISC-V

Simple implementation of *one* Peterson's lock.

## Install
For Ubuntu 20.04 
```
sudo apt install gcc-riscv64-linux-gnu make
```
Or install from the [git source](https://github.com/riscv/riscv-gnu-toolchain) with `make linux` since we need the pthread library for this example (or at least the main file). Or look for other ways to install RISC-V's GNU Toolchain... you decide. 

### Run
Run the code using simulation (uses `riscv64-linux-gnu` toolchain prefix by default).
```
make run
```
Or if your toolchain prefix is something else such as `riscv64-unknown-linux-elf`.
```
make run RISCV_LINUX_GNU_PREFIX=riscv64-unknown-linux-gnu
```
Or
```
export RISCV_LINUX_GNU_PREFIX=riscv64-unknown-linux-gnu
make run
```

### Clean
```
make clean
```
