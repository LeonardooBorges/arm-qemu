#!/bin/bash
arm-none-eabi-gcc -mcpu=arm926ej-s -c t.c -o t.o
arm-none-eabi-as -mcpu=arm926ej-s  ts.S -o ts.o
arm-none-eabi-ld ts.o t.o -T t.ld -o t.elf
arm-none-eabi-objcopy -O binary t.elf t.bin
qemu-system-arm -M versatilepb -cpu arm926 -kernel t.bin -nographic -s -S
