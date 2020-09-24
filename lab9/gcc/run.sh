#!/bin/bash
arm-elf-gcc -g -c test.c -o test.o
arm-elf-as --gstabs+ startup.s -o startup.o
arm-elf-ld -T test.ld test.o startup.o -o test.elf
arm-elf-gdb test.elf
