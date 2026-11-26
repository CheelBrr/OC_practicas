build:
	mkdir -p ../../../bin
	gcc -m32 -fno-builtin -c Main.c
	nasm -f elf p10.asm
	gcc -m32 p10.o Main.o -L ../../../lib -lpc_io -no-pie -z noexecstack -o ../../../bin/practica10.exe

run:
	@../../../bin/practica10.exe