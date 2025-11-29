#!/bin/sh

kernel_xxd(){
	ls -l ~/git/freetz-ng/build/*/kernel/
	cp ~/git/freetz-ng/source/kernel/ref-alder-5690_08.01/linux-5.4/vmlinux kernel.elf
	cp ~/git/freetz-ng/build/original/kernel/kernel.raw kernel.ori.lzma
	cp ~/git/freetz-ng/build/modified/kernel/kernel.raw kernel.mod.lzma
	lzma -fd kernel.ori.lzma
	lzma -fd kernel.mod.lzma
	xxd -c4 kernel.ori > kernel.ori.xxd
	xxd -c4 kernel.mod > kernel.mod.xxd
	ls -lt
}
kernel_diff(){
	kernel_xxd
	diff -u <(sed -rn 's/.{8}(.*)/\1/p' kernel.ori.xxd) <(sed -rn 's/.{8}(.*)/\1/p' kernel.mod.xxd) > kernel.diff
	ls -lt
}
ksloc(){
	readelf -S $2 | sed -rn 's/.* '$3' +[^ ]+ +([^ ]+) ([^ ]+) ([^ ]+).*/0x'\\$1'/p'
}
kernel_section(){
	tail -c+$((1+$(ksloc 2 $1 $2))) $1 | head -c$(($(ksloc 3 $1 $2)))
}
relloc(){
	printf '%x\n' $(($(ksloc 1 $1 $3)-$(ksloc 1 $1 $2)))
}
