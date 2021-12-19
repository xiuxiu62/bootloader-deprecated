ASM = nasm
CC = clang
LD = ld

IMG=/tmp/os-test.img

all:
	@make build
	@make install

clean:
	@printf "Removing binaries...\n"
	rm -f ./bin/*

build:
	@printf "Building bootloader...\n"
	if [[ ! -d "bin" ]]; then mkdir bin; fi
	nasm -f bin -o ./bin/boot ./src/boot.asm

install:
	@printf "Writing disk image...\n"
	dd if=./bin/boot of=$(IMG) bs=512 count=1 conv=notrunc
