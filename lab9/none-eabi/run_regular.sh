#!/bin/bash
eabi-gcc c_entry.c -o c_entry.o
eabi-as startup.s -o startup.o
eabi-ld -T vector_table.ld c_entry.o startup.o -o program.elf
eabi-gdb program.elf
