# QSYM: A Practical Concolic Execution Engine Tailored for Hybrid Fuzzing

## Environment
- Tested on Ubuntu 20.04.01


## Installation using Docker

~~~~{.sh}
# disable ptrace_scope for PIN
$ echo 0|sudo tee /proc/sys/kernel/yama/ptrace_scope

# build docker image
$ sudo docker build -t sqsym ./

# run docker image
$ sudo docker run --cap-add=SYS_PTRACE --privileged -it sqsym /bin/bash

# install structural aware fuzzing component
$ chmod +x enable_sqsym.sh
$ ./home/enable_sqsym.sh
~~~~


## Run hybrid fuzzing with weizz-fuzzer and QSYM

~~~~{.sh}
# require to set the following environment variables
#   weizz_ROOT : weizz-fuzzer directory
#   AFL_ROOT: afl directory (http://lcamtuf.coredump.cx/afl/)
#   INPUT: input seed files
#   OUTPUT: output directory
#   AFL_CMDLINE: command line for a testing program for AFL
#   QSYM_CMDLINE: command line for a testing program for QSYM

# set up path
$ export AFL_PATH=/home/AFL
$ export weizz_ROOT=/home/weizz-fuzzer
$ export AFL_ROOT=/home/AFL
$ export INPUT=/home/input
$ export OUTPUT=/home/output

# set up the path to your target binary
$ export WEIZZ_CMDLINE=/path/to/binary
$ export QSYM_CMDLINE=/path/to/binary 

# make qemu mode work
$ cd /home
$ echo core >/proc/sys/kernel/core_pattern

# run AFL master
$ $weizz_ROOT/weizz -Q -M weizz-master -i $INPUT -o $OUTPUT -- $WEIZZ_CMDLINE
# run AFL slave
$ $AFL_ROOT/afl-fuzz -Q -S weizz-slave -i $INPUT -o $OUTPUT -- $WEIZZ_CMDLINE
# run QSYM under (/workdir/qsym)
$ bin/run_qsym_afl.py -a weizz-slave -o $OUTPUT -n qsym -- $QSYM_CMDLINE
~~~~

## Recommend to run the hybrid fuzzing
~~~~{.sh}
# launch tmux
$ tmux
$ $weizz_ROOT/weizz -Q -M weizz-master -i $INPUT -o $OUTPUT -- $WEIZZ_CMDLINE
$ Ctrl+b d # detach the current session

# launch tmux
$ tmux
$ $AFL_ROOT/afl-fuzz -Q -S weizz-slave -i $INPUT -o $OUTPUT -- $WEIZZ_CMDLINE
$ Ctrl+b d # detach the current session

# launch tmux
$ tmux
$ bin/run_qsym_afl.py -a weizz-slave -o $OUTPUT -n qsym -- $QSYM_CMDLINE

# Now you can just wait for the crash :)

~~~~

## Troubleshooting
If you find that you can't get QSYM to work and you get the `undefined symbol: Z3_is_seq_sort` error in pin.log file, please make sure that you compile and make the target when you're in the virtualenv (env) environment. When you're out of this environment and you compile the target, QSYM can't work with the target binary and issues the mentioned error in pin.log file. This will save your time a lot to compile and make the target from env and then run QSYM on the target, then QSYM will work like a charm!

If you find you can't launch QEMU mode, it migth be lost the AFL_PATH for this situation. You can just simply type this cmd 'export=AFL_PATH=/home/AFL' to solve this error.


## Authors
- Insu Yun <insu@gatech.edu>
- Sangho Lee <sangho@gatech.edu>
- Meng Xu <meng.xu@gatech.edu>
- Yeongjin Jang <yeongjin.jang@oregonstate.edu>
- Taesoo Kim <taesoo@gatech.edu>

## Publications
```
QSYM: A Practical Concolic Execution Engine Tailored for Hybrid Fuzzing

@inproceedings{yun:qsym,
  title        = {{QSYM: A Practical Concolic Execution Engine Tailored for Hybrid Fuzzing}},
  author       = {Insu Yun and Sangho Lee and Meng Xu and Yeongjin Jang and Taesoo Kim},
  booktitle    = {Proceedings of the 27th USENIX Security Symposium (Security)},
  month        = aug,
  year         = 2018,
  address      = {Baltimore, MD},
}
```
