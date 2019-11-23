#!/bin/bash

./fan_full.sh
sleep 3
./set_fan_cpu.sh 0x30
./set_fan_peri.sh 0x64
