AS = nasm
C3 = c3c
LD = ld.lld

ASFLAGS = -felf64 -g -F dwarf
C3FLAGS = build -O2 --threads `nproc` -g --fast -fpic
LDFLAGS = -nostdlib -zmax-page-size=0x1000 -pie --no-dynamic-linker -static -ztext

ISO_IMAGE = crystal.iso
ELF_IMAGE = build/crystal.elf

all:
	set -e
	
#	Cleanup
	@rm -rf ./build/*

#	Third party deps
	@$(MAKE) --no-print-directory resources/limine
	@$(MAKE) --no-print-directory resources/echfs
	
#	Build kernel
	$(AS) $(ASFLAGS) src/Crystal/asm/io.S -o io.o
	$(C3) $(C3FLAGS)
	@printf "\n";

#	Invoke linker
	$(LD) $(LDFLAGS) -T resources/linker.ld ./*.o -o $(ELF_IMAGE) 

#	Build ISO
	@rm -rf iso_root
	@mkdir -p iso_root
	@cp $(ELF_IMAGE) resources/limine.cfg resources/limine/build/bin/* iso_root/
	@xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-eltorito-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		iso_root -o $(ISO_IMAGE)
	@resources/limine/build/bin/limine-install $(ISO_IMAGE)
	@rm -rf iso_root

#	Cleanup
	@mv *.o build/

run:
	qemu-system-x86_64 -cdrom $(ISO_IMAGE) -m 256M -d int -M smm=off -S -s

kvm:
	qemu-system-x86_64 -cdrom $(ISO_IMAGE) -m 256M -enable-kvm -cpu host -debugcon stdio

clean:
	@rm -rf build/*
