#!/bin/bash
ipmitool raw 0x30 0x70 0x66 0x01 0x02 $1
