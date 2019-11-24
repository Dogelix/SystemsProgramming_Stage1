# Create the boot loader binaries

.DEFAULT_GOAL:=all

.SUFFIXES: .img .bin .asm .sys .o .lib
.PRECIOUS: %.o

IMAGE=uodos

%.bin: %.asm
	nasm -w+all -f bin -o $@ $<
	
boot.bin: boot.asm functions_16.asm bpb.asm

boot2.bin: boot2.asm functions_16.asm a20.asm messages.asm floppy16.asm bpb.asm display_sector_16.asm user_input.asm conversion_16.asm

$(IMAGE).img: boot.bin boot2.bin
#	Get the blank disk image
	cp diskimage/uodos.img $(IMAGE).img
#	Copy the boot sector over to the disk image
	dd status=noxfer conv=notrunc if=boot.bin of=$(IMAGE).img
#	Copy the 2nd boot stage sector to the disk image
	dd status=noxfer conv=notrunc seek=1 if=boot2.bin of=$(IMAGE).img
	
all: clean $(IMAGE).img

clean:
	rm -f boot.bin
	rm -f boot2.bin
	rm -f $(IMAGE).img
	rm -f $(IMAGE).img.lock

rebuild: clean all