AS = nasm
C3 = c3c
LD = ld.lld

ASFLAGS = -felf64 -g -F dwarf
C3FLAGS = build -O2 --threads `nproc` -g --fast
LDFLAGS = -nostdlib -zmax-page-size=0x1000 -static

ISO_IMAGE = crystal.iso
ELF_IMAGE = build/crystal.elf

all:
	set -e
	
#	Cleanup
	@rm -rf ./build/*

#	Build kernel
	$(AS) $(ASFLAGS) src/Crystal/asm/io.S -o io.S.o
	$(AS) $(ASFLAGS) src/Crystal/asm/gdt.S -o gdt.S.o
	$(AS) $(ASFLAGS) src/Crystal/asm/idt.S -o idt.S.o
	$(AS) $(ASFLAGS) src/Crystal/asm/segments.S -o segments.S.o

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

# Third party deps
deps:
	@$(MAKE) -C resources/limine --no-print-directory
	@$(MAKE) -C resources/echfs --no-print-directory
	
# Alias for deps
dependencies:
	@$(MAKE) -C resources/limine --no-print-directory
	@$(MAKE) -C resources/echfs --no-print-directory

run:
	qemu-system-x86_64 -cdrom $(ISO_IMAGE) -m 256M -d int -M smm=off

kvm:
	qemu-system-x86_64 -cdrom $(ISO_IMAGE) -m 256M -enable-kvm -cpu host -debugcon stdio

uefi:
	qemu-system-x86_64 -cdrom $(ISO_IMAGE) -m 256M -enable-kvm -cpu host -debugcon stdio -bios /usr/share/ovmf/OVMF.fd

debug:
	qemu-system-x86_64 -cdrom $(ISO_IMAGE) -m 256M -d int -M smm=off -S -s

clean:
	@rm -rf build/*
