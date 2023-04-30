cd /home
echo core >/proc/sys/kernel/core_pattern

apt-get install wget

# setting up AFL
git clone https://github.com/google/AFL.git
cd AFL
make && make install

# setting up AFL qemu_mode
cd qemu_mode
apt-get -y install libtool libtool-bin automake bison libglib2.0-dev

# wget qemu 2.10.0
wget https://download.qemu.org/qemu-2.10.0.tar.xz
./build_qemu_support.sh

# set AFL_PATH
export AFL_PATH=/home/AFL/

# setting up weizz-fuzzer
cd /home
git clone https://github.com/andreafioraldi/weizz-fuzzer.git
cd weizz-fuzzer
apt-get install -y cmake libpixman-1-dev
make

# create input/output dir and testcase
cd /home
mkdir input output
cd input
echo aaaa > testcase

# set up path
cd /home
export weizz_ROOT=/home/weizz-fuzzer
export AFL_ROOT=/home/AFL
export INPUT=/home/input
export OUTPUT=/home/output

# install tmux
apt-get install -y tmux
