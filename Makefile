ASM = nasm
CC = clang
LD = ld

IMG=/tmp/os-test.img

all:
	@make build
	@make install

clean:
	@echo Removing binaries...
	@echo 
	rm -f ./bin/*

build:
	@echo Building bootloader...
	@echo 
	nasm -f bin -o ./bin/boot ./src/boot.asm

install:
	@echo Writing disk image...
	@echo 
	dd if=./bin/boot of=$(IMG) bs=512 count=1 conv=notrunc
